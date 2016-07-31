#
class CreateAttractions < ActiveRecord::Migration
  def change
    create_table :attractions do |t|
      t.string :eventful_id
      t.string :city_name
      t.string :country_name
      t.string :title
      t.string :description
      t.string :owner
      t.datetime :db_start_time
      t.datetime :db_stop_time
      t.string :event_date
      t.string :event_time
      t.string :event_time_zone
      t.integer :all_day
      t.string :venue_id
      t.string :venue_name
      t.string :venue_address
      t.integer :postal_code
      t.string :venue_url
      t.string :geocode_type
      t.float :latitude
      t.float :longitude
      t.string :image_information
      t.string :medium_image_url

      t.timestamps null: false
    end
  end
end
