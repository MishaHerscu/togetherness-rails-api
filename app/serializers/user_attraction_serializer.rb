#
class UserAttractionSerializer < ActiveModel::Serializer
  attributes :id, :like, :attraction_id, :user_id
  has_one :attraction
  has_one :user
end
