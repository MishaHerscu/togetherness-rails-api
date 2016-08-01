#
class UserTagSerializer < ActiveModel::Serializer
  attributes :id, :like, :tag_id, :user_id
  has_one :tag
  has_one :user
end
