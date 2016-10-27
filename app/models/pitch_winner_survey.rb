class PitchWinnerSurvey < ApplicationRecord
  belongs_to :agency
  belongs_to :pitch

  validates :contract_signature_date, :when_will_it_activate, presence: true
end

