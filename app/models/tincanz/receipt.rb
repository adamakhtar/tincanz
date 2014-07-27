module Tincanz
  class Receipt < ActiveRecord::Base
    belongs_to :message, 
               class_name: 'Tincanz::Message'

    belongs_to :recipient, 
               class_name: Tincanz.user_class
               
  end
end
