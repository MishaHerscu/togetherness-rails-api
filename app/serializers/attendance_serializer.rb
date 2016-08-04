#
class AttendanceSerializer < ActiveModel::Serializer
  attributes :id, :user, :trip

  def user
    object.user.id
  end

  def trip
    object.trip.id
  end
end
