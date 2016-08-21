User.create!(
  name: "Nguyen Duy Khanh",
  email: "khanhit93@gmail.com",
  telephone: "1234567890",
  password: "khanhnd",
  password_confirmation: "khanhnd",
  activation: true,
  active_at: Time.zone.now,
  is_admin: true)

User.create!(
  name: "test",
  email: "test@gmail.com",
  telephone: "11234567890",
  password: "khanhnd",
  password_confirmation: "khanhnd",
  activation: true,
  active_at: Time.zone.now,
  is_admin: false)

30.times do |n|
  name  = Faker::Name.name
  email = "example#{n+1}@railstutorial.org"
  password = "password"
  telephone = "016597128#{n}"
  User.create!(
    name:  name,
    email: email,
    telephone: telephone,
    password: password,
    password_confirmation: password,
    activation: true,
    active_at: Time.zone.now)
end

users = User.all
user  = users.first
following = users[2..10]
followers = users[3..10]
following.each {|followed| user.follow followed}
followers.each {|follower| follower.follow user}
