# frozen_string_literal: true

describe 'Smoke Test' do
  specify do
    class PekaValidator < SmartCore::Validator
      attribute :password

      validate :atata
      validate :tratata

      def atata
        error(:atata)
      end

      def tratata
        error(:tratata)
      end
    end

    class SimpleValidator < SmartCore::Validator
      attribute :email
      attribute :password

      validate :peka do
        validate :boom do
          validate :juk
        end
      end

      validate_with(PekaValidator) do
        validate :fig
      end

      private

      def peka; end

      def fig
        error(:fig)
      end

      def boom; end

      def juk
        error(:juk)
      end
    end

    validator = SimpleValidator.new(email: 'kek@pek.cheburek', password: 'lalala')
    validator.valid?
  end
end
