# frozen_string_literal: true

module Pascalina
  class Token
    BREAK_LINE = :_BL

    attr_reader :type, :lexeme, :literal

    def initialize(type, lexeme, literal = nil)
      @type = type
      @lexeme = lexeme
      @literal = literal
    end
  end
end
