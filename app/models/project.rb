class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :title, presence: true, length: { maximum: 100 }
  validates :title, uniqueness: { scope: :user_id }
end
