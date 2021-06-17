# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'user.test@gmail.com' }
    password { '123456' }
  end
end
