module Tincanz
  class Conversation < ActiveRecord::Base
    
    has_many :messages, class_name: 'Tincanz::Message'
    
    has_one  :first_message, 
             -> { order('tincanz_messages.created_at ASC').limit(1) },
             class_name: 'Tincanz::Message'

    has_many :subsequent_messages,
              -> { order('tincanz_messages.updated_at ASC').offset(1) },
              class_name: 'Tincanz::Message'

    belongs_to :user, class_name: Tincanz.user_class
    validates :user, presence: true
  end
end
