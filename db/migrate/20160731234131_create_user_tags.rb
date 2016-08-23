#
class CreateUserTags < ActiveRecord::Migration
  def change
    create_table :user_tags do |t|
      t.references :tag, index: true, foreign_key: true, null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.boolean :like
      t.index [:tag_id, :user_id], unique: true

      t.timestamps null: false
    end
  end
end
