#
class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :admin, :givenname, :surname,
             :trips, :attendances, :user_tags # , :friends, :friend_requests

  def trips
    object.trips.pluck(:id)
  end

  def attendances
    object.attendances.pluck(:id)
  end

  def user_tags
    object.user_tags.pluck(:id)
  end

  # def friends
  #   object.friends.pluck(:id)
  # end
  #
  # def friend_requests
  #   object.friend_requests.pluck(:id)
  # end
end
