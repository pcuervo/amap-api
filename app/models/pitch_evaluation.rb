class PitchEvaluation < ApplicationRecord
  belongs_to :pitch
  belongs_to :user

  ACTIVE = 1
  CANCELLED = 2
  DECLINED = 3
  ARCHIVED = 4
  WON = 5

  def calculate_score
    self.score = 0
    self.score += 15 if self.are_objectives_clear
    self.score += 8 if self.is_budget_known
    self.score += 15 if self.has_selection_criteria
    self.score += 6 if self.are_deliverables_clear

    case self.deliver_copyright_for_pitching
    when "si"
      self.score -= 2
    when "no" 
      self.score += 0
    else
      self.score += 5
    end

    case self.is_marketing_involved
    when "si"
      self.score += 6
    when "no" 
      self.score += 0
    else
      self.score += -2
    end

    case self.number_of_agencies
    when "2 - 4"
      self.score += 7
    when "5 - 7"
      self.score += 3
    when "+ de 7" 
      self.score += -3
    end

    days_to_present = self.time_to_present.to_i
    if days_to_present <= 5 
      self.score += 2
    elsif days_to_present > 5 && days_to_present <= 10
      self.score += 5
    elsif days_to_present > 10 && days_to_present <= 15
      self.score += 10
    else
      self.score += 15
    end

    case self.number_of_rounds
    when "1r"
      self.score += 4
    when "2r"
      self.score += 3
    when "3r"
      self.score += 2
    else
      self.score += 1
    end

    case self.time_to_know_decision
    when "2s"
      self.score += 6
    when "3s"
      self.score += 5
    when "4s"
      self.score += 4
    when "5s"
      self.score += 3
    when ">5"
      self.score += 2
    end

    self.save
  end

  def self.pitches_by_user( user_id, status='' )
    
    user = User.find( user_id )
    if User::AGENCY_ADMIN == user.role || User::AGENCY_USER == user.role
      return pitch_evaluations = self.pitch_evaluations_by_agency_user( user, status )
    else
      return pitch_evaluations = self.pitch_evaluations_by_client_user( user )
    end
  end

  def self.pitch_evaluations_by_agency_user( user, status='' )
    pitches_info = []
    agency = user.agencies.first
    if User::AGENCY_ADMIN == user.role
      agency_users = agency.users
      pitch_evaluations = PitchEvaluation.where( 'user_id IN (?)', agency_users.pluck(:id),  )
    else
      pitch_evaluations = PitchEvaluation.where( 'user_id = ? ', user.id )
    end

    if '' != status
      pitch_evaluations = pitch_evaluations.where( 'pitch_status = ?', PitchEvaluation::ACTIVE )
    end

    pitch_evaluations.each do |pe|
      pitch_winner_survey = PitchWinnerSurvey.where( 'agency_id = ? AND pitch_id = ?', agency.id, pe.pitch.id )
      pitch_results = PitchResult.where( 'agency_id = ? AND pitch_id = ?', agency.id, pe.pitch.id )
      info = {}
      brand = Brand.find( pe.pitch.brand_id )
      info[:pitch_evaluation_id]      = pe.id 
      info[:pitch_id]                 = pe.pitch.id
      info[:pitch_name]               = pe.pitch.name
      info[:brief_date]               = pe.pitch.brief_date.strftime( "%d/%m/%Y" )
      info[:score]                    = pe.score
      info[:brand]                    = brand.name
      info[:company]                  = brand.company.name
      info[:other_scores]             = pe.pitch.get_scores_except( pe.id )
      info[:evaluation_status]        = pe.evaluation_status
      info[:skill_categories]         = pe.pitch.skill_categories
      info[:was_won]                  = pe.was_won
      info[:pitch_status]             = pe.pitch_status
      info[:has_results]              = pitch_results.present?
      info[:has_pitch_winner_survey]  = pitch_winner_survey.present?
      pitches_info.push( info )
    end
    pitches_info
  end

  def self.pitch_evaluations_by_client_user( user )
    pitches_info = []
    if User::CLIENT_ADMIN == user.role
      company = user.companies.first
      pitches = Pitch.where('brand_id IN (?)', company.brands.pluck(:id))
    else
      pitches = user.pitches
    end
    pitches.each do |p|
      info = {}
      brand = Brand.find( p.brand_id )
      info[:pitch_id]             = p.id
      info[:pitch_name]           = p.name
      info[:brief_date]           = p.brief_date.strftime( "%d/%m/%Y" )
      info[:brand]                = brand.name
      info[:brief_email_contact]  = p.brief_email_contact
      info[:company]              = brand.company.name
      info[:pitch_types]          = p.get_pitch_types
      pitches_info.push( info )
    end
    pitches_info
  end

  def get_pitch_type( score )
    return 'Golden Pitch'
  end

  def self.filter user_id, params
    pitch_evaluations_arr = PitchEvaluation.pitches_by_user( user_id )
    pitch_evaluation_ids = []
    pitch_status_filter = []
    score_filter = []

    pitch_evaluations_arr.each { |pe| pitch_evaluation_ids.push(pe[:pitch_evaluation_id]) }
    pitch_evaluations = PitchEvaluation.where( 'id IN (?)', pitch_evaluation_ids )

    if params[:archived]
      pitch_status_filter.push( ARCHIVED )
    end

    if params[:declined]
      pitch_status_filter.push( DECLINED )
    end

    if params[:cancelled]
      pitch_status_filter.push( CANCELLED )
    end

    if params[:happitch]
      score_filter
    end

    if ! pitch_status_filter.empty?
      pitch_evaluations = pitch_evaluations.where( 'pitch_status IN (?)', pitch_status_filter )
    end

