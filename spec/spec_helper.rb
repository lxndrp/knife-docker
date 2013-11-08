require 'knife-docker'

require 'rspec'
require 'fakefs/safe'
require 'fakefs/spec_helpers'

['contexts', 'helpers', 'matchers'].each do |dir|
  Dir[File.expand_path(File.join(File.dirname(__FILE__),dir,'*.rb'))].each { |f| require f }
end

RSpec.configure do |c|
  # c.include FakeFS::SpecHelpers
end
