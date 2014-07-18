module Tincanz
  class Conversation < ActiveRecord::Base
    has_many :messages, class_name: 'Tincanz::Message'
    belongs_to :user, class_name: Tincanz.user_class

    validates :subject, presence: true
    validates :user, presence: true
  end
end
