require_relative "pattern_matchable/version"

module PatternMatchable
  def deconstruct_keys(keys)
    keys.to_h { [_1, public_send(_1)] }
  end

  refine Object do
    if defined?(import_methods)
      import_methods PatternMatchable
    else
      include PatternMatchable
    end
  end

  def self.refining(*klasses)
    Module.new {
      klasses.each do |klass|
        refine klass do
          def deconstruct_keys(keys)
            if defined? super
              super.then { |result|
                result.merge((keys - result.keys).to_h { [_1, public_send(_1)] })
              }
            else
              keys.to_h { [_1, public_send(_1)] }
            end
          end

          def respond_to?(name, ...)
            name == :deconstruct_keys || super
          end
        end

        define_singleton_method(:const_missing) { |nested_name|
          PatternMatchable.refining Object.const_get("#{klass.name}::#{nested_name}")
        }
      end
    }
  end

  def self.const_missing(klass_name)
    self.refining(Object.const_get(klass_name))
  end
end

def PatternMatchable(*klasses)
  PatternMatchable.refining *klasses
end
