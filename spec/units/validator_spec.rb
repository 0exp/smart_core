# frozen_string_literal: true

describe 'Validator' do
  specify do
    class SimpleValidator < SmartCore::Validator
      validate :peka

      validate :fig

      def peka
        error(:peka)
        error(:keka)
      end

      def fig
        error(:zeka)
      end
    end

    validator = SimpleValidator.new
    validator.valid?
  end
end
