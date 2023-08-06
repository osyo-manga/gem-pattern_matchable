# PatternMatchable

call method with pattern match.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pattern_matchable'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install pattern_matchable

## Usage

```ruby
require "pattern_matchable"

using PatternMatchable Array

case [1, 2, 3]
in first:, last:
  pp "OK : #{first}, #{last}"
  # => "OK : 1, 3"
end
```

### 1. `using PatternMatchable {class name}`

Use Refinements to add `{class name}#deconstruct_keys`.

```ruby
require "pattern_matchable"

# define Array#deconstruct_keys
using PatternMatchable Array

[1, 2, 3, 4, 5] => { first:, last: }
p first  # => 1
p last   # => 5

"Homu" in { downcase:, upcase: }
# => false
```

### 2. `using PatternMatchable`

Use Refinements to add `Object#deconstruct_keys`.

```ruby
require "pattern_matchable"

# defined Object#deconstruct_keys
using PatternMatchable

case [1, 2, 3, 4, 5]
in { first:, last: }
end
p first  # => 1
p last   # => 5

case "Homu"
in { downcase:, upcase: }
end
p downcase   # => "homu"
p upcase     # => "HOMU"
```

### 3. `include PatternMatchable`

`include` and add `#deconstruct_keys` to any class / module.

```ruby
require "pattern_matchable"

# mixin PatternMatchable to Array
# defined Array#deconstruct_keys
class Array
  include PatternMatchable
end

# OK: assigned `first` `last` variables
case [1, 2, 3, 4, 5]
in { first:, last: }
end
p first  # => 1
p last   # => 5

# error: NoMatchingPatternError
case "Homu"
in { downcase:, upcase: }
end
```

### 4. `using PatternMatchable.refining klass`

Add `#deconstruct_keys` to any class / module using Refinements.

```ruby
require "pattern_matchable"

# define Array#deconstruct_keys
using PatternMatchable.refining Array

[1, 2, 3, 4, 5] => { first:, last: }
p first  # => 1
p last   # => 5

# error: NoMatchingPatternError
case "Homu"
in { downcase:, upcase: }
end
```

### 5. `using PatternMatchable::#{class name}`

Use `Refinements` using `const_missing`.

```ruby
require "pattern_matchable"

# define Array#deconstruct_keys
using PatternMatchable::Array

case [1, 2, 3, 4, 5]
in { first:, last: }
end
p first  # => 1
p last   # => 5

# nested class name
# defined Enumerator::Lazy
using PatternMatchable::Enumerator::Lazy

(1..10).lazy.map { _1 * 2 } => { first:, count: }
p first  # => 2
p count  # => 10

"Homu" in { downcase:, upcase: }
# => false
```

## NOTE: Classes with `#deconstruct_keys` or `#respond_to?` defined will not work with `using PatternMatchable`.

```ruby
require "pattern_matchable"

class X
  def respond_to?(...)
    super
  end
end

using PatternMatchable

# NoMatchingPatternKeyError
case { name: "homu", age: 14 }
in { first:, count: }
else
end


# NoMatchingPatternKeyError
case X.new
in { __id__: }
else
end
```

For example, `ActiveRecord::Base`.
In this case, you must use `using PatternMatchable X`.

```ruby
require "pattern_matchable"

class X
  def respond_to?(...)
    super
  end
end

using PatternMatchable Hash
using PatternMatchable X

case { name: "homu", age: 14 }
in { first:, count: }
  pp "ok: #{first}: #{count}"
  # => "ok: [:name, \"homu\"]: 2"
else
end


case X.new
in { __id__: }
  pp "ok: #{__id__}"
  # => "ok: 880"
else
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/osyo-manga/pattern_matchable.

