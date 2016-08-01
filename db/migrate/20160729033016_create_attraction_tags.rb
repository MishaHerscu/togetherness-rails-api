#
class CreateAttractionTags < ActiveRecord::Migration
  def change
    create_table :attraction_tags do |t|
      t.references :tag, index: true, foreign_key: true
      t.references :attraction, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
