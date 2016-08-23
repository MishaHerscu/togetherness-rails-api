#
class CreateUserAttractions < ActiveRecord::Migration
  def change
    create_table :user_attractions do |t|
      t.references :attraction, index: true, foreign_key: true, null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.boolean :like
      t.index [:attraction_id, :user_id], unique: true

      t.timestamps null: false
    end
  end
end
