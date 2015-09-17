require 'spec_helper_acceptance'

describe 'require files', :if => ['debian', 'ubuntu'].include?(os[:family]) do
  describe 'module logstash' do
    describe file('/opt/logstash/logstash-1.3.3-flatjar.jar') do
      it { should be_file }
      it { should be_owned_by 'logstash' }
      it { should be_grouped_into 'logstash' }
    end

    describe file('/opt/logstash/logstash.jar') do
      it { should be_linked_to '/opt/logstash/logstash-1.3.3-flatjar.jar' }
    end

    describe file('/var/log/logstash') do
      it { should be_directory }
      it { should be_owned_by 'logstash' }
      it { should be_grouped_into 'logstash' }
    end

    describe file('/etc/logstash') do
      it { should be_directory }
      it { should be_owned_by 'logstash' }
      it { should be_grouped_into 'logstash' }
    end
  end

  describe 'module logstash::agent' do
    describe file('/etc/init/logstash-agent.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      its(:content) { should include 'description     "logstash agent instance"' }
    end

    describe file('/etc/logstash/agent.conf') do
      it { should be_file }
      it { should be_owned_by 'logstash' }
      it { should be_grouped_into 'logstash' }
      its(:content) { should include 'redis { host => "127.0.0.1" data_type => "list" key => "logstash" }' }
    end
  end

  describe 'module logstash::elasticsearch' do
    describe file('/etc/elasticsearch/templates/logstash_settings.json') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      its(:content) { should include '"index.cache.field.type" : "soft"' }
    end
  end

  describe 'module logstash::indexer' do
    describe file('/etc/init/logstash-indexer.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      its(:content) { should include 'description     "logstash indexer instance"' }
    end

    describe file('/etc/logstash/indexer.conf') do
      it { should be_file }
      it { should be_owned_by 'logstash' }
      it { should be_grouped_into 'logstash' }
      its(:content) { should include 'host => "127.0.0.1"' }
    end

    describe file('/etc/logrotate.d/indexer.log') do
      its(:content) { should include '/var/log/logstash/indexer.log' }
    end
  end

  describe 'module logstash::redis' do
    describe file('/etc/redis/redis.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      its(:content) { should include 'daemonize yes' }
    end
  end
end
