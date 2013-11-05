module KnifeDocker
  class Container
    DOCKER_URL        = "http://127.0.0.1:4243".freeze
    DOCKER_BASE_IMAGE = "ubuntu".freeze

    attr_reader :name,
                :docker_url, :docker_base_image,
                :chef_encrypted_data_bag_key_path, :chef_encrypted_data_bag_key

    def initialize(name, opts = {})
      @name = name
      @docker_url = opts[:docker_url] || DOCKER_URL
      @docker_base_image = opts[:docker_base_image] || DOCKER_BASE_IMAGE
      @chef_encrypted_data_bag_key_path = opts[:chef_encrypted_data_bag_key_path]

      if @chef_encrypted_data_bag_key_path
        if File.exists?(@chef_encrypted_data_bag_key_path)
          @chef_encrypted_data_bag_key = File.read(@chef_encrypted_data_bag_key_path).strip
        else
          raise ArgumentError, "Invalid Chef Encrypted Data Bag Key Path"
        end
      end
    end

    def setup_docker_container
    end

    def setup_chef_solo
    end

    def setup_chef_encrypted_data_bag_key
    end

    def setup_runtime_chef_variables
    end

    def setup_cookbook
    end

    def run_chef_solo
    end

    def self.parse
      config_file = 'docker.json'
      parsed_json = nil

      return nil if !File.exists? config_file

      begin
        parsed_json = JSON.parse(File.read(config_file))
      rescue JSON::ParserError => e
        puts "Invalid JSON. Check your docker.json file: #{e.message}"
        return nil
      end

      container = self.new(parsed_json['name'],
                           docker_url: parsed_json['docker_url'],
                           docker_base_image: parsed_json['docker_base_image'],
                           chef_encrypted_data_bag_key_path: parsed_json['chef_encrypted_data_bag_key_path'])

      container
    end
  end
end
