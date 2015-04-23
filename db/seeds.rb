# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Video.create(title: 'Family Guy', description: 'Brian makes Stewie watch viral video.', small_cover_url: '/tmp/family_guy.jpg')
Video.create(title: 'Futurama', description: 'Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation.', small_cover_url: '/tmp/futurama.jpg')