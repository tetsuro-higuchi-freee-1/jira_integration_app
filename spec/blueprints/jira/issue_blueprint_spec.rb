require 'rails_helper'

RSpec.describe Jira::IssueBlueprint do
  let(:issue) do
    OpenStruct.new(
      id: '123',
      key: 'TEST-123',
      summary: 'Test Issue',
      status: 'In Progress',
      priority: 'High',
      assignee: 'John Doe',
      created: '2024-03-20T10:00:00Z',
      updated: '2024-03-20T11:00:00Z'
    )
  end

  describe '.render' do
    it 'renders all fields correctly' do
      json = JSON.parse(described_class.render(issue))

      expect(json).to include(
        'id' => '123',
        'key' => 'TEST-123',
        'summary' => 'Test Issue',
        'status' => 'In Progress',
        'priority' => 'High',
        'assignee' => 'John Doe',
        'created' => '2024-03-20T10:00:00Z',
        'updated' => '2024-03-20T11:00:00Z'
      )
    end
  end
end
