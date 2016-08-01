#
class CreateUserAttractions < ActiveRecord::Migration
  def change
    create_table :user_attractions do |t|
      t.references :attraction, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.boolean :like

      t.timestamps null: false
    end
  end
end
