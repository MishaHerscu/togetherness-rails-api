#
class UserTagSerializer < ActiveModel::Serializer
  attributes :id, :like, :tag, :user

  def tag
    object.tag.id
  end

  def user
    object.user.id
  end
end
