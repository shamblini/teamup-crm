require 'rails_helper'


RSpec.describe User, type: :model do
  context 'when creating a new user Sunny Day' do
    it 'creates a user in the database' do
      user = User.create(
        name: 'John Doe',
        email: 'john@example.com',
        user_type: 'volunteer',
        donations: nil,
        permission_set: 5,
        logs: nil
      )

      # Check if the user object is persisted in the database
      expect(user).to be_persisted

      expect(user.name).to eq('John Doe')
      expect(user.email).to eq('john@example.com')
      expect(user.user_type).to eq('volunteer')
      expect(user.donations).to be_nil
      expect(user.permission_set).to eq(5)
      expect(user.logs).to be_nil
    end
  end
end

RSpec.describe User, type: :model do
  context 'when creating a new user Rainy Day' do
    it 'creates a user in the database' do
      user = User.create(
        name: 'John Doe',
      )

      # Check if the user object is persisted in the database
      expect(user).to be_persisted

      expect(user.name).to eq('John Doe')
      expect(user.email).to be_nil
      expect(user.user_type).to be_nil
      expect(user.donations).to be_nil
      expect(user.permission_set).to eq(0)
      expect(user.logs).to be_nil
    end
  end
end

RSpec.describe('Creating a user with name, email, user_type, and permission_set Sunny Day', type: :feature) do
  it 'valid inputs' do
    visit new_user_path
    fill_in 'user[name]', with: 'Ozami'
    fill_in 'Email', with: 'Ozami@NoLongerHuman'
    fill_in 'User_type', with: 'volunteer'
    fill_in 'Permission_set', with: '10'
    click_on 'Create User'
    visit users_url
    expect(page).to(have_content('Ozami'))
    expect(page).to(have_content('Ozami@NoLongerHuman'))
    expect(page).to(have_content('volunteer'))
    expect(page).to(have_content('10'))
  end
end



