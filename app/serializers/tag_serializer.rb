#
class TagSerializer < ActiveModel::Serializer
  attributes :id, :tag, :usages, :relative_usage, :users, :attractions

  def users
    object.users.pluck(:id)
  end

  def attractions
    object.attractions.pluck(:id)
  end
end