#     70 ---- happitch
# >= 59 && <= 69 ---- silver
# >= 45 && <= 58 ---- medium risk
# <= 44 ---- high risk

    pitch_evaluations
  end

  def self.search user_id, keyword
    pitch_evaluations_arr = PitchEvaluation.pitches_by_user( user_id, PitchEvaluation::ACTIVE )
    pitch_evaluation_ids = []
    pitch_status_filter = []
    score_filter = []

    pitch_evaluations_arr.each { |pe| pitch_evaluation_ids.push(pe[:pitch_evaluation_id]) }
    pitch_evaluations = PitchEvaluation.where( 'id IN (?)', pitch_evaluation_ids )

  end

  # Scopes

  scope :inventory_by_type, -> ( project_ids = nil  ){
    if( project_ids != nil )
      where( 'project_id IN (?)', project_ids ).group(:item_type).count
    else
      group(:item_type).count
    end
  }

  scope :average_per_month_by_user, -> ( user_id  ) { 
    find_by_sql("SELECT ROUND(AVG(score)) AS score, to_char(created_at, 'MM-YY') as month_year
       FROM pitch_evaluations
       WHERE user_id = " + user_id.to_s + "
       GROUP BY (month_year)
       ORDER BY to_char(created_at, 'MM-YY') 
       LIMIT 12")
  }

  scope :average_per_month_by_agency, -> ( user_ids  ) { 
    find_by_sql("SELECT ROUND(AVG(score)) AS score, to_char(created_at, 'MM-YY') as month_year
       FROM pitch_evaluations
       WHERE user_id IN ( " + user_ids + ")
       GROUP BY (month_year)
       ORDER BY to_char(created_at, 'MM-YY') 
       LIMIT 12")
  }

  scope :average_per_month_industry, -> { 
    find_by_sql("SELECT ROUND(AVG(score)) AS score, to_char(created_at, 'MM-YY') as month_year
       FROM pitch_evaluations
       GROUP BY (month_year)
       ORDER BY to_char(created_at, 'MM-YY') 
       LIMIT 12")
  }

end
