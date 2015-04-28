# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

comedy = Category.create!(name: 'Comedy')
drama = Category.create!(name: 'Drama')

Video.create!(title: 'Family Guy',
              description: 'Brian makes Stewie watch viral video.',
              small_cover_url: '/tmp/family_guy.jpg',
              category: comedy)

Video.create!(title: 'Futurama',
              description: 'Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation.',
              small_cover_url: '/tmp/futurama.jpg',
              category: comedy)

Video.create!(title: 'South Park',
              description: 'Follow the misadventures of four crazy grade-schoolers in the dysfunctional town of South Park, Colorado.',
              small_cover_url: '/tmp/south_park.jpg',
              category: comedy)

Video.create!(title: 'Monk',
              description: "Brilliant but emotionally hampered former San Francisco police detective Adrian Monk works as a consultant on the SFPD's toughest cases.",
              small_cover_url: '/tmp/monk.jpg',
              large_cover_url: '/tmp/monk_large.jpg',
              category: drama)
