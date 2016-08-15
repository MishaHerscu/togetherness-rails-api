#
class CreateFriendRequests < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.references :requesting_user
      t.references :requested_user

      t.timestamps null: false
    end
  end
end
