# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db
# with db:setup).

# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'eventful/api'

p 'env:', ENV['EVENTFUL_KEY']
eventful = Eventful::API.new ENV['EVENTFUL_KEY']

o_args = { app_key: ENV['EVENTFUL_KEY'],
           q: 'music',
           where: 'New York',
           # date: '2013061000-2015062000',
           page_size: 5,
           sort_order: 'popularity' }

event = eventful.call 'events/search/',
                      o_args

p event
