class Task < ApplicationRecord
  belongs_to :project

  STATUSES = %w[to_do in_progress in_testing rejected done].freeze
  PRIORITIES = %w[critical high medium low].freeze

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 1000 }, allow_blank: true
  validates :status, inclusion: { in: STATUSES }
  validates :priority, inclusion: { in: PRIORITIES }
  validates :project, presence: true
  validates :title, uniqueness: { scope: :project_id, message: "already exists in this project" }
end
