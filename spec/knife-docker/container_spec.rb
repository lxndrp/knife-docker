require 'spec_helper'

describe KnifeDocker::Container do
  let!(:config_file)  { 'docker.json' }

  before do
    config = File.read(File.join(KnifeDocker::ROOT, "spec", "fixtures", "server.json"))
    FakeFS.activate!
    FileUtils.rm_rf(config_file) if File.exists?(config_file)
    File.open(config_file, 'w') { |f| f.puts config }
  end

  after do
    FakeFS.deactivate!
  end

  describe ".initialize" do
    context "without optional attributes" do
      before do
        @container = KnifeDocker::Container.new('base_container_template')
      end

      it "should set the right attributes" do
        expect(@container.name).to eql 'base_container_template'
        expect(@container.docker_url).to eql 'http://127.0.0.1:4243'
        expect(@container.docker_base_image).to eql 'ubuntu'
      end
    end

    context "with optional attributes" do
      let!(:chef_encrypted_data_bag_key_path) { '/var/chef/encrypted_data_bag_key' }
      let!(:key)                              { 'secrud_key' }

      context "when chef_encrypted_data_bag_key_path is valid" do
        before do
          FileUtils.mkdir_p(File.dirname(chef_encrypted_data_bag_key_path))
          File.open(chef_encrypted_data_bag_key_path, 'w') { |f| f.puts key }
        end

        after do
          FileUtils.rm_rf(chef_encrypted_data_bag_key_path)
        end

        it "should set all the right attributes" do
          @container = KnifeDocker::Container.new('base_container_template',
                                                  docker_url: 'http://127.0.0.1:9191',
                                                  docker_base_image: 'centos',
                                                  chef_encrypted_data_bag_key_path: chef_encrypted_data_bag_key_path)

          expect(@container.name).to eql 'base_container_template'
          expect(@container.docker_url).to eql 'http://127.0.0.1:9191'
          expect(@container.docker_base_image).to eql 'centos'
          expect(@container.chef_encrypted_data_bag_key_path).to eql chef_encrypted_data_bag_key_path
          expect(@container.chef_encrypted_data_bag_key).to eql key
        end
      end

      context "when chef_encrypted_data_bag_key_path is invalid" do
        it "should raise an error" do
          expect {
            @container = KnifeDocker::Container.new('base_container_template',
                                                    docker_url: 'http://127.0.0.1:9191',
                                                    docker_base_image: 'centos',
                                                    chef_encrypted_data_bag_key_path: chef_encrypted_data_bag_key_path)
          }.to raise_error ArgumentError
        end
      end
    end
  end

  describe ".parse" do
    let!(:chef_encrypted_data_bag_key_path) { '/var/chef/encrypted_data_bag_key' }
    let!(:key)                              { 'secrud_key' }

    before do
      FileUtils.mkdir_p(File.dirname(chef_encrypted_data_bag_key_path))
      File.open(chef_encrypted_data_bag_key_path, 'w') { |f| f.puts key }
    end

    after do
      FileUtils.rm_rf(chef_encrypted_data_bag_key_path)
    end

    context "docker.json doesn't exist in cwd" do
      before do
        FileUtils.rm_rf('docker.json')
      end

      it "should return nil" do
        KnifeDocker::Container.parse.should be_nil
      end
    end

    context "docker.json does exist in cwd" do
      context "docker.json is invalid JSON" do
        before do
          File.open(config_file, 'w') { |f| f.puts "abc" }
        end

        it "should return nil" do
          KnifeDocker::Container.parse.should be_nil
        end
      end

      context "docker.json is valid JSON" do
        it "should return a container" do
          container = KnifeDocker::Container.parse
          container.class.should == KnifeDocker::Container

          expect(container.name).to eql 'base_container_template'
          expect(container.docker_url).to eql 'http://127.0.0.1:9191'
          expect(container.docker_base_image).to eql 'centos'
          expect(container.chef_encrypted_data_bag_key).to eql 'secrud_key'
        end
      end
    end
  end
end
