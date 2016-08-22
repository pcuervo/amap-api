module Api::V1
  class AgenciesController < ApiController
    before_action :set_agency, only: [:show, :update, :destroy]
    before_action only: [:create, :update] do 
      authenticate_with_token! params[:auth_token]
    end

    # GET /agencies
    def index
      @agencies = Agency.all
      render json: { agencies: @agencies }
    end

    # GET /agencies/1
    def show
      if ! @agency.present? 
        render json: { errors: 'No agency found with id: ' + params[:id] },status: :unprocessable_entity
        return
      end
      render json: @agency
    end

    # POST /agencies
    def create
      @agency = Agency.new(agency_params)

      if params[:logo].present?
        logo = Paperclip.io_adapters.for(params[:logo])
        logo.original_filename = params[:filename]
        @agency.logo = logo
      end
      
      if @agency.save
        render json: @agency, status: :created
        return
      end

      render json: { errors: @agency.errors },status: :unprocessable_entity
    end

    # POST /agencies/update/1
    def update
      if params[:logo].present?
        logo = Paperclip.io_adapters.for(params[:logo])
        logo.original_filename = params[:filename]
        @agency.logo = logo
      end
      
      if @agency.update(agency_params)
        render json: @agency, status: :ok
        return 
      end
      render json: { errors: @agency.errors }, status: :unprocessable_entity
    end

    # DELETE /agencies/1
    def destroy
      @agency.destroy
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_agency
        @agency = Agency.find_by_id(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def agency_params
        params.require(:agency).permit( :name, :phone, :contact_name, :contact_email, :address, :latitude, :longitude, :website_url, :num_employees, :golden_pitch, :silver_pitch, :medium_risk_pitch, :high_risk_pitch, :agency )
      end
  end
end