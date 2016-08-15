#
class FriendRequestSerializer < ActiveModel::Serializer
  attributes :id, :requesting_user, :requested_user

  def requesting_user
    object.requested_user.id
  end

  def requested_user
    object.requested_user.id
  end
end
