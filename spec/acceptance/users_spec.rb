require 'spec_helper_acceptance'

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
