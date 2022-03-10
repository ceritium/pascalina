# frozen_string_literal: true

module Pascalina
  module AST
    module Expression
      attr_accessor :value

      def type
        # e.g., Stoffle::AST::FunctionCall becomes "function_call"
        self.class.to_s.split("::").last.underscore
      end
    end
  end
end
