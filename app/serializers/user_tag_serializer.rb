#
class UserTagSerializer < ActiveModel::Serializer
  attributes :id, :like
  has_one :tag
  has_one :user
end
