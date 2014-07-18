module Tincanz
  class Message < ActiveRecord::Base
    belongs_to :conversation, class_name: 'Tincanz::Conversation'
    belongs_to :user, class_name: Tincanz.user_class

    validates :user, presence: true
    validates :conversation, presence: true
    validates :content, presence: true
  end
end
