# frozen_string_literal: true

class SmartCore::Container
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
