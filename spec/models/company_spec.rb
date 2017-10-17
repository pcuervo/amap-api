require 'rails_helper'

RSpec.describe Company, :type => :model do
  before { @company = FactoryGirl.build(:company) }
  subject { @company }

  it { should respond_to(:name) }

  it { should be_valid }

  describe "#unify" do
    it "unifies two companies together" do
      user = FactoryGirl.create :user
      correct_company = FactoryGirl.create :company
      incorrect_company = FactoryGirl.create :company
      incorrect_company.users << user
      3.times.each do |i|
        b = FactoryGirl.create :brand
        incorrect_company.brands << b
      end
      incorrect_company.save
    
      correct_company.unify( incorrect_company )
      expect( correct_company.brands.count ).to eql 3
      unexisting_company = Company.find_by_id( incorrect_company.id )
      expect( unexisting_company.present? ).to eq false
      expect( correct_company.users.count ).to eq 1
    end
  end
end
