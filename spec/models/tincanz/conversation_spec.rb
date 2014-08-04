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

    context "#participants" do

      it "returns authors and recipients in conversation" do
        adam = create(:user, email: 'adam@gmail.com')
        jack = create(:user, email: 'jack@gmail.com')
        jill = create(:user, email: 'jill@gmail.com')

        conv = create(:conversation)
        msg_a = create(:message, conversation: conv, user: adam, recipients: [jack, jill])

        participant_ids = conv.participants.map(&:id)

        expect(participant_ids).to include(adam.id)
        expect(participant_ids).to include(jack.id)
        expect(participant_ids).to include(jill.id)
      end

      it "does not contain duplicates" do
        adam = create(:user)
        jack = create(:user)
        jill = create(:user)

        conv = create(:conversation)
        msg_a = create(:message, conversation: conv, user: adam, recipients: [jack, jill])
        msg_b = create(:message, conversation: conv, user: jill, recipients: [adam])
        msg_c = create(:message, conversation: conv, user: jack, recipients: [adam])
        msg_d = create(:message, conversation: conv, user: adam, recipients: [jack])

        participant_ids = conv.participants.map(&:id)

        expect(participant_ids.size).to eq 3
      end
    end
  end
end
