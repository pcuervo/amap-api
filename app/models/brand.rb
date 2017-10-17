class Brand < ApplicationRecord
  belongs_to :company
  has_many :pitches, dependent: :delete_all

  validates :name, presence: true

  def unify( another_brand )
    another_brand.pitches.each do |pitch|
      self.pitches << pitch
    end
    self.save
    another_brand.destroy
  end
end
