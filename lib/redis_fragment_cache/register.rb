require 'redis_fragment_cache/init_fragment_key_methods'
require 'action_view'
require 'active_record'
require 'action_controller'
ActionView::Helpers.send(:include, RedisFragmentCache::InitFragmentKeyMethods)
ActiveRecord::Base.send(:include, RedisFragmentCache::InitFragmentKeyMethods)
ActionController::Base.send(:include, RedisFragmentCache::InitFragmentKeyMethods)
