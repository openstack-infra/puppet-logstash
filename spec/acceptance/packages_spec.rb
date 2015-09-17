require 'spec_helper_acceptance'

describe 'required package' do
  describe package('openjdk-7-jre-headless') do
    it { should be_installed }
  end

  describe package('redis-server') do
    it { should be_installed }
  end
end
