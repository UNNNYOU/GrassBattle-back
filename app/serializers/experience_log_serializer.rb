class ExperienceLogSerializer < ActiveModel::Serializer
  attributes :id, :earned_experience_points, :created_at
end
