class UserSerializer < ActiveModel::Serializer
  has_many :user_status, serializer: UserStatusSerializer

  attributes :id, :name, :avatar_id
end
