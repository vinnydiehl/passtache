require File.expand_path("../lib/passtache/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name = "passtache"
  gem.version = Passtache::VERSION

  gem.authors = ["Jason Holman", "Vinny Diehl"]
  gem.email = ["laxermaster15@gmail.com", "vinny.diehl@gmail.com"]
  gem.homepage = "https://github.com/Morsgault/passtache"

  gem.license = "MIT"

  gem.summary = "Stash your passwords in Passtache."
  gem.description = "A secure password storage database."

  gem.bindir = "bin"
  gem.executables = "passtache"

  gem.require_paths = %w[lib]
  gem.test_files = Dir["spec/**/*"]
  gem.files = Dir["{lib,bin}/**/*"] + gem.test_files + %w[
    .rspec LICENSE Rakefile README.md passtache.gemspec
  ]

  gem.required_ruby_version = "~> 1.9"
  gem.add_dependency "encryptor", "~> 1.1"
  gem.add_dependency "scrypt", "~> 1.1"
  gem.add_development_dependency "fuubar", "~> 1.1"
  gem.add_development_dependency "rake", "~> 10.0"
  gem.add_development_dependency "rdoc", "~> 3.12"
  gem.add_development_dependency "redcarpet", "~> 2.2"
  gem.add_development_dependency "rspec", "~> 2.12"
  gem.add_development_dependency "yard", "~> 0.8"
end
