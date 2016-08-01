class CreateAttractionSuggestions < ActiveRecord::Migration
  def change
    create_table :attraction_suggestions do |t|
      t.references :user, index: true, foreign_key: true
      t.references :attraction, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
