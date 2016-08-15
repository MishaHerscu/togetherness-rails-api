#
class User < ActiveRecord::Base
  include Authentication
  has_many :examples, inverse_of: :user, dependent: :destroy
  has_many :attraction_suggestions, inverse_of: :user, dependent: :destroy
  has_many :user_tags, inverse_of: :user, dependent: :destroy
  has_many :user_attractions, inverse_of: :user, dependent: :destroy
  has_many :trips, inverse_of: :user, dependent: :destroy
  has_many :attendances, inverse_of: :user, dependent: :destroy
  has_many :friends, inverse_of: :user, dependent: :destroy
end
