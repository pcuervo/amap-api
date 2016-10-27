class PitchWinnerSurveySerializer < ActiveModel::Serializer
  attributes :id, :was_contract_signed, :contract_signature_date, :was_project_activated, :when_will_it_activate, :pitch, :agency
end
