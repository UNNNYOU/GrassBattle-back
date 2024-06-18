class User < ApplicationRecord
  has_one :user_authentication, dependent: :destroy
  has_one :user_status, dependent: :destroy
end
