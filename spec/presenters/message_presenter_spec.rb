require 'rails_helper'

module Tincanz
  RSpec.describe MessagePresenter, :type => :model do

    let!(:author)      { create(:user) }
    let!(:recipient)   { create(:user) }
    let!(:message)     { create(:message, user: author, content: 'bye', recipients: [recipient]) }
    let!(:context)     { ApplicationController.new.view_context }
  
    context 'when user is viewing a message they wrote' do
      it "#author returns 'you'" do
        presenter = MessagePresenter.new(context, message, current_user: author)
        expect(presenter.author).to eq 'You'
      end

      it '#recipient returns the recipient email' do
        presenter = MessagePresenter.new(context, message, current_user: author)
        expect(presenter.recipient).to eq recipient.tincanz_email
      end 
    end

    context 'when recipient is viewing a message' do
      it '#author returns the authors email address' do
        presenter = MessagePresenter.new(context, message, current_user: recipient)
        expect(presenter.author).to eq author.tincanz_email
      end

      it "#recipient returns 'you'" do
        presenter = MessagePresenter.new(context, message, current_user: recipient)
        expect(presenter.recipient).to eq 'you'
      end
    end

    context 'when mutliple recipients' do
      it '#recipient returns total number if admin' do
        admin = create(:admin)
        message.update_attributes(user: admin)
        message.recipients << create(:user)

        presenter = MessagePresenter.new(context, message, current_user: admin)
        expect(presenter.recipient).to eq "2 people"
      end
    end
      
  end
end
