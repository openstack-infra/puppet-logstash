require 'spec_helper_acceptance'

describe 'puppet-logstash module', :if => ['debian', 'ubuntu'].include?(os[:family]) do
  def pp_path
    base_path = File.dirname(__FILE__)
    File.join(base_path, 'fixtures')
  end

  def default_puppet_module
    module_path = File.join(pp_path, 'default.pp')
    File.read(module_path)
  end

  it 'should work with no errors' do
    apply_manifest(default_puppet_module, catch_failures: true)
  end

  it 'should be idempotent' do
    apply_manifest(default_puppet_module, catch_changes: true)
  end

  describe 'require files' do
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
  end

  describe 'required package' do
    describe package('openjdk-7-jre-headless') do
      it { should be_installed }
    end
  end

  describe 'required services' do
    describe service('logstash-agent') do
      it { should be_enabled }
      it { should be_running }
    end

    describe service('logstash-indexer') do
      it { should be_enabled }
      it { should be_running }
    end
  end

  describe 'required user' do
    describe user('logstash') do
      it { should exist }
      it { should belong_to_group 'logstash' }
      it { should have_home_directory '/opt/logstash' }
    end

    describe group('logstash') do
      it { should exist }
    end
  end
end
