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
require_relative 'modules/stopwords'

# p 'env:', ENV['EVENTFUL_KEY']
p 'getting seed data'

eventful = Eventful::API.new ENV['EVENTFUL_KEY']

cities = ['Chicago', 'Boston', 'New York', 'San Francisco', 'Los Angeles',
          'Las Vegas', 'Austin', 'Seattle', 'Denver', 'Nashville']

cities.each { |city| City.create(name: city) }

def create_attraction(attraction)
  attraction_params = {
    eventful_id: attraction['id'] || '',
    city_name: attraction['city_name'] || '',
    country_name: attraction['country_name'] || '',
    title: attraction['title'] || '',
    description: attraction['description'] || '',
    owner: attraction['owner'] || '',
    db_start_time: attraction['start_time'] || '',
    db_stop_time: attraction['stop_time'] || '',
    event_date: attraction['start_time'].to_date || '',
    event_time: attraction['start_time'].to_s.slice(11, 8) || '',
    event_time_zone: attraction['start_time'].to_s.slice(-5, 5) || '',
    all_day: attraction['all_day'] || '',
    venue_id: attraction['venue_id'] || '',
    venue_name: attraction['venue_name'] || '',
    venue_address: attraction['venue_address'] || '',
    postal_code: attraction['postal_code'] || '',
    venue_url: attraction['venue_url'] || '',
    geocode_type: attraction['geocode_type'] || '',
    latitude: attraction['latitude'] || '',
    longitude: attraction['longitude'] || '',
    image_information: attraction['image'] || ''
  }

  if attraction['image'] &&
     attraction['image']['medium'] &&
     attraction['image']['medium']['url']
    image_url = attraction['image']['medium']['url']
    attraction_params['medium_image_url'] = image_url
  end

  Attraction.create attraction_params

  p 'API call and save success'
end

max = 15
cities.each do |city|
  # args documentation:
  # http://api.eventful.com/docs/events/search
  # .gsub(/\u2028/, '')

  i = 0
  page_size = 10
  page_number = 1

  while i < max

    begin

      city_args = {
        date: 'Future',
        where: city,
        page_size: page_size,
        page_number: page_number
      }

      city_events = eventful.call 'events/search', city_args

      city_events['events']['event'].each do |event|
        create_attraction(event) unless Attraction.find_by eventful_id: event['id']
      end

      i += 1
    rescue StandardError => exception
      p exception
    else
      p 'no exception'
    ensure
      p "#{city} API call #{i} complete"
    end

  end
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

p unique_interest_keywords.length
p filtered_interest_keywords.length
p interest_keywords.length

#
# Save tags
#

def create_tag(keyword_hash, avg_usage)
  keyword_hash.keys.each do |key|
    Tag.create(
      tag: key,
      usages: keyword_hash[key],
      relative_usage: ((100 * keyword_hash[key]) / avg_usage).floor
    )
  end
end

average_usage = interest_keywords_count_hash.values.inject(0, :+) /
                interest_keywords_count_hash.values.length.to_f
p 'average_usage:'
p average_usage

create_tag(interest_keywords_count_hash, average_usage)

#
# Create Join Table between events and tags
#

all_attractions.each do |attraction|
  city = attraction['city_name'] || ''
  title = attraction['title'] || ''
  venue = attraction['venue_name'] || ''
  desc = attraction['description'] || ''
  attraction_words_string = city << ' ' << title << ' ' << venue << ' ' << desc
  attraction_words_array = attraction_words_string.downcase.gsub!(/[^0-9A-Za-z]/, ' ').split(' ')
  filtered_attraction_words_array = attraction_words_array.select { |word| !Stopwords.stopwords.include? word }
  unique_filtered_attraction_words_array = filtered_attraction_words_array.uniq
  unique_filtered_attraction_words_array.each do |tag_word|
    AttractionTag.create(
      tag: Tag.find_by(tag: tag_word),
      attraction: Attraction.find_by(title: attraction[:title])
    )
  end
end

# save data to seed_data csv after deleting the old one
# https://www.postgresql.org/docs/9.1/static/backup-dump.html
File.delete('seed_data.csv') if File.exist?('seed_data.csv')
system('pg_dump togetherness_development > seed_data.csv')
begin
  system('dropdb togetherness_development')
end
begin
  system('createdb togetherness_development')
end
system('psql togetherness_development < seed_data.csv')
