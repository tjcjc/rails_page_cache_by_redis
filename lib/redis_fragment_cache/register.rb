require 'rails'
require './init_fragment_key_methods'
Rails::Application.send(:include, RedisFragmentCache::InitFragmentKeyMethods)
