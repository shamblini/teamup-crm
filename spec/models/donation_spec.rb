# spec/models/donation_spec.rb

require 'rails_helper'

RSpec.describe Donation, type: :model do
  let(:donation) do
    Donation.create(
      donor_name: 'Test Donor',
      amount: 1000,
      donation_date: '2021-04-01',
      campaign_id: 1
    )
  end

  context 'Sunny Day' do
    it 'creates a donation in the database when created with correct attributes' do
      expect(donation).to be_persisted
    end

    it 'edits a donation in the database when edited with correct attributes' do
      donation.update(amount: 2000)

      expect(donation.reload.amount).to eq(2000)
    end

    context 'Rainy Day' do
      it 'does not create a donation in the database when created with wrong attributes' do
        donationBad = Donation.create(
          donor_name: nil,
          amount: 1000,
          donation_date: '2021-04-01',
          campaign_id: 1
        )

        expect(donationBad).not_to be_persisted
      end

      it 'does not edit a donation in the database when edited with wrong attributes' do
        donation.update(amount: nil)

        expect(donation.reload.amount).not_to be_nil
      end
    end
  end
end
