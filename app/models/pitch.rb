class Pitch < ApplicationRecord
  belongs_to :brand
  has_many :pitch_evaluations
  has_and_belongs_to_many :skill_categories, :through => :pitches_skill_categories
  has_and_belongs_to_many :users

  validates :name, presence: true

  def get_scores_except pitch_evaluation_id
    scores = []
    self.pitch_evaluations.each do |pe|
      next if pe.id == pitch_evaluation_id
      scores.push( pe.score )
    end
    scores
  end
  
end
