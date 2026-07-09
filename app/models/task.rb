class Task < ApplicationRecord
  belongs_to :project

  enum :status, {
    to_do: 0,
    in_progress: 1,
    in_testing: 2,
    rejected: 3,
    done: 4
  }

  
end