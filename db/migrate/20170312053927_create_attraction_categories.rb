#
class CreateAttractionCategories < ActiveRecord::Migration
  def change
    create_table :attraction_categories do |t|
      t.references :attraction, index: true, foreign_key: true
      t.references :category, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
