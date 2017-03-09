class Api::V1::DashboardsController < ApplicationController

  # GET /dashboards/amap
  def amap
    dashboard_data = {}
    closed_pitches = PitchResult.where( 'was_pitch_won = ?', true ).pluck(:pitch_id)
    pitch_types = PitchEvaluation.where('pitch_type is not null').group(:pitch_type).count
    worst_pitches = PitchEvaluation.joins(:pitch).limit(3).group("name").order('avg(score) asc').average(:score)
    top_pitches = PitchEvaluation.joins(:pitch).limit(3).group("name").order('avg(score) desc').average(:score)

    # Closed vs Pending pitches
    dashboard_data[:total_closed] = closed_pitches.count
    dashboard_data[:total_pending] = PitchResult.where( 'pitch_id NOT IN (?)', closed_pitches ).count
    # Pitches by type
    dashboard_data[:total_happitch] = pitch_types["happitch"].nil? ? 0 : pitch_types["happitch"]
    dashboard_data[:total_happy] = pitch_types["happy"].nil? ? 0 : pitch_types["happy"]
    dashboard_data[:total_ok] = pitch_types["ok"].nil? ? 0 : pitch_types["ok"]
    dashboard_data[:total_unhappy] = pitch_types["unhappy"].nil? ? 0 : pitch_types["unhappy"]
    # Global stats
    dashboard_data[:total_pitches] = Pitch.all.count
    dashboard_data[:total_agencies] = Agency.all.count
    dashboard_data[:total_companies] = Company.all.count
    dashboard_data[:total_brands] = Brand.all.count
    # Ranking
    dashboard_data[:worst_pitches] = worst_pitches
    dashboard_data[:top_pitches] = top_pitches

    render json: dashboard_data, status: :ok
  end
end
