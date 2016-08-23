#
class CreateAttractionSuggestions < ActiveRecord::Migration
  def change
    create_table :attraction_suggestions do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :attraction, index: true, foreign_key: true, null: false
      t.index [:attraction_id, :user_id], unique: true

      t.timestamps null: false
    end
  end
end
