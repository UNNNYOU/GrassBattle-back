class User < ApplicationRecord
  has_one :user_authentication, dependent: :destroy
  has_one :user_status, dependent: :destroy
  belongs_to :avatar, optional: true

  validates :name, presence: true
  validates :github_uid, presence: true, uniqueness: true
end
