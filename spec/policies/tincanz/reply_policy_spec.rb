require 'rails_helper'

module Tincanz
  RSpec.describe ReplyPolicy, :type => :model do
    
    context "admin" do
      it "can reply to all messages" do
        random_message = create(:message)
        policy = ReplyPolicy.new(create(:admin), random_message)
        expect(policy.can_reply?).to be true
      end
    end

    context "user" do
      it "can reply to messages they were a recipient of" do
        hero         = create(:user)
        message      = create(:message, user: create(:user), recipients: [hero])
        policy       = ReplyPolicy.new(hero, message)
        expect(policy.can_reply?).to be true
      end

      it "can not reply to messages in which they are not a recipient of" do
        villain      = create(:user)
        innocent     = create(:user)
        message      = create(:message, user: create(:user), recipients: [innocent])
        policy       = ReplyPolicy.new(villain, message)
        expect(policy.can_reply?).to be false
      end
    end
  end
end
