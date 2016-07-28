# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db
# with db:setup).

# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'eventful/api'

# p 'env:', ENV['EVENTFUL_KEY']
p 'getting seed data'

eventful = Eventful::API.new ENV['EVENTFUL_KEY']

cities = ['Chicago', 'Boston', 'New York']
all_events = []

cities.each do |city|
  city_args = { app_key: ENV['EVENTFUL_KEY'],
                q: 'music',
                where: city,
                # date: '2013061000-2015062000',
                page_size: 5,
                sort_order: 'popularity' }
  city_events = eventful.call 'events/search/',
                              city_args
  all_events << city_events
end

def create_attractions(results)
  results.values[0].values[0].each do |attraction|
    p attraction
    p 'XXXXXXXXX'
    Attraction.create!(
      city_name: attraction[:city_name],
      country_name: attraction[:country_name],
      title: attraction[:title],
      description: attraction[:description],
      owner: attraction[:owner],
      start_time: attraction[:start_time],
      stop_time: attraction[:stop_time],
      all_day: attraction[:all_day],
      venue_name: attraction[:venue_name],
      venue_address: attraction[:venue_address],
      venue_url: attraction[:venue_url]
    )
  end
end

all_events.each do |event|
  create_attractions(event)
end
