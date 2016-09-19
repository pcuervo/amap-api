class Criterium < ApplicationRecord
  has_and_belongs_to_many :agencies, :through => :agencies_criteria
end
