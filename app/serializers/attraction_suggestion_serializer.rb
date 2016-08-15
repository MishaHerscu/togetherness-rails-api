#
class AttractionSuggestionSerializer < ActiveModel::Serializer
  attributes :id, :user, :attraction

  def user
    object.user.id
  end

  def attraction
    object.attraction.id
  end
end
