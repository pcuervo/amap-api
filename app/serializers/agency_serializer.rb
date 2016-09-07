class AgencySerializer < ActiveModel::Serializer
  attributes :id, :name, :phone, :contact_name, :contact_email, :address, :latitude, :longitude, :website_url, :num_employees, :golden_pitch, :silver_pitch, :high_risk_pitch, :medium_risk_pitch, :logo, :success_cases, :skills

  def success_cases
    success_cases = []
    object.success_cases.each do |sc|
      success_case = {}
      success_case[:id]                 = sc.id
      success_case[:name]               = sc.name
      success_case[:description]        = sc.description
      success_case[:url]                = sc.url
      success_case[:case_image]         = sc.case_image
      success_case[:case_image_thumb]   = sc.case_image(:thumb)
      success_cases.push( success_case )
    end
    success_cases
  end

  def skills
    skills = []
    object.agency_skills.each do |as|
      skill = Skill.find(as.skill_id)
      skill_obj = {}
      skill_obj[:id]    = skill.id
      skill_obj[:name]  = skill.name
      skill_obj[:level] = as.level
      skills.push( skill_obj )
    end
    skills
  end
end

