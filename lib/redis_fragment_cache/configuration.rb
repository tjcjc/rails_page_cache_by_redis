require 'yaml'
module RedisFragmentCache
  class Configuration
    attr_accessor :redis_client
    attr_accessor :suffix
    attr_accessor :expire_time
    attr_accessor :yml_file_path

    def yml_data
      @_yml_data ||= YAML.load_file(yml_file_path)
    end
  end
end
