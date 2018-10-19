# frozen_string_literal: true

Fabricator(:user) do
  email { sequence(:email) { |i| "user_#{i}@dev_app.com" } }
  password 'my-secure_pass'
end
