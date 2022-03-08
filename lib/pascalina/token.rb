module Pascalina
  class Token

    attr_reader :type, :lexeme, :literal
    def initialize(type, lexeme, literal = nil)
      @type = type
      @lexeme = lexeme
      @literal = literal
    end
  end
end
