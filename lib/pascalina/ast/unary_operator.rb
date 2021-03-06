# frozen_string_literal: true

module Pascalina
  module AST
    class UnaryOperator
      include AST::Expression
      attr_accessor :operator, :operand

      def initialize(operator, operand = nil)
        @operator = operator
        @operand = operand
      end

      def ==(other)
        operator == other&.operator && children == other&.children
      end

      def children
        [operand]
      end
    end
  end
end
