include Pushable
class PitchResult < ApplicationRecord
  belongs_to :agency
  belongs_to :pitch

  def schedule_response_notification
    agency_users = self.agency.users
    agency_users.each do |u| 
      next if u.device_token == ''

      send_push_notification( u.device_token, '¿Has recibido fallo acerca del pitch "' + self.pitch.name + '"? No olvides actualizar la encuesta de resultados.', self.when_will_you_get_response  )
    end
  end

end
