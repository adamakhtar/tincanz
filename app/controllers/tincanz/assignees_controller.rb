require_dependency "tincanz/application_controller"

module Tincanz
  class AssigneesController < ApplicationController
    before_filter :authenticate_tincanz_user
    before_filter :authorize_admin

    def update
      @conversation = Conversation.find(params[:conversation_id])

      if @conversation.update_attributes(conversation_params)
        flash.notice = t('tincanz.assignees.updated')
      else
        flash.alert  = t('tincanz.assignees.not_updated')
      end

      redirect_to conversation_path(@conversation)
    end

    private

    def conversation_params
      params.require(:conversation).permit(:user_id)
    end 

  end
end
