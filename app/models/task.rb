class Task < ApplicationRecord
  belongs_to :project

  STATUSES = ["to_do", "in_progress", "in_testing", "rejected", "done"].freeze
  PRIORITIES = ["critical", "high", "medium", "low"].freeze

  validates :title, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :priority, inclusion: { in: PRIORITIES }

  def allowed_transitions
    {
      "to_do" => ["in_progress"],
      "in_progress" => ["in_testing", "to_do"],
      "in_testing" => ["done", "rejected"],
      "done" => [],
      "rejected" => ["in_progress"]
    }
  end

  def can_transition_to?(new_status)
    allowed_transitions[status]&.include?(new_status) || false
  end

  def transitions_hint
    allowed = allowed_transitions[status] || []
    if allowed.empty?
      "Нет доступных переходов"
    else
      "Можно перейти в: #{allowed.map(&:humanize).join(', ')}"
    end
  end
end