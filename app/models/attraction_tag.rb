class AttractionTag < ActiveRecord::Base
  belongs_to :tag
  belongs_to :attraction
end
