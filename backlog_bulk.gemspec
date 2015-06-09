# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'backlog_bulk/version'

Gem::Specification.new do |spec|
  spec.name          = "backlog_bulk"
  spec.version       = BacklogBulk::VERSION
  spec.authors       = ["ISOBE Kazuhiko"]
  spec.email         = ["muramasa64@gmail.com"]

  spec.summary       = %q{Bulk post to backlog.jp}
  spec.description   = %q{backlog_bulk is a script to post the issues and comments the same content on multiple projects of backlog.jp.}
  spec.homepage      = "https://github.com/muramasa64/backlog_bulk"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "thor", "~> 0.19"
  spec.add_dependency "backlog_jp", "~> 0.0.9"
end
