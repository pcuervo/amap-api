class Api::V1::PitchesController < ApplicationController
  before_action :set_pitch, only: [:show, :update]
  before_action only: [:create, :update] do 
    authenticate_with_token! params[:auth_token]
  end
  after_action :add_client_to_pitch, only: [:create]

  # GET /pitches
  def index
    @pitches = Pitch.all
    render json: { pitches: @pitches },  
           :include => { 
              :skill_categories => 
                { :only => [:name, :id] },
              :brand => 
                { :only => [:id, :name],
                  :include => {
                    :company => {
                      :only => [:id, :name]
                    }
                  }
                } 
            }, except: [:created_at, :updated_at]
  end

  # GET /pitches/1
  def show
    if ! @pitch.present? 
      render json: { errors: 'No se encontró el pitch con id: ' + params[:id] },status: :unprocessable_entity
      return
    end

    render json: @pitch
  end

  # POST /pitches
  def create
    @pitch = Pitch.new(pitch_params)

    if @pitch.save
      pitch_evaluation = PitchEvaluation.create(:user_id => current_user.id, :pitch_status => PitchEvaluation::ACTIVE )
      pitch_evaluation.pitch = @pitch 
      pitch_evaluation.save

      render json: @pitch, status: :created
      return
    end

    render json: { errors: @pitch.errors },status: :unprocessable_entity
  end

  # GET /pitches/by_brand
  def by_brand
    @pitches = Pitch.where( 'brand_id = ?', params[:id] )
    if ! @pitches.present? 
      render json: { errors: 'No se encontraron proyectos para la marca con id: ' + params[:id] },status: :unprocessable_entity
      return
    end

    render json: @pitches
  end

  # POST /pitches/merge
  def merge
    good_pitch = Pitch.find( params[:good_pitch_id] )
    bad_pitch = Pitch.find( params[:bad_pitch_id] )

    good_pitch.merge( bad_pitch )

    if good_pitch.merge( bad_pitch )
      render json: good_pitch, except: [:pitch_evaluations]
      return
    end
    render json: { errors: 'Ocurrió un error al unificar los pitches' },status: :unprocessable_entity
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pitch
      @pitch = Pitch.find_by_id(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def pitch_params
      params.require(:pitch).permit( :name, :brief_date, :brief_email_contact, :brand_id )
    end

    def add_client_to_pitch
      return if ! @pitch.present?
      return if @pitch.errors.any?

      # If client exists, add pitch
      user = User.find_by_email( @pitch.brief_email_contact )
      if user.present?
        user.pitches << @pitch 
        user.save
        notify_client_new_pitch_email( user, @pitch )
        return
      end

      # If client doesn't exist, create a new user 
      password = SecureRandom.hex
      user = User.create(:email => @pitch.brief_email_contact, :role => User::CLIENT_USER, :password => password)
      user.pitches << @pitch 
      user.save
      send_new_client_email( user, password, @pitch )
    end

    def send_new_client_email( user, password, pitch )
      UserMailer.new_client_email( user, password, pitch ).deliver_now
    end

    def notify_client_new_pitch_email( user, pitch )
      UserMailer.new_pitch_client( user, pitch ).deliver_now
    end

end
