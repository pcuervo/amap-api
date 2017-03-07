module Pushable
  require 'one_signal'
  OneSignal::OneSignal.api_key = ENV['OS_API_KEY']
  OneSignal::OneSignal.user_auth_key = ENV['OS_AUTH_KEY']

  def send_push_notification player_id, msg, date=-1
    params = {
      app_id: ENV['OS_APP_ID'],
      contents: {
        en: msg
      },
      ios_badgeType: 'None',
      ios_badgeCount: 1,
      include_player_ids: [player_id]
    }

    if date != -1
      params[:send_after] = date
    end

    begin
      response = OneSignal::Notification.create(params: params)
      notification_id = JSON.parse(response.body)["id"]
    rescue OneSignal::OneSignalError => e
      puts "--- OneSignalError  :"
      puts "-- message : #{e.message}"
      puts "-- status : #{e.http_status}"
      puts "-- body : #{e.http_body}"
    end
  end
end