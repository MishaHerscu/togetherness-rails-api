#
class City < ActiveRecord::Base
  has_many :attractions, inverse_of: :city, dependent: :destroy
  has_many :trips, inverse_of: :city, dependent: :destroy
end
