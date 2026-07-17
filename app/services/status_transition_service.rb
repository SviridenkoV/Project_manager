class StatusTransitionService
  def initialize(task)
    @task = task
  end

  def allowed_transitions
    {
      "to_do" => ["in_progress"],
      "in_progress" => %w[in_testing to_do],
      "in_testing" => %w[done rejected],
      "done" => [],
      "rejected" => ["in_progress"]
    }
  end

  def can_transition_to?(new_status)
    allowed_transitions[@task.status]&.include?(new_status) || false
  end

  def transition_to!(new_status)
    raise ArgumentError, "Нельзя перейти из #{@task.status} в #{new_status}" unless can_transition_to?(new_status)

    @task.update!(status: new_status)
  end

  def available_statuses
    [@task.status] + allowed_transitions[@task.status]
  end

  def hint
    allowed = allowed_transitions[@task.status] || []
    if allowed.empty?
      "Нет доступных переходов"
    else
      "Можно перейти в: #{allowed.map(&:humanize).join(', ')}"
    end
  end
end
