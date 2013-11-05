# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'knife-docker/version'

Gem::Specification.new do |spec|
  spec.name          = "knife-docker"
  spec.version       = KnifeDocker::VERSION
  spec.authors       = ["arunthampi"]
  spec.email         = ["arun.thampi@gmail.com"]
  spec.description   = %q{knife-docker is a Knife Plugin which helps us create LXC containers with the help of chef-solo}
  spec.summary       = %q{knife-docker is a Knife Plugin which helps us create LXC containers with the help of chef-solo}
  spec.homepage      = "https://www.nitrous.io/"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency               "docker-api", "~> 1.6.0"

  spec.add_development_dependency   "chef",   "~> 11.6.0"
  spec.add_development_dependency   "rspec",  "~> 2.14.1"
  spec.add_development_dependency   "fakefs", "~> 0.4.3"

  spec.add_development_dependency   "bundler",    "~> 1.3"
  spec.add_development_dependency   "rake"
end
