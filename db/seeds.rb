User.create! name: "Example User", email: "example@railstutorial.org",
  password: "foobar", password_confirmation: "foobar", is_admin: true,
  activated: true, activated_at: Time.zone.now

Settings.user.seed_record.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create! name: name, email: email, password: password,
  password_confirmation: password, activated: true, activated_at: Time.zone.now
end

users = User.order(:created_at).take Settings.micropost.take_user
Settings.micropost.seed_record.times do
  content = Faker::Lorem.sentence Settings.micropost.sentence
  users.each{|user| user.microposts.create!(content: content)}
end
