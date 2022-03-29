# frozen_string_literal: true

require "forwardable"

module Pascalina
  class Token
    AVAILABLE = [
      EQUAL = :"=",
      PLUS = :'+',
      MINUS = :'-',
      STAR = :'*',
      SLASH = :'/',
      COMMA = :",",

      BREAK_LINE = :_BL,
      EOF = :eof,

      NUMBER = :number,
      IDENTIFIER = :identifier,
      LPAREN = :'(',
      RPAREN = :')'
    ].freeze

    extend Forwardable
    def_delegators :location, :line, :col, :length
    attr_reader :type, :lexeme, :literal, :location

    def initialize(type, lexeme, literal = nil, location = nil)
      @type = type
      @lexeme = lexeme
      @literal = literal
      @location = location
    end

    def is?(*types)
      types.include?(type)
    end
  end
end
