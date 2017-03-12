#
class Category < ActiveRecord::Base
  has_many :attraction_categories, inverse_of: :category, dependent: :destroy
end
