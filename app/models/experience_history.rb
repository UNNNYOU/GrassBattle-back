class ExperienceHistory < ApplicationRecord
  belongs_to :user_status

  validates :earned_experience_points, presence: true
end
