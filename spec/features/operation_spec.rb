# frozen_string_literal: true

describe SmartCore::Operation do
  describe 'attribute definition DSL' do
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
        end.to raise_error(SmartCore::Operation::OptionOverlapError)
      end
    end

    specify 'fails when the required attribute is not passed' do
      class SimpleOp < SmartCore::Operation
        param :nickname # required
        param :password # required

        option :active # required
        option :admin, default: false
        option :age, default: -> { 1 + 2 }
      end

      # rubocop:disable Metrics/LineLength
      expect { SimpleOp.new }.to raise_error(SmartCore::Operation::ParameterError)
      expect { SimpleOp.new('0exp') }.to raise_error(SmartCore::Operation::ParameterError)
      expect { SimpleOp.new('0exp', 'test') }.to raise_error(SmartCore::Operation::OptionError)
      expect { SimpleOp.new(active: false) }.to raise_error(SmartCore::Operation::ParameterError)
      expect { SimpleOp.new('0exp', 'test', active: false) }.not_to raise_error
      expect { SimpleOp.new('0exp', 'test', active: true, admin: true) }.not_to raise_error
      expect { SimpleOp.new('0exp', 'test', active: true, admin: false, age: 1) }.not_to raise_error
      # rubocop:enable Metrics/LineLength
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
end
