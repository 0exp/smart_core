# frozen_string_literal: true

describe SmartCore::Validator do
  specify 'without an additon of errors => valid state; empty errors' do
    class ValidatorWithotErrors < SmartCore::Validator
      validate :check_password
      validate :check_email

      private

      # rubocop:disable Layout/EmptyLineBetweenDefs
      def check_password; end
      def check_email; end
      # rubocop:enable Layout/EmptyLineBetweenDefs
    end

    validator = ValidatorWithotErrors.new

    expect(validator.errors).to eq([])
    expect(validator.valid?).to eq(true)
    expect(validator.errors).to eq([])
  end

  specify 'with an addition of errors => invalid state; filled errors' do
    class ValidatorWithErrors < SmartCore::Validator
      validate :check_token
      validate :check_nickname
      validate :check_timezone

      private

      def check_token
        error(:invalid_token)
      end

      def check_nickname
        error('invalid_nickname')
      end

      def check_timezone; end
    end

    validator = ValidatorWithErrors.new

    expect(validator.errors).to eq([])
    expect(validator.valid?).to eq(false)
    expect(validator.errors).to contain_exactly(:invalid_token, :invalid_nickname)
  end

  specify '#fatal error interceptor stops concrete validation method flow' do
    class ValidatorWithFatals < SmartCore::Validator
      validate :check_a do # no-fatal, no-error
        validate :check_b # fatal, error
      end

      validate :check_c do # fatal
        validat :check_d # no-fatal
      end

      private

      def check_a; end # reached method

      def check_b # reached method
        error(:check_b_before_fatal) # reached code
        fatal(:fatal_b) # reached code
        error(:check_b_after_fatal) # non-reached cocde
      end

      def check_c # reached method
        fatal(:fatal_c) # reached code
        error(:check_c_after_fatal) # non-reached code
      end

      def check_d # non-reached method (check_c fails wit hfatal)
        error(:check_d_before_fatal) # non-reached code
        fatal(:fatal_d) # non-reached code
        error(:check_d_after_fatal) # non-reached code
      end
    end

    validator = ValidatorWithFatals.new

    expect(validator.errors).to eq([])
    expect(validator.valid?).to eq(false)

    # check_b (:check_b_after_fatal is not reached)
    # check_c (:check_c_after_fatal is not reached)
    expect(validator.errors).to contain_exactly(:check_b_before_fatal, :fatal_b, :fatal_c)
  end

  specify 'incorrect error code type => fails with exception' do
    class ValidatorWithIncorrectErrorCode < SmartCore::Validator
      validate :project_consistency

      private

      def project_consistency
        error(Object.new)
      end
    end

    class ValidatorWithoutIncorrectErrorCodes < SmartCore::Validator
      validate :check_a
      validate :check_b

      private

      def check_a
        error(:test)
      end

      def check_b
        error('test')
      end
    end

    incorrect_validator = ValidatorWithIncorrectErrorCode.new
    correct_validator   = ValidatorWithoutIncorrectErrorCodes.new

    expect do
      incorrect_validator.valid?
    end.to raise_error(SmartCore::Validator::IncorrectErrorCodeError)

    expect do
      correct_validator
    end.not_to raise_error
  end

  specify 'can be instantiated with custom attributes' do
    class ValidatorWithCustomAttributes < SmartCore::Validator
      attribute :email
      attribute :password

      validate :email_format
      validate :password_rules

      private

      def email_format
        error(:incorrect_email) unless email.include?('@')
      end

      def password_rules
        error(:password_rules) if password.length < 8
      end
    end

    validator = ValidatorWithCustomAttributes.new(email: 'kek', password: '12345789')
    expect(validator.email).to eq('kek')
    expect(validator.password).to eq('12345789')
    expect(validator.errors).to eq([])
    expect(validator.valid?).to eq(false)
    expect(validator.errors).to contain_exactly(:incorrect_email)

    validator = ValidatorWithCustomAttributes.new(email: 'a@b.c', password: '123')
    expect(validator.email).to eq('a@b.c')
    expect(validator.password).to eq('123')
    expect(validator.errors).to eq([])
    expect(validator.valid?).to eq(false)
    expect(validator.errors).to contain_exactly(:password_rules)

    validator = ValidatorWithCustomAttributes.new(email: 'a@b.c', password: '12345678')
    expect(validator.email).to eq('a@b.c')
    expect(validator.password).to eq('12345678')
    expect(validator.errors).to eq([])
    expect(validator.valid?).to eq(true)
    expect(validator.errors).to eq([])
  end

  specify 'custom attribute can be declared with default value (with literal OR with proc)' do
    class ValidatorWithDefaultCustomAttributes < SmartCore::Validator
      attribute :email,    default: 'kek@pek.cheburek'
      attribute :password, default: -> { 1 + 1 }
    end

    validator = ValidatorWithDefaultCustomAttributes.new
    expect(validator.email).to eq('kek@pek.cheburek')
    expect(validator.password).to eq(2)

    validator = ValidatorWithDefaultCustomAttributes.new(email: 'test@test.test')
    expect(validator.email).to eq('test@test.test')
    expect(validator.password).to eq(2)

    validator = ValidatorWithDefaultCustomAttributes.new(password: 'atata')
    expect(validator.email).to eq('kek@pek.cheburek')
    expect(validator.password).to eq('atata')

    validator = ValidatorWithDefaultCustomAttributes.new(email: 'test@pek.lel', password: '12345')
    expect(validator.email).to eq('test@pek.lel')
    expect(validator.password).to eq('12345')
  end

  specify 'unprovided attributes have nil values' do
    class ValidatorWithDefaultNils < SmartCore::Validator
      attribute :token
      attribute :service

      validate :token_format
      validate :service_name

      private

      def token_format
        error(:empty_token) if token.nil?
      end

      def service_name
        error(:empty_service) if service.nil?
      end
    end

    validator = ValidatorWithDefaultNils.new

    expect(validator.token).to eq(nil)
    expect(validator.service).to eq(nil)
    expect(validator.errors).to eq([])
    expect(validator.valid?).to eq(false)
    expect(validator.errors).to contain_exactly(:empty_token, :empty_service)
  end

  specify 'fails when attribute has incorrect name' do
    expect do
      Class.new(SmartCore::Validator) { attribute(Object.new) }
    end.to raise_error(SmartCore::Validator::IncorrectAttributeNameError)
  end

  specify 'composition and inheritance works as expected :)' do
    class EmailValidator < SmartCore::Validator
      attribute :email

      validate :email_format

      def email_format
        error(:incorrect_email)
      end
    end

    class PasswordValidator < SmartCore::Validator
      attribute :password

      validate :password_format

      def password_format
        error(:incorrect_password)
      end
    end

    class CredentialsValidator < SmartCore::Validator
      attribute :email
      attribute :password
      attribute :service

      validate :check_service do
        validate_with(EmailValidator)
        validate_with(PasswordValidator)
      end

      private

      def check_service; end
    end

    class UserValidator < CredentialsValidator
      attribute :nick

      validate :check_nickname

      private

      def check_nickname
        error(:incorrect_nickname)
      end
    end

    validator = UserValidator.new(email: 'kek', password: 'pek', nick: 'rol')

    expect(validator.email).to eq('kek')
    expect(validator.password).to eq('pek')
    expect(validator.service).to eq(nil)
    expect(validator.nick).to eq('rol')

    expect(validator.errors).to eq([])
    expect(validator.valid?).to eq(false)
    expect(validator.errors).to contain_exactly(
      :incorrect_email,
      :incorrect_password,
      :incorrect_nickname
    )
  end

  specify 'nested validations are invoked only when the root validation is valid' do
    class SubValidatorCheck < SmartCore::Validator
      validate :check_sub # passed (reached)

      def check_sub; end
    end

    class AnotherSubValidatorCheck < SmartCore::Validator
      validate :check_another_sub # fail (reached)

      def check_another_sub; error(:another_sub); end
    end

    class ValidatorWithNesteds < SmartCore::Validator
      validate :check_a do # passed (reached)
        validate :check_b do # passed (reached)
          validate :check_c # fail (reached)
        end
      end

      validate :check_d do # passed (reached)
        validate :check_e # fail (reached)
        validate :check_f do # fail (reached)
          validate :check_g # => (non-reached)
        end
      end

      validate :check_h do # fail (reached)
        validate :check_i # (non-reached)
      end

      validate_with(SubValidatorCheck) do # passed (reached)
        validate :check_j # fail (reached)

        validate_with(AnotherSubValidatorCheck) do # fail (reached)
          validate :check_k # (non-reached)
        end
      end

      # rubocop:disable Layout/EmptyLineBetweenDefs
      def check_a; end
      def check_b; end
      def check_c; error(:c); end

      def check_d; end
      def check_e; error(:e); end
      def check_f; error(:f); end
      def check_g; error(:g); end

      def check_h; error(:h); end
      def check_i; error(:i); end

      def check_j; error(:j); end
      def check_k; error(:k); end
      # rubocop:enable Layout/EmptyLineBetweenDefs
    end

    validator = ValidatorWithNesteds.new

    expect(validator.errors).to eq([])
    expect(validator.valid?).to eq(false)
    expect(validator.errors).to contain_exactly(:c, :e, :f, :h, :j, :another_sub)
  end
end
