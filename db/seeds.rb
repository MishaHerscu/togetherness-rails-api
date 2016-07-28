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

chicago_args = { app_key: ENV['EVENTFUL_KEY'],
                 q: 'music',
                 where: 'Chicago',
                 # date: '2013061000-2015062000',
                 page_size: 1,
                 sort_order: 'popularity' }

boston_args = { app_key: ENV['EVENTFUL_KEY'],
                q: 'music',
                where: 'Boston',
                # date: '2013061000-2015062000',
                page_size: 1,
                sort_order: 'popularity' }

newyork_args = { app_key: ENV['EVENTFUL_KEY'],
                 q: 'music',
                 where: 'New York',
                 # date: '2013061000-2015062000',
                 page_size: 1,
                 sort_order: 'popularity' }

chicago_events = eventful.call 'events/search/',
                               chicago_args

boston_events = eventful.call 'events/search/',
                              boston_args

newyork_events = eventful.call 'events/search/',
                               newyork_args

p 'chicago_events'
p chicago_events

p 'boston_events'
p boston_events

p 'newyork_events'
p newyork_events

chicago_events.each do |attraction|
  Attraction.create!(
    city_name: attraction.city_name,
    country_name: attraction.country_name,
    title: attraction.title,
    description: attraction.description,
    owner: attraction.owner,
    start_time: attraction.start_time,
    stop_time: attraction.stop_time,
    all_day: attraction.all_day,
    venue_name: attraction.venue_name,
    venue_address: attraction.venue_address,
    venue_url: attraction.venue_url
  )
end

boston_events.each do |attraction|
  Attraction.create!(
    city_name: attraction.city_name,
    country_name: attraction.country_name,
    title: attraction.title,
    description: attraction.description,
    owner: attraction.owner,
    start_time: attraction.start_time,
    stop_time: attraction.stop_time,
    all_day: attraction.all_day,
    venue_name: attraction.venue_name,
    venue_address: attraction.venue_address,
    venue_url: attraction.venue_url
  )
end

newyork_events.each do |attraction|
  Attraction.create!(
    city_name: attraction.city_name,
    country_name: attraction.country_name,
    title: attraction.title,
    description: attraction.description,
    owner: attraction.owner,
    start_time: attraction.start_time,
    stop_time: attraction.stop_time,
    all_day: attraction.all_day,
    venue_name: attraction.venue_name,
    venue_address: attraction.venue_address,
    venue_url: attraction.venue_url
  )
end
