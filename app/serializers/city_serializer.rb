#
class CitySerializer < ActiveModel::Serializer
  attributes :id, :name, :attractions, :trips

  def attractions
    object.attractions.pluck(:id)
  end

  def trips
    object.trips.pluck(:id)
  end
end
