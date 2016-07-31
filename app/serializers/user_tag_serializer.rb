#
class UserTagSerializer < ActiveModel::Serializer
  attributes :id
  has_one :tag
  has_one :user
end
