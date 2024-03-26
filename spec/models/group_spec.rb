require 'rails_helper'

RSpec.describe Group, type: :model do
  let(:group) do
    Group.create(
      name: 'Texas A&M University',
      org_type: 'College/Univeristy'
    )
  end

  context 'Sunny Day' do
    it 'creates a group in the database when created with correct attributes' do
      expect(group).to be_persisted
    end

    it 'creates a group in the database and total donations is automatically 0' do
      expect(group.total_donations).to eq(0)
    end

    it 'edits a group in the database when edited with correct attributes' do
      group.update(org_type: 'Volunteer Group')

      expect(group.reload.org_type).to eq('Volunteer Group')
    end

    context 'Rainy Day' do
      it 'does not create a group in the database when created with wrong attributes' do
        groupBad = Group.create(
          name: nil,
          org_type: 'Company'
        )

        expect(groupBad).not_to be_persisted
      end

      it 'does not edit a group in the database when edited with wrong attributes' do
        group.update(org_type: nil)

        expect(group.reload.org_type).not_to be_nil
      end
    end
  end
end
