require "pattern_matchable/version"

module PatternMatchable
  def deconstruct_keys(keys)
    keys.map { [_1, public_send(_1)] }.to_h
  end

  refine Object do
    include PatternMatchable
  end

  def self.refining(klass)
    Module.new {
      refine klass do
        include PatternMatchable
      end

      define_singleton_method(:const_missing) { |nested_name|
        PatternMatchable.refining Object.const_get("#{klass.name}::#{nested_name}")
      }
    }
  end

  def self.const_missing(klass_name)
    self.refining(Object.const_get(klass_name))
  end
end
