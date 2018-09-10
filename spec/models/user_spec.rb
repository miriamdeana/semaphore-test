require "rails_helper"

RSpec.describe User do

  before(:each) do
    @user = build(:user)
  end

  describe "validations" do
    it "is valid with valid attributes" do
      expect(@user).to be_valid
    end

    it "is invalid if email doesn't end in @callrail.com" do
      @user = User.new(first_name: "Melissa", last_name: "Kerns", email: "melissa@gmail.com", password: "abcd1234")
      expect(@user).to be_invalid
    end

    it "should have a unique email address" do
      @user.save
      @user2 = User.new(first_name: "Melissa", last_name: "Kerns", email: @user.email, password: "1234abcd")
      expect(@user2).to be_invalid
    end
  end
end