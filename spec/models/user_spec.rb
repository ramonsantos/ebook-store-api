# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }

    it do
      expect(subject).to define_enum_for(:role).with_values(
        admin:    'admin',
        customer: 'customer'
      ).backed_by_column_of_type(:string)
    end
  end
end
