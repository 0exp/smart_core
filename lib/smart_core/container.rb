# frozen_string_literal: true

# @api public
# @since 0.5.0
class SmartCore::Container
  require_relative 'container/registry'
  require_relative 'container/resolver'
  require_relative 'container/definition_dsl'

  # TODO:
  #
  #  namespace :test do
  #    register :pikachu { 'test' }
  #    register :alita { 'warrior' }
  #
  #    namespace 'bobba_fet' do
  #    end
  #  end
  #
  #  container.resolve('test.pikachu') # зависимость достигнута - возвращаем результат прока
  #  container.resolve('test.bobba_fet') # зависимость не достигнута - падаем с ошибкой
end
