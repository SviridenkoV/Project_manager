class Task < ApplicationRecord
  belongs_to :project

  validates :title, presence: true

  enum :status, { to_do: 0, in_progress: 1, in_testing: 2, rejected: 3, done: 4 }
  enum :priority, { critical: 0, high: 1, medium: 2, low: 3 }

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

  after_initialize :set_default_priority, if: :new_record?

  private

  def set_default_priority
    self.priority ||= :medium
  end
end