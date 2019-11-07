Rails.application.routes.draw do
  root "notes#index"
  resource :notes
  
  #chord_controller
  get '/chord/format_notes_name', to: 'chord#format_notes_name'
  get '/chord/determinate_chord', to: 'chord#determinate_chord'
  
end
