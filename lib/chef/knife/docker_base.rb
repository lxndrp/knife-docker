require 'chef/knife'

class Chef
  class Knife
    module DockerBase
      def self.included(includer)
        includer.class_eval do
          deps do
            require 'chef/json_compat'
            require 'chef/knife/bootstrap'
            require 'chef/knife/ssh'

            require 'docker'

            Chef::Knife::Ssh.load_deps
            Chef::Knife::Bootstrap.load_deps
          end
        end
      end
    end
  end
end
