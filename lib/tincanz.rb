require "tincanz/engine"
require "tincanz/models"

module Tincanz

  class Unauthorized < StandardError; end

   mattr_accessor :sign_in_path, :user_class

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
