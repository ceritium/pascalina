# frozen_string_literal: true

module Pascalina
  module AST
    class BinaryOperator
      include AST::Expression
      attr_accessor :operator, :left, :right

      def initialize(operator, left = nil, right = nil)
        @operator = operator
        @left = left
        @right = right
      end

      def ==(other)
        operator == other&.operator && children == other&.children
      end

      def children
        [left, right]
      end
    end
  end
end
