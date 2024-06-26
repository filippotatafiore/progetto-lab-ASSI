# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# --------------------------------------------------------------------------------------------Popola Users
# Crea altri utenti
users = 10.times.map do
  User.create!(
    email: Faker::Internet.unique.email,
    password: 'password',
    name: Faker::Name.name,
    provider: 'provider',
    uid: SecureRandom.uuid,
    sign_in_count: rand(1..10),
    current_sign_in_at: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now),
    last_sign_in_at: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now),
    current_sign_in_ip: Faker::Internet.ip_v4_address,
    last_sign_in_ip: Faker::Internet.ip_v4_address,
    profile_image: rand(1..10),
    nickname: Faker::Internet.username
    pro: false
  )
end

# --------------------------------------------------------------------------------------------Popola Friendships
# Crea l'utente corrente
current_user = User.find_by(email: 'simo.nole12@gmail.com')

# Prendi tutti gli utenti
users = User.all

# Prendi tre utenti casuali
random_user1 = users.sample
random_user2 = users.sample
random_user3 = users.sample

# Crea amicizie
Friendship.create!(user_id: random_user1.id, friend_id: current_user.id, status: 0) # pending by random_user1
Friendship.create!(user_id: current_user.id, friend_id: random_user2.id, status: 0) # pending by current_user to random_user2
Friendship.create!(user_id: current_user.id, friend_id: random_user3.id, status: 1) # accepted random_user3
Friendship.create!(user_id: random_user3.id, friend_id: current_user.id, status: 1) # accepted duplicated for database
#--------------------------------------------------------------------------------------------
