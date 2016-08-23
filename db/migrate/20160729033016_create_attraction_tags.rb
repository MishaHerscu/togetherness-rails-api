#
class CreateAttractionTags < ActiveRecord::Migration
  def change
    create_table :attraction_tags do |t|
      t.references :tag, index: true, foreign_key: true, null: false
      t.references :attraction, index: true, foreign_key: true, null: false
      t.index [:tag_id, :attraction_id], unique: true

      t.timestamps null: false
    end
  end
end
