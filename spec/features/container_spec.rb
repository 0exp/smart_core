# frozen_string_literal: true

describe SmartCore::Container do
  specify do
    class Container < SmartCore::Container
      namespace 'kek_pek' do
        namespace 'cheburek' do
          register :gena   { 1 + 1 }
          register :kakena { 2 + 2 }
        end
      end

      namspace 'bubui' do
        register 'peka' { Peka.new }
        register 'keka' { Keka.new }
      end # Идея: нэймспэйсы - это вложенные контейнеры
    end

    Container.resolve('kek_pek.cheburek.gena')
    Container.resolve('bubui.peka.keka')

    Container.resolve(:kek_pek).resolve(:cheburek).resolve(:gena)
    Container.resolve(:bubui).resolve(:peka).resolve(:keka)

    Container.register('kek_pek.chukmambek') { 'azaza' }
    Container.namespace('alala').regiter(:traala) { 'peka' }
  end
end
