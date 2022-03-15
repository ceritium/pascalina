# frozen_string_literal: true

module Pascalina
  class Calculator
    attr_reader :context

    def initialize
      @context = Context.new
    end

    def evaluate(code)
      ast = Parser.new(Lexer.new(code).tokenize).parse
      Interpreter.new(context).interpret(ast)
    end

    def add_basic_functions
      register_function("SUM", ->(*numbers) { numbers.sum })
      register_function("AVG", ->(*numbers) { numbers.sum / numbers.count })
    end

    def register_function(name, callable)
      context.function_registry[name] = callable
      name
    end
  end
end
