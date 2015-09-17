require 'spec_helper_acceptance.rb'

describe 'required services', :if => ['debian', 'ubuntu'].include?(os[:family]) do
  describe service('logstash-agent') do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('logstash-indexer') do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('redis-server') do
    it { should be_enabled }
    it { should be_running }
  end
end
