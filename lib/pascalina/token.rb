# frozen_string_literal: true

require "forwardable"

module Pascalina
  class Token
    BREAK_LINE = :_BL

    extend Forwardable
    def_delegators :location, :line, :col, :length
    attr_reader :type, :lexeme, :literal, :location

    def initialize(type, lexeme, literal = nil, location = nil)
      @type = type
      @lexeme = lexeme
      @literal = literal
      @location = location
    end
  end
end
