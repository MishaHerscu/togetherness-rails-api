#
class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :requested_user, null: false
      t.index [:requested_user_id, :user_id], unique: true

      t.timestamps null: false
    end
  end
end
