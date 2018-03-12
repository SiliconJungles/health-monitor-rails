Rails.application.routes.draw do
  mount DoctorStrange::Engine => '/health'
end
