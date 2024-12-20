module Jira
  class IssuesController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      interactor = FetchIssuesInteractor.call(
        domain: ENV['JIRA_DOMAIN'],
        token: ENV['JIRA_TOKEN'],
        project_key: ENV['JIRA_PROJECT_KEY'],
        api_version: params[:api_version]
      )

      if interactor.success?
        render json: IssueBlueprint.render(interactor.issues, root: :issues), status: :ok
      else
        render json: { message: interactor.message }, status: :bad_request
      end
    end
  end
end
