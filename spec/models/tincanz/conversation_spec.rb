require 'rails_helper'

module Tincanz
  RSpec.describe Conversation, :type => :model do
    it "is valid" do
      c = build(:conversation)
      expect(c).to be_valid
    end

    it "has a root message" do
      c = create(:conversation)
      msg_a = create(:message, conversation: c, created_at: 1.day.ago)
      msg_b = create(:message, conversation: c, created_at: 10.day.ago)
      c.reload
      expect(c.first_message).to eq msg_b
    end

    context ".involving" do
      it "returns conversations user authored a message" do
        hero = create(:user)
        villain = create(:user)

        message_a = create(:message, user: hero)
        conv_a = create(:conversation, messages: [message_a])

        message_b = create(:message, user: villain)
        conv_b = create(:conversation, messages: [message_b])

        expect(Conversation.involving(hero)).to eq [conv_a]
      end

      it "returns conversations where user was a message recipient" do
        sender = create(:user)
        hero = create(:user)
        villain = create(:user)

        message_a = create(:message, user: sender, recipients: [hero])
        conv_a = create(:conversation, messages: [message_a])

        message_b = create(:message, user: sender, recipients: [villain])
        conv_b = create(:conversation, messages: [message_b])
        
        expect(Conversation.involving(hero)).to eq [conv_a]
      end
    end
  end
end
