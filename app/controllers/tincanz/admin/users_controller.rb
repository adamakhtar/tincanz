require_dependency "tincanz/application_controller"

module Tincanz
  class Admin::UsersController < ApplicationController
    before_filter :authenticate_tincanz_user

    def index
      @users = Tincanz.user_class.all
    end
  end
end