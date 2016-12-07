class Pitch < ApplicationRecord
  belongs_to :brand
  has_many :pitch_evaluations
  has_and_belongs_to_many :skill_categories, :through => :pitches_skill_categories
  has_and_belongs_to_many :users

  validates :name, presence: true

  def get_scores_except pitch_evaluation_id
    scores = []
    self.pitch_evaluations.order(created_at: :desc).each do |pe|
      next if pe.id == pitch_evaluation_id
      scores.push( pe.score )
    end
    scores
  end

  def get_pitch_types
    pitch_types = {}
    pitch_types['happitch'] = 0
    pitch_types['happy'] = 0
    pitch_types['ok'] = 0
    pitch_types['sad'] = 0
    self.pitch_evaluations.each do |pe|
      if pe.pitch_type == 'happitch'
        pitch_types['happitch'] += 1
      elsif pe.pitch_type == 'happy'
        pitch_types['happy'] += 1
      elsif pe.pitch_type == 'ok'
        pitch_types['ok'] += 1
      else
        pitch_types['sad'] += 1
      end
    end

    pitch_types['happitch'] = pitch_types['happitch'] / self.pitch_evaluations.count * 100
    pitch_types['happy'] = pitch_types['happy'] / self.pitch_evaluations.count * 100
    pitch_types['ok'] = pitch_types['ok'] / self.pitch_evaluations.count * 100
    pitch_types['sad'] = pitch_types['sad'] / self.pitch_evaluations.count * 100

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

  def get_winner
    #return 0 if ! self.pitch_winner_survey.present?

    return self.pitch_winner_survey.agency.name
  end
  
end
