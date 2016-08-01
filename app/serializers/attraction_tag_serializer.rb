#
class AttractionTagSerializer < ActiveModel::Serializer
  attributes :id, :tag_id, :attraction_id
  has_one :tag
  has_one :attraction
end
