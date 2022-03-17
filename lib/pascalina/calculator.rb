# frozen_string_literal: true

module Pascalina
  class Calculator
    attr_reader :context

    def initialize
      @context = Context.new
    end

    def evaluate(code, vars = {})
      ast = Parser.new(Lexer.new(code).tokenize).parse
      vars.each_pair do |k, v|
        context.variable_registry[k] = v
      end

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
