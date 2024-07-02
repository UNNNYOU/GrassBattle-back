class UserStatus < ApplicationRecord
  has_many :experience_histories
  belongs_to :user

  validates :level, presence: true
  validates :experience_points, presence: true
  validates :contribution_diff, presence: true
end
