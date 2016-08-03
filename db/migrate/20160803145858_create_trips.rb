#
class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :city, index: true, foreign_key: true
      t.date :start_date
      t.date :end_date

      t.timestamps null: false
    end
  end
end
