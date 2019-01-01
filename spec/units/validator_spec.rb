# frozen_string_literal: true

describe 'Validator' do
  specify do
    class SimpleValidator < SmartCore::Validator
      validate :peka do
        validate :boom
      end

      validate :fig

      private

      def peka
      end

      def fig
        error(:fig)
      end

      def boom
        error(:boom)
      end
    end

    validator = SimpleValidator.new
    validator.valid?

    binding.pry
  end
end
