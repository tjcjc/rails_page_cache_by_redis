# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "redis_fragment_cache/version"

Gem::Specification.new do |s|
  s.name        = "redis_fragment_cache"
  s.version     = RedisFragmentCache::VERSION
  s.authors     = ["tjcjc"]
  s.email       = ["taijcjc@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{fragment cache from nbd}
  s.description = %q{!!}

  s.rubyforge_project = "redis_fragment_cache"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  #s.add_runtime_dependency "activerecord"
  #s.add_runtime_dependency "actionpack"
end
