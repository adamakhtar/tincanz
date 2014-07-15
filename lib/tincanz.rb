require "tincanz/engine"

module Tincanz

   mattr_accessor :sign_in_path

   class << self

      def user_class
        if @@user_class.is_a?(Class)
          raise "You can not set Tincanz.user_class to be a class. Please use a string instead.\n\n "
        elsif @@user_class.is_a?(String)
          begin
            Object.const_get(@@user_class)
          rescue NameError
            @@user_class.constantize
          end
        end
      end

   end
end
