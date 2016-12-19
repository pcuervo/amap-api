# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


if Recommendation.all.count == 0 
  Recommendation.create(:body => 'Aclara los objetivos con el cliente. Es importante saber qué espera para evitar retrabajo.', :reco_id => 'agency_communication', :reco_type => 'agency')
  Recommendation.create(:body => 'Es importante que el cliente te defina los objetivos de tu pitch. Trabaja en este punto para que la calidad de tus pitches mejore.', :reco_id => 'agency_list', :reco_type => 'agency')
  Recommendation.create(:body => 'Si tienes forma de conseguir el budget del proyecto te recomendamos hacerlo, así podrás alinear tu propuesta a este.', :reco_id => 'agency_budget_1', :reco_type => 'agency')
  Recommendation.create(:body => 'Es importante conocer el presupuesto de los pitches para que tus propuestas vayan alineadas. Verifica esta información con el cliente.', :reco_id => 'agency_budget_3', :reco_type => 'agency')
  Recommendation.create(:body => 'El cliente debe de tener claro qué factores usará para asignar a su agencia. Este valor te ayudará a enfocar tus esfuerzos.', :reco_id => 'agency_sharing', :reco_type => 'agency')
  Recommendation.create(:body => 'Los pitches con muchas agencias diluyen los esfuerzos de todos, te recomendamos enfocar tus esfuerzos a pitches con menos agencias para aumentar tus probabilidades.', :reco_id => 'agency_number_5', :reco_type => 'agency')
  Recommendation.create(:body => ' Te recomendamos no participar en estos proyectos y así impulsar las mejores prácticas de pitching para todos.', :reco_id => 'agency_number_7', :reco_type => 'agency')
  Recommendation.create(:body => 'Las buenas ideas toman su tiempo. Te recomendamos no participar en pitches que den pocos días para preparar tu presentación.', :reco_id => 'agency_time', :reco_type => 'agency')
  Recommendation.create(:body => ' Busca que estos pitches sean pagados o es mejor evitarlos para transparentar el proceso.', :reco_id => 'agency_property', :reco_type => 'agency')
  Recommendation.create(:body => 'Te recomendamos revisar el brief nuevamente y ponerte en contacto con el cliente para alinear este punto.', :reco_id => 'agency_deliverable', :reco_type => 'agency')
  Recommendation.create(:body => '¡Cuidado! Participar en este tipo de pitches es altamente riesgoso y nos aleja de nuestro objetivo que es mejorar el proceso de pitch.', :reco_id => 'agency_careful', :reco_type => 'agency')
  Recommendation.create(:body => 'Cuando participas en pitches que no tienen la información bien definida, se corre el riesgo de que el proyecto no se lleve a cabo o que tengas que retrabajar varias veces. ', :reco_id => 'agency_speak', :reco_type => 'agency')
  Recommendation.create(:body => '¡Alerta! Lo mejor es recomendable declinar estos procesos para impulsar las mejores prácticas de nuestra industria.', :reco_id => 'agency_alert', :reco_type => 'agency')
  Recommendation.create(:body => 'Te sugerimos confirmar que los objetivos están claros para todos los participantes.', :reco_id => 'client_objective_25', :reco_type => 'client')
  Recommendation.create(:body => 'Te sugerimos confirmar que los objetivos están claros para todos los participantes.', :reco_id => 'client_objective_50', :reco_type => 'client')
  Recommendation.create(:body => 'La mayoría de las agencias participando en tu pitch no tienen los objetivos claros. Es importante que estén alineados para que recibas propuestas que te funcionen.', :reco_id => 'client_objective_75', :reco_type => 'client')
  Recommendation.create(:body => 'No todas las agencias invitadas al pitch tienen el presupesto del proyecto definido. Te sugerimos confirmar que compartiste correctamente esta información.', :reco_id => 'client_budget_25', :reco_type => 'client')
  Recommendation.create(:body => 'No todas las agencias invitadas al pitch tienen el presupesto del proyecto definido. Te sugerimos confirmar que compartiste correctamente esta información.', :reco_id => 'client_budget_50', :reco_type => 'client')
  Recommendation.create(:body => 'La mayoría de las agencias participando en tu pitch no tienenel presupesto del proyecto definido. Conocer el presupesto es clave para una mejor propuesta.', :reco_id => 'client_budget_75', :reco_type => 'client')
  Recommendation.create(:body => '¡Ups! Ninguna de las agencias participantes tiene definido el presupesto para el proyecto. Te recomendamos aclarar esta información.', :reco_id => 'client_budget_100', :reco_type => 'client')
  Recommendation.create(:body => 'No todas las agencias invitadas conocen los criterios de selección. Te recomendamos compartir esta información con ellos. ', :reco_id => 'client_criteria', :reco_type => 'client')
  Recommendation.create(:body => '¡Ojo! Te sugerimos invitar sólo a las agencias que tienen más desarrollados los skills que necesitas en tu proyecto.', :reco_id => 'client_number_5', :reco_type => 'client')
  Recommendation.create(:body => '¡Alerta! Invitar a tantas agencias a tu proceso de pitch es dañino para la industria industria de la comunicación. Menos agencias te ayudan a optimizar el proceso de asignación.', :reco_id => 'client_number_7', :reco_type => 'client')
  Recommendation.create(:body => '¡A mayor tiempo, mejores ideas! Te sugerimos dar mínimo 10 días a las agencias para preparar su presentación. ', :reco_id => 'client_time', :reco_type => 'client')
  Recommendation.create(:body => '¡Buen tiempo! 10 días son un buen tiempo para presentar una propuesta. De esta forma pueden generar ideas que cumplan con tus objetivos de negocio.', :reco_id => 'client_more_time', :reco_type => 'client')
  Recommendation.create(:body => 'Quedarse con la propiedad intelectual de las agencias es una mala práctica. Haz  pitches pagados y así podrás tener la propiedad intelectual del trabajo de todas las agencias invitadas.', :reco_id => 'client_property', :reco_type => 'client')
  Recommendation.create(:body => 'Parece que no todas las agencias invitadas a tu pitch tienen los entregables claros.  Alínea esta información para transparentar el proceso.', :reco_id => 'client_deliverable_25', :reco_type => 'client')
  Recommendation.create(:body => 'Parece que no todas las agencias invitadas a tu pitch tienen los entregables claros.  Alínea esta información para transparentar el proceso.', :reco_id => 'client_deliverable_50', :reco_type => 'client')
  Recommendation.create(:body => 'La mayoría de las agencias participando en tu pitch no tienen los entregables claros. Es básico que tengan esa información para que te den una mejor propuesta. ', :reco_id => 'client_deliverable_75', :reco_type => 'client')
  Recommendation.create(:body => 'Ninguna de las agencias tiene los entregables claros. Es básico que compartas esta información con las agencias. ', :reco_id => 'client_deliverable_100', :reco_type => 'client')
end
