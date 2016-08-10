#
class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :admin, :givenname, :surname,
             :trips, :attendances

  def trips
    object.trips.pluck(:id)
  end

  def attendances
    object.attendances.pluck(:id)
  end
end
