
class Tincanz::ApplicationController < ApplicationController

  private

  def authenticate_tincanz_user
    if !tincanz_user
      flash.alert = t('tincanz.errors.unauthenticated')
      redirect_to sign_in_path
    end
  end

  def authorize_admin
    if !Tincanz::AdminManagePolicy.new(tincanz_user).access? 
      flash.alert = t('tincanz.errors.unauthorized')
      redirect_to main_app.root_path
    end
  end 

  def sign_in_path
    path = Tincanz.sign_in_path || (main_app.respond_to?(:sign_in_path) and main_app.sign_in_path)

    raise "Tincanz could not determine where to redirect your user to sign in." +
            "Either create a sign_in_path route in your main apps routes.rb or configure directly in a initializer file - Tincanz.sign_in_path = '/some/sign_in/path'" if !path
    
    path
  end
end
