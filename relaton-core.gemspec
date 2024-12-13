lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "relaton/core/version"

Gem::Specification.new do |spec|
  spec.name          = "relaton-core"
  spec.version       = Relaton::Core::VERSION
  spec.authors       = ["Ribose Inc."]
  spec.email         = ["open.source@ribose.com"]

  spec.homepage      = "https://github.com/relaton/relaton-core"
  spec.summary       = "Library for importing and caching bibliographic references to technical standards"
  spec.description   = "Library for importing and caching bibliographic references to technical standards"
  spec.license       = "BSD-2-Clause"

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").select do |f|
      f.match(%r{^(lib|exe)/}) || f.match(%r{\.yaml$})
    end
  end
  spec.extra_rdoc_files = %w[README.adoc LICENSE.txt]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency "relaton-bib", "~> 1.19.0"
end
