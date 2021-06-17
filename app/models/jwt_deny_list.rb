# frozen_string_literal: true

class JwtDenyList < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist

  self.table_name = 'jwt_deny_list'
end
