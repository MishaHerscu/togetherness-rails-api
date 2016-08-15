#
class Friend < ActiveRecord::Base
  belongs_to :requesting_user, class_name: 'User'
  belongs_to :requested_user, class_name: 'User'
  has_many :users
end
