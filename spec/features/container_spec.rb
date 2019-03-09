# frozen_string_literal: true

describe SmartCore::Container do
  specify do
    class Container < SmartCore::Container
      namespace :kek do
        register(:pek) { 123 + 123 }
        register(:check) { 555 }
      end
    end

    container = Container.new

    expect(container.resolve(:kek).resolve(:pek)).to eq(246)

    class SubContainer < Container
      namespace :kek do
        namespace :bek do
          register(:lol) { "lol" }
        end
      end
    end

    sub_container = SubContainer.new

    expect(sub_container.resolve(:kek).resolve(:bek).resolve(:lol)).to eq("lol")
    expect(sub_container.resolve(:kek).resolve(:pek)).to eq(246)
    expect(sub_container.resolve(:kek).resolve(:check)).to eq(555)

    class AnyObject
      include SmartCore::Container::Mixin

      dependencies do
        namespace :kek do
          register(:pek) { "test" }
          register(:fek) { 2 }
        end
      end
    end

    class SuperAnyObject < AnyObject
      dependencies do
        namespace :kek do
          register(:pek) { "super_test" }
          register(:chmek) { nil }
        end
      end
    end

    any_object = AnyObject.new
    super_any_object = SuperAnyObject.new

    expect(any_object.container.resolve(:kek).resolve(:pek)).to eq("test")
    expect(AnyObject.container.resolve(:kek).resolve(:pek)).to eq("test")

    expect(super_any_object.container.resolve(:kek).resolve(:pek)).to eq("super_test")
    expect(SuperAnyObject.container.resolve(:kek).resolve(:pek)).to eq("super_test")

    expect(super_any_object.container.resolve(:kek).resolve(:fek)).to eq(2)
    expect(SuperAnyObject.container.resolve(:kek).resolve(:fek)).to eq(2)

    expect(super_any_object.container.resolve(:kek).resolve(:chmek)).to eq(nil)
    expect(SuperAnyObject.container.resolve(:kek).resolve(:chmek)).to eq(nil)

    expect { any_object.container.resolve(:kek).resolve(:chmek) }.to raise_error(
      SmartCore::Container::UnexistentDependencyError
    )
    expect { AnyObject.container.resolve(:kek).resolve(:chmek) }.to raise_error(
      SmartCore::Container::UnexistentDependencyError
    )
  end
end
