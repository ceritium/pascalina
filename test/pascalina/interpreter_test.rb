# frozen_string_literal: true

require "test_helper"

module Pascalina
  class InterpreterTest < Minitest::Test
    def ast_for(code)
      Parser.new(Lexer.new(code).tokenize).parse
    end

    test "negative number" do
      assert_equal(-1, Interpreter.new.interpret(ast_for("-1")))
    end

    test "positive number" do
      assert_equal(1, Interpreter.new.interpret(ast_for("+1")))
    end

    test "parses number token" do
      Interpreter.new.interpret(ast_for("1 + 1"))
    end

    test "parses nested function calls" do
      context = Context.new
      context.function_registry["SUM"] = ->(*numbers) { numbers.sum }

      interpreter = Interpreter.new(context)
      assert_equal 6, interpreter.interpret(ast_for("SUM(1, 2, SUM(1,2))"))
    end

    test "funct" do
      context = Context.new
      context.function_registry["TWO_ARGS"] = ->(a, b) { a + b }
      interpreter = Interpreter.new(context)
      exception = assert_raises Interpreter::FunctionCall::WrongNumberArgsError do
        interpreter.interpret(ast_for("TWO_ARGS(1, 2, 3)"))
      end

      assert_equal "`TWO_ARGS`: wrong number of args (given 3, expected 2)", exception.message
    end

    test "missing function" do
      interpreter = Interpreter.new
      exception = assert_raises Interpreter::FunctionCall::UndefinedFunctionError do
        interpreter.interpret(ast_for("MISSING(1, 2)"))
      end

      assert_equal "Undefined function `MISSING`", exception.message
    end

    test "with vars" do
      context = Context.new
      context.variable_registry["X"] = 2
      interpreter = Interpreter.new(context)
      assert_equal 4, interpreter.interpret(ast_for("X * 2"))
    end

    test "assign var" do
      interpreter = Interpreter.new
      interpreter.interpret(ast_for("X = 2 + 2"))
      assert_equal 4, interpreter.interpret(ast_for("X"))
    end
  end
end
