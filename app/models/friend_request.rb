#
class FriendRequest < ActiveRecord::Base
  belongs_to :requesting_user, class_name: 'User', inverse_of: :friend_requests
  belongs_to :requested_user, class_name: 'User', inverse_of: :friend_requests
end
