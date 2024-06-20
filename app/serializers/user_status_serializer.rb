class UserStatusSerializer < ActiveModel::Serializer
  attributes :level, :experience_points, :week_contributions
end
