require 'rails_helper'

RSpec.describe Jira::ApiClient do
  let(:config) do
    {
      domain: 'example.atlassian.net',
      email: 'test@example.com',
      token: 'test_token',
      project_key: 'TEST',
      api_version: '3'
    }
  end

  describe '#fetch_issues' do
    it 'successfully fetches issues' do
      VCR.use_cassette('jira_issues_fetch') do
        client = described_class.new(config)
        issues = client.fetch_issues

        expect(issues).to be_an(Array)
        expect(issues.first).to respond_to(
          :id, :key, :summary, :status, :priority, :created, :updated
        )
      end
    end

    it 'uses basic authentication' do
      stub_request(:get, /.*\/search/)
        .with(
          headers: {
            'Authorization' => /Basic .+/,
            'Content-Type' => 'application/json'
          }
        )
        .to_return(
          status: 200,
          body: { issues: [] }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      client = described_class.new(config)
      client.fetch_issues
    end
  end
end
