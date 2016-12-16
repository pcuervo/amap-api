class Pitch < ApplicationRecord
  belongs_to :brand
  has_many :pitch_evaluations
  has_one :pitch_winner_survey
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
    pitch_types['unhappy'] = 0

    self.pitch_evaluations.each do |pe|
      if pe.pitch_type == 'happitch'
        pitch_types['happitch'] += 1
      elsif pe.pitch_type == 'happy'
        pitch_types['happy'] += 1
      elsif pe.pitch_type == 'ok'
        pitch_types['ok'] += 1
      else
        pitch_types['unhappy'] += 1
      end
    end

    pitch_types['happitch'] = pitch_types['happitch'] / self.pitch_evaluations.count * 100
    pitch_types['happy'] = pitch_types['happy'] / self.pitch_evaluations.count * 100
    pitch_types['ok'] = pitch_types['ok'] / self.pitch_evaluations.count * 100
    pitch_types['unhappy'] = pitch_types['unhappy'] / self.pitch_evaluations.count * 100

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
    return 0 if ! self.pitch_winner_survey.present?

    return self.pitch_winner_survey.agency.name
  end

  def get_evaluation_breakdown

    breakdown = {}
    breakdown['objectives_clear'] = 0
    breakdown['budget_known'] = 0
    breakdown['selection_criteria'] = 0
    breakdown['deliverables_clear'] = 0
    breakdown['marketing_involved'] = 0

    return breakdown if self.pitch_evaluations.count == 0

    total_evaluations = 0
    self.pitch_evaluations.each do |pe|
      breakdown['objectives_clear'] += pe.are_objectives_clear ? 1 : 0

      breakdown['budget_known'] += pe.is_budget_known ? 1 : 0
      breakdown['selection_criteria'] += pe.has_selection_criteria ? 1 : 0
      breakdown['deliverables_clear'] += pe.are_deliverables_clear ? 1 : 0
      breakdown['marketing_involved'] += pe.is_marketing_involved == 'si' ? 1 : 0
      total_evaluations += 1
    end

    breakdown['objectives_clear'] = breakdown['objectives_clear'].to_f / total_evaluations * 100
    breakdown['budget_known'] = breakdown['budget_known'].to_f / total_evaluations * 100
    breakdown['selection_criteria'] = breakdown['selection_criteria'].to_f / total_evaluations * 100
    breakdown['deliverables_clear'] = breakdown['deliverables_clear'].to_f / total_evaluations * 100
    breakdown['marketing_involved'] = breakdown['marketing_involved'].to_f / total_evaluations * 100

    return breakdown
  end
  
end
