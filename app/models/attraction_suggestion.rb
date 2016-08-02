#
class AttractionSuggestion < ActiveRecord::Base
  belongs_to :user, inverse_of: :attraction_suggestions
  belongs_to :attraction, inverse_of: :attraction_suggestions
end
