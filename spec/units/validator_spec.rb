# frozen_string_literal: true

describe 'Validator' do
  specify do
    class SimpleValidator < SmartCore::Validator
      attribute :email
      attribute :password

      validate :peka do
        validate :boom do
          validate :juk
        end
      end

      validate :fig

      private

      def peka
      end

      def fig
        error(:fig)
      end

      def boom
      end

      def juk
        error(:juk)
      end
    end

    validator = SimpleValidator.new(email: 'kek@pek.cheburek', password: 'lalala')
    validator.valid?

    binding.pry
  end
end
