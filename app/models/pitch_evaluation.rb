class PitchEvaluation < ApplicationRecord
  belongs_to :pitch
  belongs_to :user

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
    when ">4" 
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

  def self.pitches_by_user( user_id )
    
    user = User.find( user_id )
    if User::AGENCY_ADMIN == user.role || User::AGENCY_USER == user.role
      return pitch_evaluations = self.pitch_evaluations_by_agency_user( user )
    else
      return pitch_evaluations = self.pitch_evaluations_by_client_user( user )
    end
  end

  def self.pitch_evaluations_by_agency_user( user )
    pitches_info = []
    if User::AGENCY_ADMIN == user.role
      agency = user.agencies.first
      agency_users = agency.users
      pitch_evaluations = PitchEvaluation.where('user_id IN (?)', agency_users.pluck(:id))
    else
      pitch_evaluations = PitchEvaluation.where('user_id = ?', user.id)
    end
    pitch_evaluations.each do |pe|
      info = {}
      brand = Brand.find( pe.pitch.brand_id )
      info[:pitch_evaluation_id]  = pe.id 
      info[:pitch_id]             = pe.pitch.id
      info[:pitch_name]           = pe.pitch.name
      info[:brief_date]           = pe.pitch.brief_date.strftime( "%d/%m/%Y" )
      info[:score]                = pe.score
      info[:brand]                = brand.name
      info[:company]              = brand.company.name
      info[:other_scores]         = pe.pitch.get_scores_except( pe.id )
      info[:evaluation_status]    = pe.evaluation_status
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

end
