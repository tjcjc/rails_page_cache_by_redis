require 'yaml'
module Nbd::PageCacheUtils

  def self.included(base)
    base.extend         ClassMethods
    base.send :include, InstanceMethods
  end # self.included

  module ClassMethods
    attr_accessor :yml_data, :expire_intervel, :suffix
    def nbd_cache_utils(redis_client, yml_file, expire_intervel, suffix = "\#{request.subdomain}_\#{params[:controller]}_\#{params[:action]}_\#{params[:id]}_\#{params[:page]}")
      self.yml_data = YAML.load_file(yml_file)
      #self.redis_client = redis_client || Rails.cache
      #self.yml_data = YAML.load_file(yml_file)
      self.expire_intervel = expire_intervel
      update_redis_client(redis_client)
      self.suffix = suffix
      init_set_key_methods
      init_fragment_key_methods
    end

    def nbd_expire_cache_utils(redis_client, yml_file)
      self.yml_data = YAML.load_file("#{Rails.root}/config/#{yml_file}")
      update_redis_client(redis_client)
      init_set_key_methods
    end
    
    def update_redis_client(redis_client)
      $redis_client  = redis_client
    end

    def init_set_key_methods
      self.yml_data.keys.each do |k|
        str =<<-END
          def #{k}_set_key(object_id)
            "views/#{k}_\#{object_id}_set_key"
          end
        END
        class_eval str
      end
    end

    def init_fragment_key_methods
      self.yml_data.each do |k, v|
        v.each do |method_name, parameters|
          params = parameters["parameters"].split(",").map!(&:strip)
          uniq_key = params.map do |uniq_key|
            "#{uniq_key}_\#{#{uniq_key}}"
          end.join("_")
          if parameters["uniq"]
            method_suffix = "uniq"
          else
            method_suffix = self.suffix
          end
          str1=<<-END
            def #{k}_#{method_name}_key_by_#{params.join("_and_")}(#{params.join(",")}, add_to_set = true, suffix = "#{method_suffix}")
              key = "#{k}_#{method_name}_#{uniq_key}_\#{suffix}"
              if add_to_set
                $redis_client.sadd #{k}_set_key(#{params.first}), "views/\#{key}"
                $redis_client.expire #{k}_set_key(#{params.first}), #{self.expire_intervel}
              end
              key
            end
          END
          class_eval str1
        end
      end
    end 
  end# ClassMethods

  module InstanceMethods
    def expire_cache_object(*args)
      t = Time.now
      if args.count > 1
        set_key = send("#{args[0]}_set_key", args[1])
      else
        set_key = send("#{args[0].class.to_s.downcase}_set_key", args[0].id)
      end
      keys_array = $redis_client.smembers set_key
      $redis_client.del *keys_array if keys_array and keys_array.count > 0
      $redis_client.del set_key
      Rails.logger.debug "expire fragments key #{set_key}, count: #{keys_array.count}, cost #{Time.now - t} seconds"
    end

    def nbd_expire_fragment_key(key)
      t = Time.now
      success = $redis_client.del key
      Rails.logger.debug "expire fragments key #{key}, success:#{success}, cost #{Time.now - t} seconds"
    end
  end # InstanceMethods
end
