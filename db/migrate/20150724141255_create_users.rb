#
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :token, null: false, index: { unique: true }
      t.string :password_digest, null: false
      t.boolean :admin, null: false
      t.string :givenname, null: false
      t.string :surname, null: false
      t.string :keywords_string

      # t.references :friend
      # t.references :friendrequest

      t.timestamps null: false
    end
  end
end
