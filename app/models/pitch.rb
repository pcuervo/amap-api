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

  def get_pitch_types
    pitch_types = {}
    pitch_types['golden_pitch'] = 0
    pitch_types['silver_pitch'] = 0
    pitch_types['medium_risk_pitch'] = 0
    pitch_types['high_risk_pitch'] = 0
    self.pitch_evaluations.each do |pe|
      if pe.score > 70
        pitch_types['golden_pitch'] += 1
      elsif pe.score >= 60 && pe.score < 70
        pitch_types['silver_pitch'] += 1
      elsif pe.score >= 45 && pe.score < 60
        pitch_types['medium_risk_pitch'] += 1
      else
        pitch_types['high_risk_pitch'] += 1
      end
    end
    pitch_types
  end

  def merge bad_pitch
    bad_pitch.pitch_evaluations.each do |evaluation|
      self.pitch_evaluations << evaluation
    end
    self.save

    return true if bad_pitch.destroy

    return false
  end
  
end
