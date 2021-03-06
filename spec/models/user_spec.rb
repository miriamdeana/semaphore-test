require 'rails_helper'

RSpec.describe User do

  let(:user) { build(:user) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is invalid if email doesn\'t end in @callrail.com' do
      user = build(:user, email: "melissa@gmail.com")
      expect(user).to be_invalid
    end

    it 'should have a unique email address' do
      user.save
      user2 = build(:user, email: user.email)
      expect(user2).to be_invalid
    end

    it 'should accept a 12 digit submitter_id' do
      user.update_attributes!(submitter_id: 123456789012)
      expect(user).to be_valid
    end

    it 'should have a unique submitter_id' do
      user.update_attributes!(submitter_id: 123456789)
      user2 = build(:user, email: 'user2@callrail.com', submitter_id: user.submitter_id)
      expect(user2).to be_invalid
    end
  end
end