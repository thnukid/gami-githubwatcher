require 'spec_helper'
require 'pry'

describe Gami::GithubPushParser do

  let(:client){Gami::Client.new}
  let(:event){"git:push"}
  let(:raw){File.open(File.expand_path('../../fixtures/github_payload.json', __FILE__)).read}
  let(:faraday) {Faraday::Response.new}
  subject {described_class.new(client,event,raw)}

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

  describe 'should send the data via the client' do
    it {
      #expect(subject).to receive(:save)
      expect(client).to receive(:send_event)
      subject.save
    }
  end
end

describe Gami::GithubWatchParser do
  let(:client){Gami::Client.new}
  let(:event){"git:push"}
  let(:raw){File.open(File.expand_path('../../fixtures/github_watch_payload.json', __FILE__)).read}
  let(:faraday) {Faraday::Response.new}
  subject {described_class.new(client,event,raw)}

  it 'should load the github payload' do
    expect(raw).to match (/thnukid/)
  end

  describe 'dataset contains' do
    it {expect(subject.dataset[:game][:star_count]).to eql(1)}
    it {expect(subject.dataset[:game][:star_count_total]).to eql(1)}
    it {expect(subject.dataset[:game][:repo_name]).to eq('thnukid/gami-server')}
    it {expect(subject.author).to match ('thnukid@users.noreply.github.com')}
    it {expect(subject.dataset[:game][:repo_ruby]).to eq(1)}
    it {expect(subject.dataset[:raw]).to eql(raw)}
  end

  describe 'should send the data via the client' do
    it {
      expect(client).to receive(:send_event)
      subject.save
    }
  end

end


describe Gami::Client do
  subject{described_class.new}
end
