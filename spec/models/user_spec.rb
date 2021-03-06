require 'rails_helper'

RSpec.describe User, :type => :model do
  before { @user = FactoryGirl.build(:user) }

  subject { @user }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:role) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to( :auth_token ) }

  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
  it { should allow_value('example@domain.com').for(:email) }
  it { should validate_confirmation_of(:password) }
  it { should validate_length_of( :password ).is_at_least(6) }

  it { should validate_inclusion_of(:role).in_array([1, 2, 3, 4, 5]) }

  it { should validate_uniqueness_of( :auth_token )}

  it { should have_and_belong_to_many(:agencies) }

  it { should be_valid }


  describe "#generate_authentication_token!" do
    it "generates a unique token" do
      allow(Devise).to receive(:friendly_token).and_return("auniquetoken123")
      @user.generate_authentication_token!
      expect(@user.auth_token).to eql "auniquetoken123"
    end

    it "generates another token when one already has been taken" do
      existing_user = FactoryGirl.create( :user, auth_token: "auniquetoken123" )
      @user.generate_authentication_token!
      expect( @user.auth_token ).not_to eql existing_user.auth_token
    end
  end

  describe "#send_password_reset" do
    it "saves a new password reset token" do
      @user.send_password_reset
      expect(@user.reset_password_token).not_to be_empty
    end
  end
end