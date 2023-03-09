# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Hit.destroy_all
User.destroy_all

50.times do |index|
  User.create!(username: Faker::Internet.unique.username, password: "testing123")
end

p "Created #{User.count} users"

user_range = Random.new
1000000.times do |index|
    Hit.create!(user_id:user_range.rand(User.first.id..User.first.id + 2), endpoint:Faker::Internet.unique.url)
  end


p "Created #{Hit.count} hits"