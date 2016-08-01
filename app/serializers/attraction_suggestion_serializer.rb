#
class AttractionSuggestionSerializer < ActiveModel::Serializer
  attributes :id
  has_one :user
  has_one :attraction
end
