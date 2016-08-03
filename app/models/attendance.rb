#
class Attendance < ActiveRecord::Base
  belongs_to :user, inverse_of: :attendances
  belongs_to :trip, inverse_of: :attendances
end
