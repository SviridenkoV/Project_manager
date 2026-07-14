class Task < ApplicationRecord
  belongs_to :project

  validates :title, presence: true

  enum :status, {
    to_do: 0,
    in_progress: 1,
    in_testing: 2,
    rejected: 3,
    done: 4
  }

  #логика изменений состояний
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

  #здесь я решил добавить подскази пользователю в какие состояния можно переходить,
  #а то, как будто, интуитивно тяжело будет догадаться :/

  def transitions_hint
    allowed = allowed_transitions[status] || []
    if allowed.empty?
      "Нет доступных переходов"
    else
      "Можно перейти в: #{allowed.map(&:humanize).join(', ')}"
    end
  end
  
end