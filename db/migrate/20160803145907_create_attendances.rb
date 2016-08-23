#
class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.belongs_to :user, index: true, foreign_key: true, null: false
      t.belongs_to :trip, index: true, foreign_key: true, null: false
      t.index [:trip_id, :user_id], unique: true

      t.timestamps null: false
    end
  end
end
