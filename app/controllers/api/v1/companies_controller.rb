class Api::V1::CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :update, :destroy]
  before_action only: [:create, :update] do 
    authenticate_with_token! params[:auth_token]
  end

  # GET /companies
  def index
    @companies = Company.all
    render json: { companies: @companies }, :include => { :brands => { :only => [:name, :id] } }, :except => [:updated_at]
  end

  # GET /companies/1
  def show
    if ! @company.present? 
      render json: { errors: 'No se encontró la compañía con id: ' + params[:id] },status: :unprocessable_entity
      return
    end

    render json: @company
  end

  # POST /companies
  def create
    @company = Company.new(company_params)
    
    if @company.save
      render json: @company, status: :created
      return
    end

    render json: { errors: @company.errors },status: :unprocessable_entity
  end

  # POST /companies/update/1
  def update
    if ! @company.present? 
      render json: { errors: 'No se encontró ninguna companía con id: ' + params[:id] },status: :unprocessable_entity
      return
    end
    
    if @company.update(company_params)
      render json: @company, status: :ok
      return 
    end
    render json: { errors: @company.errors }, status: :unprocessable_entity
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find_by_id(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def company_params
      params.require(:company).permit( :name )
    end

end
