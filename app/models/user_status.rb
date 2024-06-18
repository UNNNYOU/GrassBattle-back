class UserStatus < ApplicationRecord
  belongs_to :user

  validates :level, presence: true
  validates :experience_points, presence: true
  validates :temporal_contribution_data, presence: true
end
