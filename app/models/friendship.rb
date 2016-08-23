#
class Friendship < ActiveRecord::Base
  belongs_to :user, inverse_of: :friendships
  belongs_to :requested_user, class_name: 'User', inverse_of: :friendships
end
