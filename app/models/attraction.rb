#
class Attraction < ActiveRecord::Base
  has_many :attraction_suggestions, inverse_of: :attraction, dependent: :destroy
  has_many :attraction_categories, inverse_of: :attraction, dependent: :destroy
  has_many :user_attractions, inverse_of: :attraction, dependent: :destroy
  belongs_to :city, inverse_of: :attractions
  belongs_to :category, inverse_of: :attractions
end
