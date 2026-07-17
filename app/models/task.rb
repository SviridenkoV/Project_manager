class Task < ApplicationRecord
  belongs_to :project

  STATUSES = %w[to_do in_progress in_testing rejected done].freeze
  PRIORITIES = %w[critical high medium low].freeze

  validates :title, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :priority, inclusion: { in: PRIORITIES }
end
