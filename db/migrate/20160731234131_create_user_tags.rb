#
class CreateUserTags < ActiveRecord::Migration
  def change
    create_table :user_tags do |t|
      t.references :tag, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.boolean :like

      t.timestamps null: false
    end
  end
end
