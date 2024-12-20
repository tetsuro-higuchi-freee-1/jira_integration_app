module Jira
  class FetchIssuesInteractor
    include Interactor

    def call
      validate_input
      client = ApiClient.new(
        domain: context.domain,
        email: context.email,
        token: context.token,
        project_key: context.project_key,
        api_version: context.api_version
      )

      context.issues = client.fetch_issues
    rescue StandardError => e
      context.fail!(message: e.message)
    end

    private

    def validate_input
      required_fields = [:domain, :email, :token, :project_key]
      required_fields.each do |field|
        context.fail!(message: "#{field} is required") if context[field].nil?
      end
    end
  end
end
