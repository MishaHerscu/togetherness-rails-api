#
class AttractionCategory < ActiveRecord::Base
  belongs_to :attraction, inverse_of: :attraction_categories
  belongs_to :category, inverse_of: :attraction_categories
end
