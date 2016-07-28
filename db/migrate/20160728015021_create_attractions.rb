#
class CreateAttractions < ActiveRecord::Migration
  def change
    create_table :attractions do |t|
      t.string :city_name
      t.string :country_name
      t.string :title
      t.string :description
      t.string :owner
      t.string :start_time
      t.string :stop_time
      t.string :all_day
      t.string :venue_name
      t.string :venue_address
      t.string :venue_url

      t.timestamps null: false
    end
  end
end
