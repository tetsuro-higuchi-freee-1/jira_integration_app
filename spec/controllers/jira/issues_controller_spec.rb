require 'rails_helper'

RSpec.describe Jira::IssuesController, type: :controller do
  describe 'POST #create' do
    let(:valid_params) do
      {
        domain: 'example.atlassian.net',
        token: 'test_token',
        project_key: 'TEST'
      }
    end

    context 'with valid parameters' do
      it 'returns issues successfully' do
        VCR.use_cassette('issues_controller') do
          post :create, params: valid_params
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['issues']).to be_an(Array)
        end
      end
    end

    context 'with invalid parameters' do
      it 'returns an error' do
        post :create, params: {}
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
