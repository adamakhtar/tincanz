require 'rails_helper'

module Tincanz
  RSpec.describe ConversationPolicy, :type => :model do
    
    context "admin" do
      it "can read all conversations" do
        random_conversation = create(:conversation)
        policy = ConversationPolicy.new(create(:admin), random_conversation)
        expect(policy.can_read?).to be true
      end
    end

    context "user" do
      it "can read conversations they participate in as author" do
        hero         = create(:user)
        message      = create(:message, user: hero, recipients: [create(:user)])
        conversation = create(:conversation, messages: [message])
        policy       = ConversationPolicy.new(hero, conversation)
        expect(policy.can_read?).to be true
      end

      it "can read conversations they participate as recipient" do
        hero         = create(:user)
        message      = create(:message, user: create(:user), recipients: [hero])
        conversation = create(:conversation, messages: [message])
        policy       = ConversationPolicy.new(hero, conversation)
        expect(policy.can_read?).to be true
      end

      it "can not read conversations in which they do not participate" do
        villain      = create(:user)
        hero         = create(:user)
        message      = create(:message, user: create(:user), recipients: [hero])
        conversation = create(:conversation, messages: [message])
        policy       = ConversationPolicy.new(villain, conversation)
        expect(policy.can_read?).to be false
      end
    end
  end
end
