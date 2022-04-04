# frozen_string_literal: true

module Pascalina
  class Calculator
    attr_reader :context

    def initialize
      @context = Context.new
    end

    def evaluate_ast(ast, vars = {})
      interpret(ast, vars)
    end

    def evaluate(code, vars = {})
      ast = generate_ast(code, raise_error: false)
      interpret(ast, vars) if ast
    rescue Interpreter::UndefinedVariableError
      nil
    end

    def evaluate!(code, vars = {})
      ast = generate_ast(code, raise_error: true)
      interpret(ast, vars)
    end

    def interpret(ast, vars)
      context.register_vars(vars)

      interpreter = Interpreter.new(context)
      interpreter.interpret(ast)
    end

    def generate_ast(code, raise_error: false)
      lexer = Lexer.new(code)
      lexer.tokenize

      if lexer.errors.first
        return unless raise_error

        raise parser.errors.first
      end

      parser = Parser.new(lexer.tokens)
      parser.parse

      if parser.errors.first
        return unless raise_error

        raise parser.errors.first
      end

      parser.ast
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
