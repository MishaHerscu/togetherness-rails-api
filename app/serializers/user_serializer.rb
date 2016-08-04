#
class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :admin, :given_name, :surname, :avatar,
             :trips, :attendances

  def trips
    object.trips.pluck(:id)
  end

  def attendances
    object.attendances.pluck(:id)
  end
end
