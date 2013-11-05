module KnifeDocker
  ROOT = File.expand_path(File.dirname(__FILE__) + '/../')
end

require "docker"
require "knife-docker/version"
require "knife-docker/container"

require "chef/knife/docker_base"
require "chef/knife/docker_build"
require "chef/knife/docker_verify"
require "chef/knife/docker_build_artifact"
require "chef/knife/docker_deploy_artifact"
require "chef/knife/docker_destroy"


