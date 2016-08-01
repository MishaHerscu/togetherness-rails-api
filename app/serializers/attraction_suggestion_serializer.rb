#
class AttractionSuggestionSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :attraction_id
  has_one :user
  has_one :attraction
end
