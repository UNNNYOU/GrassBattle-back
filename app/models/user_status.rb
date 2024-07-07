class UserStatus < ApplicationRecord
  has_many :experience_histories
  has_many :week_contribution_histories
  belongs_to :user

  validates :level, presence: true
  validates :experience_points, presence: true
  validates :week_contributions, presence: true
  validates :contribution_diff, presence: true
end
