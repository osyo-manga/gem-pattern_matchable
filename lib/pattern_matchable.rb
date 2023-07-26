require "pattern_matchable/version"

module PatternMatchable
  def deconstruct_keys(keys)
    keys.to_h { [_1, public_send(_1)] }
  end

  refine Object do
    if defined?(:import_methods)
      import_methods PatternMatchable
    else
      include PatternMatchable
    end
  end

  def self.refining(klass)
    Module.new {
      refine klass do
        if defined?(:import_methods)
          import_methods PatternMatchable
        else
          include PatternMatchable
        end
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

def PatternMatchable(klass)
  PatternMatchable.refining klass
end
