
class Tincanz::ApplicationController < ApplicationController

  private

  def authenticate_tincanz_user
    if !tincanz_user

      flash.alert = t('tincanz.errors.unauthenticated')
      sign_in_path = Tincanz.sign_in_path || (main_app.respond_to?(:sign_in_path) and main_app.sign_in_path)
      if sign_in_path
        redirect_to sign_in_path
      else
        raise "Tincanz could not determine where to redirect your user to sign in." +
              "Either create a sign_in_path route in your main apps routes.rb or configure directly in a initializer file - Tincanz.sign_in_path = '/some/sign_in/path'"
      end
    end
  end 
end
