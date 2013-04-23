# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Link.destroy_all
Node.destroy_all

nodes = Node.create([{id: 19156507}, {id: 813286}])
links = Link.create([{source_id: 19156507, target_id: 813286},
					{source_id: 19156507, target_id: 354890673},
					{source_id: 813286, target_id: 19156507},
					{source_id: 354890673, target_id: 21155592}])