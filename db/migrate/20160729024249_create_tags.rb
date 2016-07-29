class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :tag
      t.integer :usages
      t.integer :relative_usage

      t.timestamps null: false
    end
  end
end
