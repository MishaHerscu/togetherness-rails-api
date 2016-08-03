#
class AttendanceSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :trip_id
  has_one :user
  has_one :trip

  def user_id
    object.user.id
  end

  def trip_id
    object.trip.id
  end
end
