module Jira
  class IssueBlueprint < Blueprinter::Base
    fields :id, :key, :summary, :status, :priority, :assignee, :created, :updated
  end
end
