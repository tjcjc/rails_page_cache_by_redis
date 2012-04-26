require './init_fragment_key_methods'
require 'action_view'
require 'active_record'
require 'action_controller'
module ActionView::Helpers
  include RedisFragmentCache::InitFragmentKeyMethods
  init_fragment_key_methods
  init_set_key_methods
end

class ActiveRecord::Base
  include RedisFragmentCache::InitFragmentKeyMethods
  init_fragment_key_methods
  init_set_key_methods
end

class ActionController::Base
  include RedisFragmentCache::InitFragmentKeyMethods
  init_fragment_key_methods
  init_set_key_methods
end
