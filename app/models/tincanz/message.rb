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

    has_many   :receipts,
               class_name: 'Tincanz::Receipt'

    has_many   :recipients,
               class_name: Tincanz.user_class,
               through: :receipts

    validates :user, presence: true
    validates :conversation, presence: true
    validates :content, presence: true

    scope :most_recent, -> { order 'updated_at DESC' }

    def recipient_ids_string=(val)
      self.recipient_ids = val.is_a?(String) ? val.split(",") : val
    end
  end
end
