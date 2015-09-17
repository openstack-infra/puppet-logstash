require 'spec_helper_acceptance'

describe 'required files' do
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
