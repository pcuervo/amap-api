class CompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :brands, :contact_name, :contact_email, :contact_position, :logo, :favorite_agencies, :users, :pitches

  def favorite_agencies
    favs = []
    object.agencies.each do |fav|
      favs.push({:id => fav.id, :name => fav.name})
    end
    favs
  end

  def pitches
    pitches = []
    object.brands.each do |brand|
      brand.pitches.each do |pitch|
        pitches.push({
          :id             => pitch.id,
          :name           => pitch.name,
          :brand          => brand,
          :brief_date     => pitch.brief_date,
          :email_contact  => pitch.brief_email_contact
        })
      end
    end
    pitches
  end

  def users
    users = []
    object.users.each do |u|
      users.push({:email => u.email})
    end
    users
  end
end
