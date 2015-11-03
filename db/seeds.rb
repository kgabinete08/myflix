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
              category: comedy)

futurama = Video.create!(title: 'Futurama',
                         description: 'Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation.',
                         category: comedy)

Video.create!(title: 'South Park',
              description: 'Follow the misadventures of four crazy grade-schoolers in the dysfunctional town of South Park, Colorado.',
              category: comedy)

Video.create!(title: 'Family Guy',
              description: 'Brian makes Stewie watch viral video.',
              category: comedy)

Video.create!(title: 'Futurama',
              description: 'Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation.',
              category: comedy)

Video.create!(title: 'South Park',
              description: 'Follow the misadventures of four crazy grade-schoolers in the dysfunctional town of South Park, Colorado.',
              category: comedy)

Video.create!(title: 'Family Guy',
              description: 'Brian makes Stewie watch viral video.',
              category: comedy)

Video.create!(title: 'Monk',
              description: "Brilliant but emotionally hampered former San Francisco police detective Adrian Monk works as a consultant on the SFPD's toughest cases.",
              category: drama)

Video.create!(title: 'Monk',
              description: "Brilliant but emotionally hampered former San Francisco police detective Adrian Monk works as a consultant on the SFPD's toughest cases.",
              category: drama)

tester = User.create!(email: "tester@abc.com", password: "password", full_name: "Tester Account")

Review.create!(user: tester, video: futurama, rating: 3, content: "This is a mediocre show.")
Review.create!(user: tester, video: futurama, rating: 5, content: "This is a cool show!")
