# frozen_string_literal: true

module Pascalina
  module AST
    class FunctionCall
      include AST::Expression

      attr_accessor :name, :args

      def initialize(name, args = [])
        @name = name
        @args = args
      end

      def ==(other)
        children == other&.children
      end

      def children
        [name, args]
      end
    end
  end
end
