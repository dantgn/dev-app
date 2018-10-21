class ApplicationController < ActionController::Base
  if Rails.env.production?
    http_basic_authenticate_with name: Rails.application.credentials[:username_key],
                                 password: Rails.application.credentials[:password_key]
  end
end
