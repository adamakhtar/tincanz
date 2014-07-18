require_dependency "tincanz/application_controller"

module Tincanz
  class Admin::UsersController < ApplicationController
    before_filter :authenticate_tincanz_user

    respond_to :html

    def index
      @users = Tincanz.user_class.all
      respond_with @users
    end

    def show
      @user = Tincanz.user_class.find(params[:id])
      respond_with @user
    end
  end
end
