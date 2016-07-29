class TagSerializer < ActiveModel::Serializer
  attributes :id, :tag, :usages, :relative_usage
end
