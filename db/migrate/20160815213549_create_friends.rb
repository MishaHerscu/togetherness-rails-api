#
class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friend_requests do |t|
      t.references :requesting_user
      t.references :requested_user

      t.timestamps null: false
    end
  end
end
