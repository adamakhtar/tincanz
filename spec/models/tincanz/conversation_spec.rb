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
  end
end
