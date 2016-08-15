#
class Friend < ActiveRecord::Base
  belongs_to :requesting_user, class_name: 'User', inverse_of: :friends
  belongs_to :requested_user, class_name: 'User', inverse_of: :friends
end
