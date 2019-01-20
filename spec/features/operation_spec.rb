# frozen_string_literal: true

describe SmartCore::Operation do
  describe 'attribute definition DSL and service instantiation' do
    specify 'single attribute definition' do
      class SingleAttrOp < SmartCore::Operation
        param :email
        param :password

        option :active
        option :admin, default: false
        option :age, default: -> { 10 + 15 }
      end

      service = SingleAttrOp.new('kek@pek.tv', '123', active: true)

      # params
      expect(service.email).to eq('kek@pek.tv')
      expect(service.password).to eq('123')

      # options
      expect(service.active).to eq(true)
      expect(service.admin).to eq(false)
      expect(service.age).to eq(25)
    end

    specify 'multiple attribute definition' do
      class MultipleAttrOp < SmartCore::Operation
        params :email, :password
        options :active, :admin, :age
      end

      service = MultipleAttrOp.new('kek@spec.mek', 'u403tjt', active: false, admin: true, age: 15)

      # params
      expect(service.email).to eq('kek@spec.mek')
      expect(service.password).to eq('u403tjt')

      # options
      expect(service.active).to eq(false)
      expect(service.admin).to eq(true)
      expect(service.age).to eq(15)
    end

    specify 'mixed attribute definition' do
      class MixedAttrOp < SmartCore::Operation
        param :email
        params :password, :nickname

        option :admin, default: false
        options :age, :active
      end

      service = MixedAttrOp.new('a@b.com', 'test', '0exp', age: 22, active: false)

      # params
      expect(service.email).to eq('a@b.com')
      expect(service.password).to eq('test')
      expect(service.nickname).to eq('0exp')

      # options
      expect(service.age).to eq(22)
      expect(service.active).to eq(false)
      expect(service.admin).to eq(false)
    end

    specify 'fails on param<->option intersection' do
      expect do
        Class.new(SmartCore::Operation) do
          param :email
          option :email
        end
      end.to raise_error(SmartCore::Operation::ParamOverlapError)

      expect do
        Class.new(SmartCore::Operation) do
          option :email
          param :email
        end
      end.to raise_error(SmartCore::Operation::OptionOverlapError)

      expect do
        Class.new(SmartCore::Operation) do
          params :email, :password
          options :nickname, :password
        end
      end.to raise_error(SmartCore::Operation::ParamOverlapError)

      expect do
        Class.new(SmartCore::Operation) do
          options :nickname, :password
          params :email, :password
        end
      end.to raise_error(SmartCore::Operation::OptionOverlapError)
    end

    specify 'fails when the required attribute is not passed' do
      class SimpleOp < SmartCore::Operation
        param :nickname # required
        param :password # required

        option :active # required
        option :admin, default: false
        option :age, default: -> { 1 + 2 }
      end

      expect { SimpleOp.new }.to raise_error(SmartCore::Operation::ParameterError)
      expect { SimpleOp.new('0exp') }.to raise_error(SmartCore::Operation::ParameterError)
      expect { SimpleOp.new('0exp', 'test') }.to raise_error(SmartCore::Operation::OptionError)
      expect { SimpleOp.new(active: false) }.to raise_error(SmartCore::Operation::ParameterError)
      expect { SimpleOp.new('0exp', 'test', active: false) }.not_to raise_error
      expect { SimpleOp.new('0exp', 'test', active: true, admin: true) }.not_to raise_error
      expect { SimpleOp.new('0exp', 'test', active: true, admin: false, age: 1) }.not_to raise_error
    end

    specify 'fails with non-string / non-symbol keys (incorrect attribute keys)' do
      expect do
        Class.new(SmartCore::Operation) do
          param 123
        end
      end.to raise_error(SmartCore::Operation::IncorrectAttributeNameError)

      expect do
        Class.new(SmartCore::Operation) do
          option Object.new
        end
      end.to raise_error(SmartCore::Operation::IncorrectAttributeNameError)

      expect do
        Class.new(SmartCore::Operation) do
          params :a, :b, 555
        end
      end.to raise_error(SmartCore::Operation::IncorrectAttributeNameError)

      expect do
        Class.new(SmartCore::Operation) do
          options :a, :b, {}
        end
      end.to raise_error(SmartCore::Operation::IncorrectAttributeNameError)
    end

    specify 'inheritance works as expected :)' do
      class BaseOp < SmartCore::Operation
        params :nickname, :email
        option :active
      end

      class ChildOp < BaseOp
        params :password
        option :admin, default: false
      end

      service = ChildOp.new('0exp', '0exp@0exp.0exp', 'test', active: false)
      # child op
      expect(service.nickname).to eq('0exp')
      expect(service.email).to eq('0exp@0exp.0exp')
      expect(service.password).to eq('test')
      expect(service.active).to eq(false)
      expect(service.admin).to eq(false)

      service = BaseOp.new('kek', 'pek@cheburek.ru', active: true)
      # base op
      expect(service.nickname).to eq('kek')
      expect(service.email).to eq('pek@cheburek.ru')
      expect(service.active).to eq(true)
      expect { service.password }.to raise_error(NoMethodError)
      expect { service.admin }.to raise_error(NoMethodError)
    end
  end

  describe 'invokation and results' do
    before do
      stub_const('UserRegService', Class.new(SmartCore::Operation) do
        params :email, :password
        options :active, :role

        option :test_fail, default: false

        def call
          if test_fail
            Failure(:empty_password, :already_registerd)
          else
            Success(user_id: 123_456, tested: true)
          end
        end
      end)
    end

    describe 'invokation result object' do
      specify 'successful result' do
        result = UserRegService.call('test@test.test', 'test', active: false, role: :xakep)

        expect(result).is_a?(SmartCore::Operation::Success)
        # result status
        expect(result.success?).to eq(true)
        expect(result.failure?).to eq(false)
        # result state
        expect(result.user_id).to eq(123_456)
        expect(result.tested).to eq(true)
      end

      specify 'failing result' do
        result = UserRegService.call('a@b.c', 'pek', active: true, role: :pek, test_fail: true)

        expect(result).is_a?(SmartCore::Operation::Failure)
        # result status
        expect(result.success?).to eq(false)
        expect(result.failure?).to eq(true)
        # result state
        expect(result.errors).to contain_exactly(:empty_password, :already_registerd)
      end

      specify 'fatal result (and yieldable result object behavior)' do
        class MaFatalService < SmartCore::Operation
          option :result_interceptor, default: -> { [] }

          def call
            result_interceptor << :before_fatal # reached code
            Fatal(:fatal_error, :lol)
            result_interceptor << :after_fatal # not reached code
          end
        end

        result_interceptor = []
        result = MaFatalService.call(result_interceptor: result_interceptor)
        expect(result).to be_a(SmartCore::Operation::Fatal)
        expect(result.errors).to contain_exactly(:fatal_error, :lol)
        expect(result_interceptor).to contain_exactly(:before_fatal)

        yield_interceptor = []
        MaFatalService.call do |result|
          result.success? { yield_interceptor << :success_result }
          result.failure? { yield_interceptor << :failure_result }
          result.fatal?   { yield_interceptor << :fatal_result }
        end
        expect(yield_interceptor).to contain_exactly(:failure_result, :fatal_result)
      end

      specify 'yieldable result' do
        succ_results = []
        fail_results = []

        # successful result => result.success?(&block) is invoked
        UserRegService.call('a@b.c', '12345', active: true, role: :kek) do |result|
          result.success? { succ_results << :first_succ_invoked } # this logic should be invoked
          result.failure? { fail_results << :first_fail_invoked }
        end

        # failure result => result.failure?(&block) is invoked
        UserRegService.call('a@b.c', '12345', active: true, role: :kek, test_fail: true) do |result|
          result.success? { succ_results << :second_succ_invoked }
          result.failure? { fail_results << :second_fail_invoked } # this logic should be invoked
        end

        expect(succ_results).to contain_exactly(:first_succ_invoked) # only the first
        expect(fail_results).to contain_exactly(:second_fail_invoked) # only the second
      end

      specify 'successful by default' do
        result = Class.new(described_class).call
        expect(result.success?).to eq(true)
      end

      specify "fails when Success-result's keys are incorrect (non symbolic)" do
        class SuccMethodOverlapOp < SmartCore::Operation
          def call
            Success(success?: rand)
          end
        end
        expect { SuccMethodOverlapOp.call }.to raise_error(
          SmartCore::Operation::ResultMethodIntersectionError
        )

        class FailMethodOverlapOp < SmartCore::Operation
          def call
            Success(failure?: rand)
          end
        end
        expect { FailMethodOverlapOp.call }.to raise_error(
          SmartCore::Operation::ResultMethodIntersectionError
        )

        class StringKeyOpError < SmartCore::Operation
          def call
            Success('success?' => rand, 'failure?' => rand)
          end
        end
        expect { StringKeyOpError.call }.to raise_error(ArgumentError)

        class AnyObjResultKeyOp < SmartCore::Operation
          def call
            Success(Object => 1, 55 => 2)
          end
        end
        expect { AnyObjResultKeyOp.call }.to raise_error(ArgumentError)
      end
    end

    describe '#call & .call behavior' do
      # rubocop:disable Metrics/LineLength
      specify '#call & .call' do
        class_call_res = UserRegService.call('kek@pek.tv', 'test', active: true, role: :admin)
        instance_call_res = UserRegService.new('kek@pek.tv', 'test', active: false, role: :kek).call

        expect(class_call_res.success?).to eq(true)
        expect(instance_call_res.success?).to eq(true)
        expect(class_call_res.failure?).to eq(false)
        expect(instance_call_res.failure?).to eq(false)

        class_call_res = UserRegService.call('kek@pek.tv', 'test', active: true, role: :admin, test_fail: true)
        instance_call_res = UserRegService.new('kek@pek.tv', 'test', active: false, role: :kek, test_fail: true).call

        expect(class_call_res.success?).to eq(false)
        expect(instance_call_res.success?).to eq(false)
        expect(class_call_res.failure?).to eq(true)
        expect(instance_call_res.failure?).to eq(true)
      end
      # rubocop:enable Metrics/LineLength
    end

    specify 'inheritance' do
      class BaseService < SmartCore::Operation
        options :nick, :pass

        def call
          Success(service: :base)
        end
      end

      class SubService < BaseService
        options :email, :name

        def call
          Success(service: :sub)
        end
      end

      result = SubService.call(nick: '0exp', pass: '123', email: 'a@b.c', name: 'pek')
      expect(result.success?).to eq(true)
      expect(result.service).to eq(:sub)

      result = BaseService.call(nick: '0exp', pass: '555')
      expect(result.success?).to eq(true)
      expect(result.service).to eq(:base)
    end
  end
end
