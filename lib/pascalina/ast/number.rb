# frozen_string_literal: true

module Pascalina
  module AST
    class Number < AST::Expression
      def initialize(val)
        super(val)
      end

      def ==(other)
        value == other&.value
      end

      def children
        []
      end
    end
  end
end
