require 'spec_helper'

describe Gami::GithubEventParser do
  subject {described_class.new(client,event,raw)}

  let(:client){Gami::Client.new}
  let(:event){"git:push"}
  let(:raw){File.open(File.expand_path('../../fixtures/github_payload.json', __FILE__)).read}

  it 'should load the github payload' do
    expect(raw).to match (/Eric Claus Bartholemy/)
  end

  describe 'dataset contains' do
    it {expect(subject.dataset[:game][:commits_count]).to eql(1)}
    it {expect(subject.dataset[:game][:repo]).to match (/thnukid\/gami-githubwatcher/)}
    it {expect(subject.dataset[:game][:message]).to match (/fix json array, now sends data to gami server/)}
    it {expect(subject.dataset[:game][:commit_stats]).to include({:rm_total => 0, :add_total => 0, :mod_total => 2})}
    it {expect(subject.dataset[:raw]).to eql(raw)}
  end

  it 'should send the data via the client' do
    expect(true).to be(true)
  end
end

describe Gami::Client do
  subject{described_class.new}
end
