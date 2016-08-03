#
class Trip < ActiveRecord::Base
  belongs_to :user, inverse_of: :trips
  belongs_to :city, inverse_of: :trips
  has_many :attendances, inverse_of: :trip, dependent: :destroy
end
