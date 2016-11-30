class Api::V1::SuccessCasesController < ApplicationController
  before_action :set_success_case, only: [:show, :update, :destroy]
    before_action only: [:create, :update, :destroy] do 
      authenticate_with_token! params[:auth_token]
    end

  # GET /success_cases
  def index
    @success_cases = SuccessCase.all
    render json: { success_cases: @success_cases }
  end

  # GET /success_cases/1
  def show
    if ! @success_case.present? 
      render json: { errors: 'No se encontró ningún case de éxito con id: ' + params[:id] },status: :unprocessable_entity
      return
    end
    render json: @success_case
  end

  # POST /success_cases
  def create
    @success_case = SuccessCase.new(success_case_params)

    if params[:case_image].present?
      case_image = Paperclip.io_adapters.for(params[:case_image])
      case_image.original_filename = params[:filename]
      @success_case.case_image = case_image
    end
    
    if @success_case.save
      render json: @success_case, status: :created
      return
    end

    render json: { errors: @success_case.errors },status: :unprocessable_entity
  end

  # POST /success_cases/update/1
  def update
    if ! @success_case.present? 
      render json: { errors: 'No se encontró ningún case de éxito con id: ' + params[:id] },status: :unprocessable_entity
      return
    end

    if params[:case_image].present?
      case_image = Paperclip.io_adapters.for(params[:case_image])
      case_image.original_filename = params[:filename]
      @success_case.case_image = case_image
    end

    if params[:delete_image]
      @success_case.case_image.destroy
    end
    
    if @success_case.update(success_case_params)
      render json: @success_case, status: :ok
      return 
    end
    render json: { errors: @success_case.errors }, status: :unprocessable_entity
  end

  # POST /success_cases/destroy/1
  def destroy
    if ! @success_case.present? 
      render json: { errors: 'No se encontró ningún case de éxito con id: ' + params[:id].to_s },status: :unprocessable_entity
      return
    end

    @success_case.destroy
    head 204
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_success_case
      @success_case = SuccessCase.find_by_id(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def success_case_params
      params.require(:success_case).permit( :name, :description, :url, :case_image, :agency_id )
    end
end
