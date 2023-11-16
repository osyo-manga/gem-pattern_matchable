require_relative 'lib/pattern_matchable/version'

Gem::Specification.new do |spec|
  spec.name          = "pattern_matchable"
  spec.version       = PatternMatchable::VERSION
  spec.authors       = ["manga_osyo"]
  spec.email         = ["manga.osyo@gmail.com"]

  spec.summary       = %q{call method with pattern match.}
  spec.description   = %q{call method with pattern match.}
  spec.homepage      = "https://github.com/osyo-manga/gem-pattern_matchable"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
