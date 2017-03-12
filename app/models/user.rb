#
class User < ActiveRecord::Base
  include Authentication
  has_many :examples, inverse_of: :user, dependent: :destroy
  has_many :attraction_suggestions, inverse_of: :user, dependent: :destroy
  has_many :user_attractions, inverse_of: :user, dependent: :destroy
  has_many :trips, inverse_of: :user, dependent: :destroy
  has_many :attendances, inverse_of: :user, dependent: :destroy
  has_many :friendships, inverse_of: :user, dependent: :destroy
  has_many :friendships, inverse_of: :requested_user, dependent: :destroy
  has_many :friend_requests, inverse_of: :user, dependent: :destroy
  has_many :friend_requests, inverse_of: :requested_user, dependent: :destroy
end
