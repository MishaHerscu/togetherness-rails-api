#
class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :admin, :givenname, :surname,
             :trips, :attendances, :user_tags

  def trips
    object.trips.pluck(:id)
  end

  def attendances
    object.attendances.pluck(:id)
  end

  def user_tags
    object.user_tags.pluck(:id)
  end
end
