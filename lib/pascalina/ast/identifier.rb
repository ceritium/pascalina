# frozen_string_literal: true

module Pascalina
  module AST
    class Identifier
      include AST::Expression

      attr_accessor :name

      def initialize(name)
        @name = name
      end

      def ==(other)
        name == other&.name
      end

      def children
        []
      end
    end
  end
end
