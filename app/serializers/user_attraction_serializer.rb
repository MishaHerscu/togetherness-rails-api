#
class UserAttractionSerializer < ActiveModel::Serializer
  attributes :id, :like
  has_one :attraction
  has_one :user
end
