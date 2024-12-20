require 'rails_helper'

RSpec.describe Jira::FetchIssuesInteractor do
  let(:valid_context) do
    {
      domain: 'example.atlassian.net',
      email: 'test@example.com',
      token: 'test_token',
      project_key: 'TEST',
      api_version: '3'
    }
  end

  describe '.call' do
    context 'with valid input' do
      it 'succeeds and returns issues' do
        VCR.use_cassette('fetch_issues_interactor') do
          result = described_class.call(valid_context)
          expect(result).to be_a_success
          expect(result.issues).to be_an(Array)
        end
      end
    end

    context 'with missing required parameters' do
      it 'fails when email is missing' do
        result = described_class.call(valid_context.except(:email))
        expect(result).to be_a_failure
        expect(result.message).to include('email is required')
      end

      it 'fails when domain is missing' do
        result = described_class.call(valid_context.except(:domain))
        expect(result).to be_a_failure
        expect(result.message).to include('domain is required')
      end
    end
  end
end
