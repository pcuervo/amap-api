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
      elsif pe.pitch_type == 'unhappy'
        pitch_types['unhappy'] += 1
      end
    end

    pitch_types['happitch'] = pitch_types['happitch'].to_f / self.pitch_evaluations.count * 100
    pitch_types['happy'] = pitch_types['happy'].to_f / self.pitch_evaluations.count * 100
    pitch_types['ok'] = pitch_types['ok'].to_f / self.pitch_evaluations.count * 100
    pitch_types['unhappy'] = pitch_types['unhappy'].to_f / self.pitch_evaluations.count * 100

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

  def objectives_not_clear_percentage 
    pe = PitchEvaluation.where('pitch_id = ?', self.id)
    return 0 if ! pe.present?

    with_clear_objectives = pe.where('are_objectives_clear = ?', false).count
    return with_clear_objectives.to_f / pe.count * 100
  end

  def is_budget_known_percentage 
    pe = PitchEvaluation.where('pitch_id = ?', self.id)
    return 0 if ! pe.present?

    known_budget = pe.where('is_budget_known = ?', true).count
    return known_budget.to_f / pe.count * 100
  end

  def are_deliverables_clear_percentage 
    pe = PitchEvaluation.where('pitch_id = ?', self.id)
    return 0 if ! pe.present?

    clear_deliverables = pe.where('are_deliverables_clear = ?', true).count
    return clear_deliverables.to_f / pe.count * 100
  end

  def will_deliver_copyright_for_pitching? 
    return PitchEvaluation.where('pitch_id = ? AND deliver_copyright_for_pitching = ?', self.id, true).present?
  end

  def time_to_present_avg 
    pe = PitchEvaluation.where('pitch_id = ?', self.id)
    return 0 if ! pe.present?

    return pe.average('time_to_present::integer').ceil
  end

  def has_selection_criteria? 
    return PitchEvaluation.where('pitch_id = ? AND has_selection_criteria = ?', self.id, true).present?
  end

  def five_to_seven_agencies? 
    return PitchEvaluation.where('pitch_id = ? AND number_of_agencies = ?', self.id, '5 - 7').present?
  end

  def more_than_seven_agencies? 
    return PitchEvaluation.where('pitch_id = ? AND number_of_agencies = ?', self.id, '7+').present?
  end
  
  def self.pitches_by_month
    pitches_by_month = Pitch.select("to_char(created_at, 'YYYY-MM') as month_year, count(*) as num_pitches").limit(30).group('month_year').order("to_char(created_at, 'YYYY-MM') DESC")
    pitches_by_month
  end
end
