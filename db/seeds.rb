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
all_events = []

cities.each do |city|
  # args documentation:
  # http://api.eventful.com/docs/events/search
  # .gsub(/\u2028/, '')
  city_args = {
    date: 'Future',
    where: city,
    page_size: 25,
    page_number: 1
  }
  city_events = eventful.call 'events/search',
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

p all_events.length
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
