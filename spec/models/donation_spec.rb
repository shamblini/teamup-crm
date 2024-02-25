require 'rails_helper'

RSpec.describe Donation, type: :model do
  context 'when creating a new donation Sunny Day' do
    it 'creates a donation in the database' do
      donation = Donation.create(
        amount: 1000,
        date: '2021-04-01',
        user_id: 1
      )

      # Check if the donation object is persisted in the database
      expect(donation).to be_persisted

      expect(donation.amount).to eq(1000)
      expect(donation.date).to eq('2021-04-01')
      expect(donation.user_id).to eq(1)
    end
  end
end

RSpec.describe Donation, type: :model do
  context 'when creating a new donation Rainy Day' do
    it 'does not create a donation in the database' do
      donation = Donation.create(
        amount: 1000,
      )

      # Check if the donation object is not persisted in the database
      expect(donation).not_to be_persisted
    end
  end
end