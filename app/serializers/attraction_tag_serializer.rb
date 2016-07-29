class AttractionTagSerializer < ActiveModel::Serializer
  attributes :id
  has_one :tag
  has_one :attraction
end
