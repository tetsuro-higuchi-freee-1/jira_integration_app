module Jira
  class ApiClient
    include HTTParty
    base_uri "https://#{ENV['JIRA_DOMAIN']}/rest/api/3"

    def initialize(config)
      @domain = config[:domain]
      @email = config[:email]
      @token = config[:token]
      @project_key = config[:project_key]
      @api_version = config[:api_version] || '3'
    end

    def fetch_issues(jql = nil)
      jwt_token = Base64.strict_encode64("#{@email}:#{@token}")
      response = HTTParty.post(
        "https://#{ENV['JIRA_DOMAIN']}/rest/api/3/search",
        headers: {
          "Authorization" => "Basic #{jwt_token}", # email@example.com:API_TOKEN をあなたのメールアドレスとAPIトークンで置き換えてください。
          "Content-Type" => "application/json"
        },
        body: {
          jql: "project = #{@project_key}", # Your_Project_Key をあなたのプロジェクトキーで置き換えてください。
          startAt: 0,
          maxResults: 15, # この数値は取得したい結果の数値に変更することが可能です。
          fields: ['summary', 'status', 'priority', 'assignee', 'created', 'updated'] # これは取得したいフィールドの配列です。あなたのニーズに合わせて変更してください。
        }.to_json
      )

      if response.code == 200
        response.parsed_response['issues'].map do |issue|
          parse_issue(issue)
        end
      else
        puts "HTTP Request failed (status code: #{response.code})"
      end
    end

    private

    def parse_issue(raw_issue)
      OpenStruct.new(
        id: raw_issue['id'],
        key: raw_issue['key'],
        summary: raw_issue.dig('fields', 'summary'),
        status: raw_issue.dig('fields', 'status', 'name'),
        priority: raw_issue.dig('fields', 'priority', 'name'),
        assignee: raw_issue.dig('fields', 'assignee', 'displayName'),
        created: raw_issue.dig('fields', 'created'),
        updated: raw_issue.dig('fields', 'updated')
      )
    end
  end
end
