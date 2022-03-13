# frozen_string_literal: true

module Pascalina
  class Calculator
    attr_reader :interpreter

    def initialize
      @interpreter = Interpreter.new
    end

    def evaluate(code)
      interpreter.interpret(Parser.new(Lexer.new(code).tokenize).parse)
    end

    def add_basic_functions
      register_function("SUM", ->(*numbers) { numbers.sum })
      register_function("AVG", ->(*numbers) { numbers.sum / numbers.count })
    end

    def register_function(name, callable)
      interpreter.env[name] = callable
      name
    end
  end
end
