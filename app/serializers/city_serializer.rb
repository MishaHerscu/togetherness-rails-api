#
class CitySerializer < ActiveModel::Serializer
  attributes :id, :name, :attractions

  def attractions
    object.attractions.pluck(:id)
  end
end
