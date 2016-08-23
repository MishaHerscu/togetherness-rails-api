#
class FriendRequest < ActiveRecord::Base
  belongs_to :user, inverse_of: :friend_requests
  belongs_to :requested_user, class_name: 'User', inverse_of: :friend_requests
end
