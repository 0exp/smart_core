# frozen_string_literal: true

describe '[Container] Dot-notation' do
  specify do
    container_klass = Class.new(SmartCore::Container) do
      namespace :storages do
        namespace :cache do
          register(:general) { :dalli }
        end

        namespace :persistent do
          register(:general) { :postgres }
        end
      end
    end

    container = container_klass.new

    expect(container.fetch('storages.cache.general')).to eq(:dalli)
    expect(container.fetch('storages.persistent.general')).to eq(:postgres)

    expect(container['storages.cache.general']).to eq(:dalli)
    expect(container['storages.persistent.general']).to eq(:postgres)

    expect { container.fetch('storages.cache') }.to raise_error(SmartCore::Container::FetchError)
    expect { container.fetch('storages.persistent') }.to raise_error(SmartCore::Container::FetchError)
  end
end
