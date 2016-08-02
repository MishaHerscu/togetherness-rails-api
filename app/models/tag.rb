#
class Tag < ActiveRecord::Base
  has_many :attraction_tags, inverse_of: :tag, dependent: :destroy
  has_many :user_tags, inverse_of: :tag, dependent: :destroy
end
