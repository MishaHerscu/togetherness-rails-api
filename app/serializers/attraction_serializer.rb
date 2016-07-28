#
class AttractionSerializer < ActiveModel::Serializer
  attributes :id, :city_name, :country_name, :title, :description, :owner,
             :start_time, :stop_time, :all_day, :venue_name, :venue_address,
             :venue_url
end
