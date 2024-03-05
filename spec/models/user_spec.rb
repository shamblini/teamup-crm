require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'creating a user' do
    context 'sunny day scenario' do
      it 'creates a user with valid attributes' do
        group = Group.create(name: 'Example Group', org_type: 'SomeOrgType') # Create a group
        user = User.create!(name: 'John Doe', email: 'john@example.com', group_id: group.id)
        expect(user).to be_valid
      end
    end

    context 'rainy day scenario' do
      it 'fails to create a user with invalid attributes' do
        # Attempt to create a user with missing required attributes
        expect {
          User.create!(name: nil, email: 'john@example.com')
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
