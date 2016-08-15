#
class TripSerializer < ActiveModel::Serializer
  attributes :id, :name, :notes, :city, :user, :start_date, :end_date,
             :attendances

  def attendances
    object.attendances.pluck(:id)
  end

  def user
    object.user.id
  end

  def city
    object.city.id
  end
end
