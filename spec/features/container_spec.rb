# frozen_string_literal: true

describe SmartCore::Container do
  specify do
    class Container < SmartCore::Container
      namespace :kek do
        register(:pek) { 123 }
        register(:check) { 555 }
      end
    end

    container = Container.new

    container.resolve(:kek).resolve(:pek)
  end
end
