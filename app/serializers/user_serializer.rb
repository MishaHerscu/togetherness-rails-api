#
class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :admin, :givenname, :surname, :keywords_string,
             :trips, :attendances, :user_tags, :friend_requests, :friendships,
             :attraction_suggestions

  def trips
    object.trips.pluck(:id)
  end

  def attendances
    object.attendances.pluck(:id)
  end

  def user_tags
    object.user_tags.pluck(:id)
  end

  def friend_requests
    object.friend_requests.pluck(:id)
  end

  def friendships
    object.friendships.pluck(:id)
  end

  def attraction_suggestions
    object.attraction_suggestions.pluck(:id)
  end
end
