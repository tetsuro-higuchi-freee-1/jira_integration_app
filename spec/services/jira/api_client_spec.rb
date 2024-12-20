require 'rails_helper'

RSpec.describe Jira::ApiClient do
  let(:config) do
    {
      domain: 'example.atlassian.net',
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
        expect(issues.first).to include(
          :id, :key, :summary, :status, :priority, :created, :updated
        )
      end
    end
  end
end
