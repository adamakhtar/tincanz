module Tincanz
  class Message < ActiveRecord::Base

    belongs_to :conversation, 
               class_name: 'Tincanz::Conversation'

    belongs_to :user, 
               class_name: Tincanz.user_class

    belongs_to :reply_to, 
               class_name: 'Tincanz::Message'

    has_many   :replies, 
               class_name: 'Tincanz::Message',
               foreign_key: 'reply_to_id'

    validates :user, presence: true
    validates :conversation, presence: true
    validates :content, presence: true

    scope :most_recent, -> { order 'updated_at DESC' }
  end
end
