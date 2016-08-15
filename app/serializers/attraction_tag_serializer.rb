#
class AttractionTagSerializer < ActiveModel::Serializer
  attributes :id, :tag, :attraction

  def tag
    object.tag.id
  end

  def attraction
    object.attraction.id
  end
end
