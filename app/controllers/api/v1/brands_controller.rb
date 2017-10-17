class Api::V1::BrandsController < ApplicationController
  before_action :set_brand, only: [:show, :update, :destroy, :unify]
  before_action only: [:create, :update] do 
    authenticate_with_token! params[:auth_token]
  end

  # GET /brands
  def index
    @brands = Brand.all.order("LOWER(name)")
    render json: { brands: @brands }, :include => { :company => { :only => [:name, :id] } }, except: [:updated_at, :company_id]
  end

  # GET /brands/1
  def show
    if ! @brand.present? 
      render json: { errors: 'No se encontró la marca con id: ' + params[:id] },status: :unprocessable_entity
      return
    end

    render json: @brand
  end

  # POST /brands
  def create
    @brand = Brand.new(brand_params)
    
    if @brand.save
      render json: @brand, status: :created
      return
    end

    render json: { errors: @brand.errors },status: :unprocessable_entity
  end

  # GET /brands/by_company
  def by_company
    @brands = Brand.where( 'company_id = ?', params[:id] )
    puts @brands.to_yaml
    if ! @brands.present? 
      render json: { errors: 'No se encontró la marca con id de compañía: ' + params[:id] },status: :unprocessable_entity
      return
    end

    render json: @brands
  end

  def unify
    incorrect_brand = Brand.find( params[:incorrect_brand_id] )
    @brand.unify( incorrect_brand )
    render json: @brand, status: 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_brand
      @brand = Brand.find_by_id(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def brand_params
      params.require(:brand).permit( :name, :contact_name, :contact_email, :contact_position, :company_id )
    end
end
