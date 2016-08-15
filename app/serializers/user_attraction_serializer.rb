#
class UserAttractionSerializer < ActiveModel::Serializer
  attributes :id, :like, :attraction, :user

  def attraction
    object.attraction.id
  end

  def user
    object.user.id
  end
end
