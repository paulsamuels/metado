# frozen_string_literal: true

require_relative "lib/metado/version"

Gem::Specification.new do |spec|
  spec.name = "metado"
  spec.version = Metado::VERSION
  spec.authors = ["Paul Samuels"]
  spec.email = ["paulio1987@gmail.com"]

  spec.summary = "Supercharge your todos with metadata"
  spec.homepage = "https://github.com/paulsamuels/metado"
  spec.license = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/paulsamuels/metado"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "tomlrb"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "standard", "~> 1.0.2"
end
