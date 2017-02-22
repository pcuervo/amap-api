class Api::V1::CriteriaController < ApplicationController
  # GET /criteria
  def index
    @criteria = Criterium.order(:id).all
    render json: { criteria: @criteria }, :except => [:updated_at]
  end
end
