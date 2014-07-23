require 'rails_helper'

module Tincanz
  RSpec.describe MessageComposer, :type => :model do

    let(:message)     { create(:message, content: 'bye') }
    let(:new_message) { MessageComposer.compose(content: 'hi', reply_to_id: message.id) }

    context 'when in reply to previous message' do
      
      it "embeds the previous message content and author into new message" do
        expect(new_message.content).to eq "hi\n\n------\n#{message.user.tincanz_email} wrote:\nbye"
      end

    end
  end
end
