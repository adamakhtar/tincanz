require 'rails_helper'

module Tincanz
  RSpec.describe Conversation, :type => :model do
    it "is valid" do
      c = build(:conversation)
      expect(c).to be_valid
    end
  end
end
