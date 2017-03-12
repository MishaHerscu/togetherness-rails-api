#
class AttractionCategorySerializer < ActiveModel::Serializer
  attributes :id, :attraction, :category

  def attraction
    object.attraction.id
  end

  def category
    object.category.id
  end
end
