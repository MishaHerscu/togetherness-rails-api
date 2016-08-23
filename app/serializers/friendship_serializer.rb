#
class FriendshipSerializer < ActiveModel::Serializer
  attributes :id, :user, :requested_user

  def user
    object.user.id
  end

  def requested_user
    object.requested_user.id
  end
end
