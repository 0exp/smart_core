# frozen_string_literal: true

describe '[Container] Frozen state' do
  let(:container) do
    Class.new(QuantumCore::Container) do
      namespace :database do
        register(:logger) { :logger }
        register(:adapter) { :postgresql }
      end

      register(:randomizer) { :randomizer }
    end.new
  end

  specify 'frozen? predicate' do
    expect(container.frozen?).to eq(false)
    container.freeze!
    expect(container.frozen?).to eq(true)
    container.reload!
    expect(container.frozen?).to eq(false)
    container.freeze!
    expect(container.frozen?).to eq(true)
  end

  context 'frozen state' do
    before { container.freeze! }

    specify 'registration of the new dependency should fail' do
      expect { container.register(:logger) { :logger } }.to raise_error(
        QuantumCore::Container::FrozenRegistryError
      )

      expect { container.resolve(:logger) }.to raise_error(
        QuantumCore::Container::NonexistentEntityError
      )
    end

    specify 're-registration of the existing dependency should fail' do
      expect { container.register(:randomizer) { :new_randomizer } }.to raise_error(
        QuantumCore::Container::FrozenRegistryError
      )

      expect(container.resolve(:randomizer)).to eq(:randomizer)
    end

    specify 'creation of the new namespace should fail' do
      expect { container.namespace(:services) {} }.to raise_error(
        QuantumCore::Container::FrozenRegistryError
      )

      expect { container.resolve(:services) }.to raise_error(
        QuantumCore::Container::NonexistentEntityError
      )
    end

    specify 'reopening of the existing namespace should fail' do
      expect { container.namespace(:database) {} }.to raise_error(
        QuantumCore::Container::FrozenRegistryError
      )
    end

    specify 'registering of new dependencies on the existing namespace should fail' do
      expect do
        container.namespace(:database) do
          register(:service) { :service }
        end
      end.to raise_error(QuantumCore::Container::FrozenRegistryError)

      expect { container.resolve(:database).resolve(:service) }.to raise_error(
        QuantumCore::Container::NonexistentEntityError
      )
    end

    specify 'all nested containers should be frozen too' do
      expect do
        container.resolve(:database).register(:service) { :service }
      end.to raise_error(QuantumCore::Container::FrozenRegistryError)

      expect { container.resolve(:database).resolve(:service) }.to raise_error(
        QuantumCore::Container::NonexistentEntityError
      )
    end
  end
end
