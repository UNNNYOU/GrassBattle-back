class WeekContributionHistory < ApplicationRecord
  belongs_to :user_status

  validates :week_contributions, presence: true
end
