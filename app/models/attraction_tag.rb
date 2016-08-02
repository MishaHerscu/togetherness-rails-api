#
class AttractionTag < ActiveRecord::Base
  belongs_to :tag, inverse_of: :attraction_tags
  belongs_to :attraction, inverse_of: :attraction_tags
end
