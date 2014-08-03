module Tincanz
  class Conversation < ActiveRecord::Base

    belongs_to :assignee, 
               foreign_key: :user_id,
               class_name: Tincanz.user_class
    
    has_many :messages, class_name: 'Tincanz::Message'

    has_many :receipts, 
             through: :messages

    has_many :recipients,
             -> { uniq },
             through: :receipts,
             class_name: Tincanz.user_class
    
    has_many :authors,
             -> { uniq },
             through: :messages,
             source: :user,
             class_name: Tincanz.user_class

    has_one  :first_message, 
             -> { order('tincanz_messages.created_at ASC').limit(1) },
             class_name: 'Tincanz::Message'

    has_many :subsequent_messages,
              -> { order('tincanz_messages.created_at ASC').offset(1) },
             class_name: 'Tincanz::Message'              

    has_one  :most_recent_message,
             -> { order('tincanz_messages.created_at DESC').limit(1) },
             class_name: 'Tincanz::Message'         


    scope :involving, -> (user) { joins(messages: :receipts).where(["tincanz_messages.user_id = :user_id OR tincanz_receipts.recipient_id = :user_id", user_id: user.id]) }

    scope :recent, -> { order('created_at DESC') }

    accepts_nested_attributes_for :messages

    belongs_to :user, class_name: Tincanz.user_class

    def participants
      (authors + recipients).uniq
    end
  end
end

