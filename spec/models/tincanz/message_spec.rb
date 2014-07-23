require 'rails_helper'
require 'timecop'

module Tincanz
  RSpec.describe Message, :type => :model do
    it "is valid" do
      m = build(:message)
      expect(m).to be_valid
    end
  end
end
