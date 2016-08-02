#
class UserAttraction < ActiveRecord::Base
  belongs_to :attraction, inverse_of: :user_attractions
  belongs_to :user, inverse_of: :user_attractions
end
