# frozen_string_literal: true

# @api private
# @since 0.8.0
class SmartCore::Container::DependencyResolver::Route
  # @since 0.8.0
  include Enumerable

  # @return [String]
  #
  # @api private
  # @since 0.8.0
  PATH_PART_SEPARATOR = '.'

  class << self
    # @param dependency_path [String, Symbol]
    # @return [SmartCore::Container::DependencyResolver::Route]
    #
    # @api private
    # @since 0.8.0
    def build(dependency_path)
      dependency_path = SmartCore::Container::KeyGuard.indifferently_accessable_key(
        dependency_path
      )
      dependency_path_parts = dependency_path.split(PATH_PART_SEPARATOR)
      new(dependency_path, *dependency_path_parts)
    end
  end

  # @return [Integer]
  #
  # @api private
  # @since 0.8.0
  attr_reader :size

  # @return [String]
  #
  # @api private
  # @since 0.8.0
  attr_reader :path

  # @param path [String]
  # @param path_parts [Array<String>]
  # @return [void]
  #
  # @api private
  # @since 0.8.0
  def initialize(path, *path_parts)
    @path = path
    @path_parts = path_parts.dup.freeze
    @size = path_parts.size
  end

  # @param block [Block]
  # @yield path_part [String]
  # @return [Enumerable]
  #
  # @api private
  # @since 0.8.0
  def each(&block)
    block_given? ? path_parts.each(&block) : path_parts.each
  end

  # @param block [Block]
  # @yield path_part [String]
  # @yield path_part_index [Integer]
  # @return [Enumerable]
  #
  # @api private
  # @since 0.8.0
  def each_with_index(&block)
    block_given? ? path_parts.each_with_index(&block) : path_parts.each_with_index
  end

  # @param path_part_index [Integer]
  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def end?(path_part_index)
    size <= (path_part_index + 1)
  end

  private

  # @return [Array<String>]
  #
  # @api private
  # @since 0.8.0
  attr_reader :path_parts
end
