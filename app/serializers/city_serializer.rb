#
class CitySerializer < ActiveModel::Serializer
  attributes :id, :name, :attractions
end
