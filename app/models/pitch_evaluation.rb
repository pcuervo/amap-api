class PitchEvaluation < ApplicationRecord
  belongs_to :pitch

  def calculate_score
    self.score += 15 if self.are_objectives_clear
    self.score += 8 if self.is_budget_known
    self.score += 15 if self.has_selection_criteria
    self.score += 6 if self.are_objectives_clear

    case self.deliver_copyright_for_pitching
    when "si"
      self.score += 5
    when "no" 
      self.score += 0
    else
      self.score += 0
    end

    case self.is_marketing_involved
    when "si"
      self.score += 6
    when "no" 
      self.score += 0
    else
      self.score += 0
    end

    case self.number_of_agencies
    when "2 - 4"
      self.score += 7
    when ">4" 
      self.score += 3
    end

    case self.time_to_present
    when "1s"
      self.score += 2
    when "2s"
      self.score += 5
    when "3s"
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
    when ">6"
      self.score += 2
    end

    self.save
  end

end
