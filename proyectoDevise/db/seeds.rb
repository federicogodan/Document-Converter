# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Load the associations for the formats compatibilities
f1 = Format.new(name:"TXT")
f2 = Format.new(name:"ODT")
f3 = Format.new(name:"PDF")
f4 = Format.new(name:"JPG")

f2.save
f3.save
f4.save

f1.destinies.push(f2)
f1.destinies.push(f3)
f1.destinies.push(f4)

f1.save

