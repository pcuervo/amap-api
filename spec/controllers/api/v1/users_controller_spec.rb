require 'rails_helper'

RSpec.describe Api::V1::UsersController, :type => :controller do
  # This should return the minimal set of attributes required to create a valid
  # Agency. As you add validations to Agency, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
    FactoryGirl.attributes_for :user
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:valid_session) { {} }

  describe "GET #show" do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, { id: @user.id }, format: :json
    end

    it "returns the information about a user on a hash" do
      expect(json_response[:email]).to eql @user.email
    end

    it { should respond_with 200 }
  end

end
