# frozen_string_literal: true

module Pascalina
  module AST
    module Expression
      attr_accessor :value

      def type
        # e.g., Stoffle::AST::FunctionCall becomes "function_call"
        underscore(self.class.to_s.split("::").last)
      end

      private

      # TODO: more ruby
      def underscore(str)
        str.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
      end
    end
  end
end
