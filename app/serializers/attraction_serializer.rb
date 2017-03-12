#
class AttractionSerializer < ActiveModel::Serializer
  attributes :id, :categories_string, :eventful_id, :city, :city_id, :city_name,
             :country_name, :title, :description, :keywords_string, :owner,
             :db_start_time, :db_stop_time, :event_date, :event_time,
             :event_time_zone, :all_day, :venue_id, :venue_name, :venue_address,
             :postal_code, :venue_url, :geocode_type, :latitude, :longitude,
             :image_information, :medium_image_url, :attraction_suggestions,
             :attraction_categories

  def city
    object.city.id
  end

  def attraction_suggestions
    object.attraction_suggestions.pluck(:id)
  end

  def attraction_categories
    object.attraction_categories.pluck(:id)
  end
end
