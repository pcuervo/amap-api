class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :role, :is_member_amap, :auth_token, :agency_id, :company_id, :agency_company

  def agency_id
    return -1 if object.agencies.empty?
    object.agencies.first.id
  end

  def company_id
    return -1 if object.companies.empty?
    object.companies.first.id
  end

  def agency_company
    return '-' if object.agencies.empty? && object.companies.empty?

    if object.agencies.present? 
      agency = Agency.find( object.agencies.first.id )
      return agency.name
    end

    company = Company.find( object.companies.first.id )
    return company.name
  end
end
