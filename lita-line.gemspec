Gem::Specification.new do |spec|
  spec.name          = "lita-line"
  spec.version       = "1.0.0"
  spec.version       = "#{spec.version}nightly#{ENV['TRAVIS_BUILD_NUMBER']}" if ENV['TRAVIS']
  spec.authors       = ["Aaron Huang"]
  spec.email         = ["aaroms9733@gmail.com"]
  spec.description   = "A line adapter for lita bot"
  spec.summary       = ""
  spec.homepage      = "https://github.com/aar0nTw/lita-line"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "adapter" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "eventmachine"
  spec.add_runtime_dependency "lita", ">= 4.7"
  spec.add_runtime_dependency "line-bot-api", "~> 1.0.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
end
