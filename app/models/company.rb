class Company < ApplicationRecord
  require 'csv'

  has_and_belongs_to_many :users
  has_many :brands, dependent: :delete_all
  has_and_belongs_to_many :agencies

  has_attached_file :logo, styles: { medium: "300x300>", thumb: "200x200#" }, default_url: "", :path => ":rails_root/storage/agency/:id/:style/:basename.:extension", :url => ":rails_root/storage/#{Rails.env}#{ENV['RAILS_TEST_NUMBER']}/attachments/:id/:style/:basename.:extension"
  
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/
  validates :name, presence: true

  def self.csv_upload_companies
    # if FileTest.exist?( Rails.root.to_s + '/retenidos_con_pedido_cantidad.csv' )
    #   File.delete( Rails.root.to_s + '/retenidos_con_pedido_cantidad.csv' )
    # end

    #data_csv = Base64.decode64(params[:csv]['data:text/csv;base64,'.length .. -1])
    #File.open("retenidos_con_pedido_cantidad.csv","wb") {|f| f.write(data_csv) }
    csv_content = CSV.read(Rails.root.to_s + '/companies.csv')

    errors = []
    added_items = 0
    csv_content.each_with_index do |row, i|
      next if i == 0

      company_name = row[0]
      brand_name = row[1]

      company = Company.find_by_name( company_name )
      if ! company.present?
        company = Company.create( :name => company_name )
      end

      brand = Brand.find_by_name( brand_name )
      if ! brand.present?
        brand = Brand.create( :name => brand_name, :company_id => company.id )
        added_items += 1 
      end
    end

    puts 'added_items: ' + added_items.to_s
    #WarehouseMailer.csv_locate( 'miguel@pcuervo.com', added_items, errors ).deliver_now
    return { added_items: added_items }
  end

  def unify( another_company )
    another_company.brands.each do |brand|
      self.brands << brand
    end
    another_company.users.each do |user|
      self.users << user
    end
    self.save!
    another_company.destroy
  end

end
