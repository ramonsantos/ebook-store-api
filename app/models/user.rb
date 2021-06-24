# frozen_string_literal: true

class User < ApplicationRecord
  devise(
    :database_authenticatable,
    :registerable,
    :validatable,
    :jwt_authenticatable,
    jwt_revocation_strategy: JwtDenyList
  )

  enum role: {
    admin:    'admin',
    customer: 'customer'
  }

  validates :role, presence: true
end
