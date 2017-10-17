require 'rails_helper'

RSpec.describe Brand, :type => :model do
  before { @brand = FactoryGirl.build(:brand) }
  subject { @brand }

  it { should respond_to(:name) }

  it { should belong_to(:company) }

  it { should be_valid }

  describe "#unify" do
    it "unifies two brands together and assigns pitches to correct brand" do
      correct_brand = FactoryGirl.create :brand
      incorrect_brand = FactoryGirl.create :brand
      3.times.each do |i|
        p = FactoryGirl.create :pitch
        incorrect_brand.pitches << p
      end
      incorrect_brand.save
    
      correct_brand.unify( incorrect_brand )
      expect( correct_brand.pitches.count ).to eql 3
      expect{ Brand.find( incorrect_brand.id ) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
