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

class Array
  # defined #deconstruct_keys
  include PatternMatchable
end

case [1, 2, 3]
in first:, last:
  pp "OK : #{first}, #{last}"
  # => "OK : 1, 3"
end


class Time
  include PatternMatchable

  def to_four_seasons
    case self
    in month: (3..5)
      "spring"
    in month: (6..8)
      "summer"
    in month: (9..11)
      "autumn"
    in { month: (1..2) } | { month: 12 }
      "winter"
    end
  end
end

p Time.local(2019, 1, 1).to_four_seasons   # => "winter"
p Time.local(2019, 3, 1).to_four_seasons   # => "spring"
p Time.local(2019, 5, 1).to_four_seasons   # => "spring"
p Time.local(2019, 8, 1).to_four_seasons   # => "summer"
p Time.local(2019, 10, 1).to_four_seasons  # => "autumn"
p Time.local(2019, 12, 1).to_four_seasons  # => "winter"
```

### 1. `include PatternMatchable`

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

### 3. `using PatternMatchable.refining klass`

Add `#deconstruct_keys` to any class / module using Refinements.

```ruby
require "pattern_matchable"

# define Array#deconstruct_keys
using PatternMatchable.refining Array

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

### 4. `using PatternMatchable::#{class name}`

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

case (1..10).lazy.map { _1 * 2 }
in { first:, count: }
end
p first  # => 2
p count  # => 10

# error: NoMatchingPatternError
case "Homu"
in { downcase:, upcase: }
end
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/osyo-manga/pattern_matchable.

