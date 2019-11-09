# frozen_string_literal: true

describe '[Container] Composition (.compose macros)' do
  specify 'makes composition possbile :)' do
    stub_const('DbContainer', Class.new(QuantumCore::Container) do
      namespace :database do
        register(:adapter) { :pg }
      end
    end)

    stub_const('ApiContainer', Class.new(QuantumCore::Container) do
      namespace :client do
        register(:proxy) { :proxy }
      end
    end)

    stub_const('CacheContainer', Class.new(QuantumCore::Container) do
      namespace :database do
        register(:cache) { :cache }
      end
    end)

    stub_const('CompositionRoot', Class.new(QuantumCore::Container) do
      compose(DbContainer)
      compose(ApiContainer)
      compose(CacheContainer)

      namespace(:nested) { compose(DbContainer) }
    end)

    root_container = CompositionRoot.new

    expect(root_container.resolve(:database).resolve(:adapter)).to eq(:pg)
    expect(root_container.resolve(:client).resolve(:proxy)).to eq(:proxy)
    expect(root_container.resolve(:database).resolve(:cache)).to eq(:cache)
    expect(root_container.resolve(:nested).resolve(:database).resolve(:adapter)).to eq(:pg)
  end

  specify 'ignores frozen state (ignores .freeze_state macros)' do
    stub_const('DbContainer', Class.new(QuantumCore::Container) do
      namespace(:database) { register(:adapter) { :db } }

      freeze_state!
    end)

    stub_const('CompositionRoot', Class.new(QuantumCore::Container) do
      compose(DbContainer)
    end)

    root_container = CompositionRoot.new

    expect(root_container.frozen?).to eq(false)
    expect(root_container.resolve(:database).frozen?).to eq(false)
  end
end
