# frozen_string_literal: true

module Pascalina
  module AST
    class Number
      include AST::Expression

      def initialize(value)
        @value = value
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
