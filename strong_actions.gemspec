lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'strong_actions/version'

Gem::Specification.new do |spec|
  spec.name          = "strong_actions"
  spec.version       = StrongActions::VERSION
  spec.authors       = ["ichy"]
  spec.email         = ["ichylinux@gmail.com"]
  spec.summary       = %q{access control for rails controller/action}
  spec.description   = %q{access control for rails controller/action}
  spec.homepage      = "https://github.com/hybitz/strong_actions"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '~> 2.2'

  spec.add_dependency "activesupport", '>= 4.2', '< 5.2'
  spec.add_dependency "actionpack", '>= 4.2', '< 5.2'
  spec.add_dependency "railties", '>= 4.2', '< 5.2'

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rake", "~> 12.0"
end
