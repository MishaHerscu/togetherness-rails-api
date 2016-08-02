#
class UserTag < ActiveRecord::Base
  belongs_to :tag, inverse_of: :user_tags
  belongs_to :user, inverse_of: :user_tags
end
