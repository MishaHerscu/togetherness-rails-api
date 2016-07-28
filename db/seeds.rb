# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db
# with db:setup).

# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#
# GET EVENT DATA FROM EVENTFUL
#

require 'eventful/api'
require_relative 'stopwords'

# p 'env:', ENV['EVENTFUL_KEY']
p 'getting seed data'

eventful = Eventful::API.new ENV['EVENTFUL_KEY']

cities = ['Chicago', 'Boston', 'New York', 'San Francisco', 'Los Angeles',
          'Las Vegas', 'Austin', 'Seattle', 'Denver', 'Nashville']
all_events = []

cities.each do |city|
  city_args = {
    app_key: ENV['EVENTFUL_KEY'],
    # q: 'music',
    where: city,
    # date: '2013061000-2015062000',
    # sort_order: 'popularity',
    page_size: 10
  }
  city_events = eventful.call 'events/search/',
                              city_args
  all_events << city_events
end

def create_attractions(results)
  results.values[0].values[0].each do |attraction|
    p attraction
    p 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
    Attraction.create(
      city_name: attraction['city_name'],
      country_name: attraction['country_name'],
      title: attraction['title'],
      description: attraction['description'],
      owner: attraction['owner'],
      start_time: attraction['start_time'],
      stop_time: attraction['stop_time'],
      all_day: attraction['all_day'],
      venue_name: attraction['venue_name'],
      venue_address: attraction['venue_address'],
      venue_url: attraction['venue_url']
    )
  end
end

all_events.each do |event|
  create_attractions(event)
end

#
# CAPTURE KEYWORDS FROM EVENTS
#

all_attractions = Attraction.all
interest_keywords = []

all_attractions.each do |attraction|
  city = attraction['city_name'] || ''
  title = attraction['title'] || ''
  venue = attraction['venue_name'] || ''
  desc = attraction['description'] || ''
  attraction_words_string = city << ' ' << title << ' ' << venue << ' ' << desc
  interest_keywords += attraction_words_string.downcase.gsub!(/[^0-9A-Za-z]/, ' ').split(' ')
end

filtered_interest_keywords = interest_keywords.select { |word| !Stopwords.stopwords.include? word }
unique_interest_keywords = filtered_interest_keywords.uniq
interest_keywords_count_hash = Hash.new 0
filtered_interest_keywords.each do |word|
  interest_keywords_count_hash[word] += 1
end

p interest_keywords_count_hash
p unique_interest_keywords.length
p filtered_interest_keywords.length
p interest_keywords.length
