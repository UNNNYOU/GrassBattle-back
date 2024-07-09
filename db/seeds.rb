# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
#
initial_avatars = ['剣士（男）', '剣士（女）', '魔法使い（女）', '魔法使い（男）', '騎士']

initial_avatars.each do |avatar|
  Avatar.create(name: avatar)
end
