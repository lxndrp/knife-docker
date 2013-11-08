module KnifeDocker
  class DockerBuild < Chef::Knife

    # include Chef::Knife::DockerBase

    banner    'knife docker build'
    category  'docker'

    def run
      # Steps
      #
      # 1. Parse docker.json file and gets following information
      #    name of the container (required), docker URL (optional), docker auth (optional), base image (optional), encrypted data bag key (optional), required chef version (optional) other run-time attributes
      #    except for the encrypted data bag key, every other
      container = KnifeDocker::Container.parse

      #
      # 2. Docker.build container
      #    This should
      #    * add SSH on port 22
      container.setup_docker_container
      #    * install chef-solo on it (required version)
      container.setup_chef_solo
      #    * copy over encrypted data bag key (if set)
      container.setup_chef_encrypted_data_bag_key
      #    * copy over runtime.json
      container.setup_runtime_chef_variables
      #    * copy over contents of the cookbook
      container.setup_cookbook
      #
      # 3. Run chef-solo
      container.run_chef_solo
    end
  end
end

