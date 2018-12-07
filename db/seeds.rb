# Uncomment this file to use it as regular seeds.rb file

# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db
# with db:setup).

#
# GET EVENT DATA FROM EVENTFUL
#

require 'eventful/api'
require_relative 'modules/stopwords'

p 'getting seed data...'

saved_attraction_count = 0
eventful = Eventful::API.new ENV['EVENTFUL_KEY']

cities = ['Chicago', 'Boston', 'New York', 'San Francisco', 'Los Angeles',
          'Las Vegas', 'Austin', 'Seattle', 'Denver', 'Nashville']

cities.each { |city| City.create(name: city) }

def add_categories(attraction)
  attraction['categories'].each do |category_list|
    category_list[1].each do |category|
      fixed_label = category['name'].gsub '&amp;', '&'
      new_category = { title: category['id'], label: fixed_label }
      next if Category.find_by title: new_category[:title]
      Category.create new_category
    end
  end
end

def add_attraction_categories(attraction_hash, attraction)
  attraction_hash['categories'].each do |category_list|
    category_list[1].each do |a_cat|
      cat = Category.find_by title: a_cat['id']
      next unless cat
      new_ac = { attraction_id: attraction[:id], category_id: cat[:id] }
      current_a_cats = AttractionCategory.where attraction_id: attraction[:id]
      dupe = false
      if current_a_cats
        current_a_cats.each do |current_a_cat|
          dupe = true if current_a_cat[:category_id] == cat[:id]
        end
      end
      AttractionCategory.create new_ac unless dupe
    end
  end
end

def define_img_url(attraction)
  if attraction['image'] &&
     attraction['image']['medium'] &&
     attraction['image']['medium']['url']
    return attraction['image']['medium']['url']
  else
    return ''
  end
end

def define_keyword_string(attraction)
  city = attraction['city_name'] || ''
  title = attraction['title'] || ''
  venue = attraction['venue_name'] || ''
  desc = attraction['description'] || ''
  attraction_string = city + ' ' + title + ' ' + venue + ' ' + desc
  norm_string = attraction_string.downcase.gsub!(/[^a-z]/, ' ')
  word_arr = norm_string.split(' ')
  filtered_array = word_arr.select { |word| !Stopwords.stopwords.include? word }
  final_string = ''
  filtered_array.uniq.each do |word|
    final_string = final_string + ' ' + word
  end
  final_string
end

def create_attraction(attraction, saved_attraction_count)
  attraction_params = {
    eventful_id: attraction['id'] || '',
    categories_string: attraction['categories'] || '',
    city_id: attraction['city_id'] || '',
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
    image_information: attraction['image'] || '',
    medium_image_url: define_img_url(attraction),
    keywords_string: define_keyword_string(attraction)
  }

  add_categories(attraction)
  Attraction.create attraction_params
  add_attraction_categories(attraction, Attraction.last)

  p 'API call and save success'
  if saved_attraction_count % 10 == 0
    p "Total Events Saved: #{saved_attraction_count}"
  end
end

# args documentation:
# http://api.eventful.com/docs/events/search
# .gsub(/\u2028/, '')

max = 100 # Run with 100 here
page_size = 1000 # Run with 1000 here
page_number = 5 # Run with 5 here

cities.each do |city|
  redundant_returns_count = 0
  i = 0

  while i < max

    redundant_returns = true

    begin

      city_args = {
        date: 'Future',
        where: city,
        page_size: page_size,
        page_number: page_number,
        include: 'categories, subcategories, popularity, tickets, price, links'
      }

      city_events = eventful.call 'events/search', city_args

      city_events['events']['event'].each do |event|
        city_id = City.find_by name: city
        event['city_id'] = city_id['id']
        next if Attraction.find_by eventful_id: event['id']
        create_attraction(event, saved_attraction_count)
        redundant_returns_count = 0
        redundant_returns = false
        saved_attraction_count += 1
      end

      i += 1
    rescue StandardError => exception
      p exception
    else
      p 'no exception'
    ensure
      p "#{city} API call #{i} complete"

      if redundant_returns
        redundant_returns_count += 1
        p "Requests with errors or no new results: #{redundant_returns_count}"
        i = max if redundant_returns_count > 5
      end
    end
  end
end

# save data to seed_data csv after deleting the old one
# https://www.postgresql.org/docs/9.1/static/backup-dump.html
File.delete('seed_data.dump') if File.exist?('seed_data.dump')
system('pg_dump -Fc togetherness_development > seed_data.dump')
