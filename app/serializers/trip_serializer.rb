#
class TripSerializer < ActiveModel::Serializer
  attributes :id, :city_id, :user_id, :start_date, :end_date, :attendances
  has_one :user
  has_one :city

  def attendances
    object.attendances.pluck(:id)
  end

  def user_id
    object.user.id
  end

  def city_id
    object.city.id
  end
end
