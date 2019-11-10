# frozen_string_literal: true

describe '[Container] Container reloading' do
  specify 'reinstantiates existing container with initial dependencies' do
    database_dependency_stub = Object.new
    cache_dependency_stub = Object.new
    randomizer_dependency_stub = Object.new

    container_klass = Class.new(SmartCore::Container) do
      namespace :storages do
        register(:database) { database_dependency_stub }
        register(:cache) { cache_dependency_stub }
      end

      register(:randomizer) { randomizer_dependency_stub }
    end

    container = container_klass.new

    # re-register dependnecies
    container.register(:randomizer) { :randomizer }
    container.namespace(:storages) { register(:database) { :database } }
    container.namespace(:storages) { register(:cache) { :cache } }

    # register new dependencies
    container.register(:logger) { :logger }
    container.namespace(:system) { register(:queue) { :sidekiq } }

    # check that our new dependencies are created
    expect(container.resolve(:randomizer)).to eq(:randomizer)
    expect(container.resolve(:storages).resolve(:database)).to eq(:database)
    expect(container.resolve(:storages).resolve(:cache)).to eq(:cache)
    expect(container.resolve(:logger)).to eq(:logger)
    expect(container.resolve(:system).resolve(:queue)).to eq(:sidekiq)

    # reload!
    container.reload!

    # check that we have old dependencies
    expect(container.resolve(:randomizer)).to eq(randomizer_dependency_stub)
    expect(container.resolve(:storages).resolve(:database)).to eq(database_dependency_stub)
    expect(container.resolve(:storages).resolve(:cache)).to eq(cache_dependency_stub)
    # check that we have no new dependencies
    expect do
      container.resolve(:logger)
    end.to raise_error(SmartCore::Container::NonexistentEntityError)
    expect do
      container.resolve(:system)
    end.to raise_error(SmartCore::Container::NonexistentEntityError)
  end

  specify "new definitions from a container's class will be considered too" do
    container_klass = Class.new(SmartCore::Container) do
      namespace :storages do
        register(:database) { :database }
      end
    end

    container = container_klass.new

    expect(container.resolve(:storages).resolve(:database)).to eq(:database)
    expect do
      container.resolve(:storages).resolve(:cache)
    end.to raise_error(SmartCore::Container::NonexistentEntityError)

    # register new dependencies on class-level dependency tree
    container_klass.namespace(:storages) { register(:cache) { :cache } }

    # reload existing container and check that new definitions are exist
    container.reload!

    expect(container.resolve(:storages).resolve(:database)).to eq(:database)
    expect(container.resolve(:storages).resolve(:cache)).to eq(:cache)
  end

  specify 'resets frozen state' do
    container = Class.new(SmartCore::Container).new

    expect(container.frozen?).to eq(false)
    container.freeze!
    expect(container.frozen?).to eq(true)
    container.reload!
    expect(container.frozen?).to eq(false)
  end
end
