module Api::V1
  class AgenciesController < ApiController
    before_action :set_agency, only: [:show, :update, :destroy, :add_skills, :add_criteria, :add_exclusivity_brands, :remove_exclusivity_brands]
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
        render json: { errors: 'No se encontró la agencia con id: ' + params[:id] },status: :unprocessable_entity
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
      if ! @agency.present? 
        render json: { errors: 'No se encontró la agencia con id: ' + params[:id] },status: :unprocessable_entity
        return
      end

      if params[:logo].present?
        logo = Paperclip.io_adapters.for(params[:logo])
        logo.original_filename = params[:filename]
        @agency.logo = logo
      end

      if params[:delete_image]
        @agency.logo.destroy
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

    # POST /agencies/add_skills
    def add_skills
      if ! @agency.present? 
        render json: { errors: 'No se encontró la agencia con id: ' + params[:id].to_s },status: :unprocessable_entity
        return
      end
      if ! params[:skills].present? 
        render json: { errors: 'No se encontró ningún skill para agregar' },status: :unprocessable_entity
        return
      end
      
      @agency.add_skills( params[:skills] )
      render json: @agency.agency_skills, status: :created
    end

    # POST /agencies/add_criteria
    def add_criteria
      if ! @agency.present? 
        render json: { errors: 'No se encontró la agencia con id: ' + params[:id].to_s },status: :unprocessable_entity
        return
      end
      if ! params[:criteria].present? 
        render json: { errors: 'No se encontró ningún criterio para agregar' },status: :unprocessable_entity
        return
      end
      
      @agency.add_criteria( params[:criteria] )
      render json: @agency.criteria, status: :created
    end

    # POST /agencies/add_exclusivity_brands
    def add_exclusivity_brands
      if ! @agency.present? 
        render json: { errors: 'No se encontró la agencia con id: ' + params[:id].to_s },status: :unprocessable_entity
        return
      end
      if ! params[:brands].present? 
        render json: { errors: 'No se encontró ninguna marca de exclusividad' },status: :unprocessable_entity
        return
      end
      
      @agency.add_exclusivity_brands( params[:brands] )
      render json: @agency.exclusivities, status: :created
    end

    # POST /agencies/remove_exclusivity_brands
    def remove_exclusivity_brands
      if ! @agency.present? 
        render json: { errors: 'No se encontró la agencia con id: ' + params[:id].to_s },status: :unprocessable_entity
        return
      end
      if ! params[:brands].present? 
        render json: { errors: 'No se encontró ninguna marca de exclusividad' },status: :unprocessable_entity
        return
      end
      
      @agency.remove_exclusivity_brands( params[:brands] )
      render json: @agency.exclusivities, status: :created
    end

    # POST /agencies/search
    def search
      @agencies = Agency.search( params[:keyword] )
      render json: { agencies: @agencies }
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