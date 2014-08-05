require 'rails_helper'

module Tincanz
  RSpec.describe ConversationComposer, :type => :model do

    let!(:innocent) { create(:user) }
    let!(:admin) { create(:admin) }

    context 'when user' do
      it 'forces recipients to be admin users' do
        params = {
          :messages_attributes => [
            {recipient_ids_string: innocent.id.to_s, 
             content: 'hacked!'}
          ]
        }
        conversation = ConversationComposer.compose(create(:user), params)
        recipients   = conversation.messages.first.recipients

        expect(recipients).to_not include(innocent)
        expect(recipients).to eq Tincanz.user_class.tincanz_admin
      end

      it 'prevent mulitple messages being created' do
        params = {
          :messages_attributes => [
            {recipient_ids_string: admin.id.to_s, content: 'hello!'},
            {recipient_ids_string: admin.id.to_s, content: 'again!'}
          ]
        }
        conversation = ConversationComposer.compose(create(:user), params)
        messages     = conversation.messages

        expect(messages.size).to eq 1
        expect(messages.first.content).to eq 'hello!'
      end

    end

  end
end
