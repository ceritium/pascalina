# frozen_string_literal: true

module Pascalina
  class Calculator
    attr_reader :context

    def initialize
      @context = Context.new
    end

    def evaluate(code, vars = {})
      lexer = Lexer.new(code)
      lexer.tokenize
      return if lexer.errors.first

      parser = Parser.new(lexer.tokens)
      parser.parse
      return if parser.errors.first

      vars.each_pair do |k, v|
        context.variable_registry[k] = v
      end

      interpreter = Interpreter.new(context)
      interpreter.interpret(parser.ast)
    rescue Interpreter::UndefinedVariableError
      nil
    end

    def evaluate!(code, vars = {})
      lexer = Lexer.new(code)
      lexer.tokenize
      raise lexer.errors.first if lexer.errors.first

      parser = Parser.new(lexer.tokens)
      parser.parse
      raise parser.errors.first if parser.errors.first

      vars.each_pair do |k, v|
        context.variable_registry[k] = v
      end

      interpreter = Interpreter.new(context)
      interpreter.interpret(parser.ast)
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
