# frozen_string_literal: true

describe '[Container] Definition and instantiation' do
  specify 'definition DSL and dependency resolving' do
    cache_dependency_stub = Object.new
    database_dependency_stub = Object.new
    messaging_dependency_stub = Object.new
    api_dependency_stub = Object.new
    logger_stub = Object.new

    container_klass = Class.new(QuantumCore::Container) do
      # create dependency namespace
      namespace :storages do
        register(:cache) { cache_dependency_stub }
        register(:database) { database_dependency_stub }
      end

      # open existing namespace and register new dependencies
      namespace :storages do
        register(:messaging) { messaging_dependency_stub }
      end

      # create new dependency namespace
      namespace :api do
        # create nested namespace
        namespace :common do
          register(:general) { api_dependency_stub }
        end
      end

      # register dependnecy on the root of dependency tree
      register(:logger) { logger_stub }
    end

    # create container instance
    container = container_klass.new

    expect(container.resolve(:storages).resolve(:cache)).to eq(cache_dependency_stub)
    expect(container.resolve(:storages).resolve(:database)).to eq(database_dependency_stub)
    expect(container.resolve(:storages).resolve(:messaging)).to eq(messaging_dependency_stub)
    expect(container.resolve(:api).resolve(:common).resolve(:general)).to eq(api_dependency_stub)
    expect(container.resolve(:logger)).to eq(logger_stub)
  end

  specify 'define container as frozen that means it should be freezed after instantiation' do
    # NOTE: initially it should be non-frozen
    non_frozen_container_klass = Class.new(QuantumCore::Container) {}
    non_frozen_container = non_frozen_container_klass.new
    expect(non_frozen_container.frozen?).to eq(false)

    # NOTE: check freezing macros
    frozen_container_klass = Class.new(QuantumCore::Container) { freeze_state! }
    frozen_container = frozen_container_klass.new
    expect(frozen_container.frozen?).to eq(true)
  end

  specify 'instance-level namespace/dependency registration/resolving' do
    database_dependency_stub = Object.new
    logger_dependency_stub = Object.new
    api_client_dependency_stub = Object.new
    randomizer_dependency_stub = Object.new

    container_klass = Class.new(QuantumCore::Container) do
      namespace :database do
        register(:connection) { database_dependency_stub }
      end

      register(:logger) { logger_dependency_stub }
    end

    container = container_klass.new

    # register new namespace on instance level
    container.namespace(:api) { register(:client) { api_client_dependency_stub } }
    # register new dependency on instance level
    container.register(:randomizer) { randomizer_dependency_stub }

    # check already existing dependencies
    expect(container.resolve(:database).resolve(:connection)).to eq(database_dependency_stub)
    expect(container.resolve(:logger)).to eq(logger_dependency_stub)

    # check new registered namespaces and dependencies
    expect(container.resolve(:api).resolve(:client)).to eq(api_client_dependency_stub)
    expect(container.resolve(:randomizer)).to eq(randomizer_dependency_stub)

    another_container = container_klass.new

    # check that new registered dependnecies does not mutate class-level dependency tree
    expect { another_container.resolve(:api) }.to raise_error(
      QuantumCore::Container::NonexistentEntityError
    )
    expect { another_container.resolve(:randomizer) }.to raise_error(
      QuantumCore::Container::NonexistentEntityError
    )
  end

  specify '(definition) namespace and dependency can not overlap each other' do
    expect do # NOTE: dependency overlaps existing namespace
      Class.new(QuantumCore::Container) do
        namespace(:database) {}
        register(:database) {} # overlap!
      end
    end.to raise_error(QuantumCore::Container::DependencyOverNamespaceOverlapError)

    expect do # NOTE: namespace overlaps existing dependency
      Class.new(QuantumCore::Container) do
        register(:database) {}
        namespace(:database) # overlap!
      end
    end.to raise_error(QuantumCore::Container::NamespaceOverDependencyOverlapError)
  end

  specify '(instance) namespace and dependency can not overlap each other' do
    container = Class.new(QuantumCore::Container).new
    # NOTE: dependency overlaps existing namespace
    container.namespace(:database) {}
    expect { container.register(:database) {} }.to raise_error(
      QuantumCore::Container::DependencyOverNamespaceOverlapError
    )

    container = Class.new(QuantumCore::Container).new
    # NOTE: namespace overlaps existing dependency
    container.register(:database) {}
    expect { container.namespace(:database) {} }.to raise_error(
      QuantumCore::Container::NamespaceOverDependencyOverlapError
    )
  end

  specify 'inherited dependency tree does not affect the parent dependency tree' do
    database_adapter_stub = Object.new
    database_logger_stub = Object.new
    base_api_client_stub = Object.new
    child_api_client_stub = Object.new
    database_logger_stub = Object.new
    queue_adapter_stub = Object.new

    base_container_klass = Class.new(QuantumCore::Container) do
      namespace(:database) do
        register(:adapter) { database_adapter_stub }
      end

      register(:api_client) { base_api_client_stub }
    end

    child_container_klass = Class.new(QuantumCore::Container) do
      namespace(:database) do
        register(:logger) { database_logger_stub }
      end

      register(:api_client) { child_api_client_stub }
      register(:queue_adapter) { queue_adapter_stub }
    end

    base_container = base_container_klass.new
    child_container = child_container_klass.new

    # no affections from child_container_klass
    expect { base_container.resolve(:database).resolve(:logger) }.to raise_error(
      QuantumCore::Container::NonexistentEntityError
    )
    expect { base_container.resolve(:queue_adapter) }.to raise_error(
      QuantumCore::Container::NonexistentEntityError
    )
    expect(base_container.resolve(:api_client)).to eq(base_api_client_stub)

    # inherited container has own dependency tree
    expect(child_container.resolve(:database).resolve(:logger)).to eq(database_logger_stub)
    expect(child_container.resolve(:api_client)).to eq(child_api_client_stub)
    expect(child_container.resolve(:queue_adapter)).to eq(queue_adapter_stub)
  end

  specify 'dependency/namespace name accepts does not accept non-strings/non-symbols' do
    incompatible_name = Object.new

    expect do
      Class.new(QuantumCore::Container) do
        namespace(incompatible_name) {}
      end
    end.to raise_error(QuantumCore::Container::IncompatibleEntityNameError)

    container = Class.new(QuantumCore::Container).new

    expect { container.namespace(incompatible_name) {} }.to raise_error(
      QuantumCore::Container::IncompatibleEntityNameError
    )

    expect { container.register(incompatible_name) {} }.to raise_error(
      QuantumCore::Container::IncompatibleEntityNameError
    )

    expect { container.resolve(incompatible_name) }.to raise_error(
      QuantumCore::Container::IncompatibleEntityNameError
    )
  end
end
