Factory.sequence(:user_email) do |n|
  "test.user#{n}@localhost"
end
Factory.define(:user) do |u|
  u.email { Factory.next(:user_email) }
  u.password "password"
  u.password_confirmation "password"
end
