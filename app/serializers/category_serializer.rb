#
class CategorySerializer < ActiveModel::Serializer
  attributes :id, :title, :label, :attraction_categories

  def attraction_categories
    object.attraction_categories.pluck(:id)
  end
end
