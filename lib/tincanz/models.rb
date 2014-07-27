module Tincanz
  module Models
    extend ActiveSupport::Concern

    module ClassMethods
      def acts_as_tincanz_user
        include TincanzInstanceMethods    
      end
    end

    module TincanzInstanceMethods
      def tincanz_email 
        email
      end  
    end
  end
end

ActiveRecord::Base.send :include, Tincanz::Models