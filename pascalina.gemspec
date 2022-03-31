# frozen_string_literal: true

require_relative "lib/pascalina/version"

Gem::Specification.new do |spec|
  spec.name          = "pascalina"
  spec.version       = Pascalina::VERSION
  spec.authors       = ["José Galisteo"]
  spec.email         = ["ceritium@gmail.com"]

  spec.summary       = "Small Ruby based calculus oriented expression parser"
  spec.description   = "It supports math operations, functions and variables"
  spec.homepage      = "https://github.com/ceritium/pascalina"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.5.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ceritium/pascalina"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "zeitwerk"
  spec.add_development_dependency "benchmark-ips"
end
