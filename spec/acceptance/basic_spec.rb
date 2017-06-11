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
    describe 'module logstash::elasticsearch' do
      describe file('/etc/elasticsearch/templates/logstash_settings.json') do
        it { should be_file }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
        its(:content) { should include '"index.cache.field.type" : "soft"' }
      end
    end

    describe 'module logstash::indexer' do
      describe file('/etc/logstash/conf.d/00-input.conf') do
        it { should be_file }
        it { should be_owned_by 'logstash' }
        it { should be_grouped_into 'logstash' }
        its(:content) { should include 'type => "redis-input"' }
        its(:content) { should include 'host => "127.0.0.1"' }
      end

      describe file('/etc/logstash/conf.d/99-output.conf') do
        it { should be_file }
        it { should be_owned_by 'logstash' }
        it { should be_grouped_into 'logstash' }
        its(:content) { should include 'host => "127.0.0.1"' }
      end

      describe file('/etc/default/logstash') do
        its(:content) { should include 'LS_OPTS="-w 1"' }
      end
    end
  end

  describe 'required package' do
    describe package('openjdk-8-jre-headless') do
      it { should be_installed }
    end

    describe package('logstash') do
      it { should be_installed }
    end
  end

  describe 'required services' do
    describe service('logstash') do
      it { should be_enabled }
      it { should be_running }
    end
  end
end
