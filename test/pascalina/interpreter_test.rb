# frozen_string_literal: true

require "test_helper"

module Pascalina
  class InterpreterTest < Minitest::Test
    def setup
      @interpreter = Interpreter.new
    end

    def interpret_for(code)
      @interpreter.interpret(Parser.new(Lexer.new(code).tokenize).parse)
    end

    test "parses number token" do
      interpret_for("1 + 1")
    end

    test "parses nested function calls" do
      @interpreter.env["SUM"] = ->(*numbers) { numbers.sum }

      assert_equal 6, interpret_for("SUM(1, 2, SUM(1,2))")
    end

    test "funct" do
      @interpreter.env["TWO_ARGS"] = ->(a, b) { a + b }
      exception = assert_raises RuntimeError do
        interpret_for("TWO_ARGS(1, 2, 3)")
      end

      assert_equal "`TWO_ARGS`: wrong number of args (given 3, expected 2})", exception.message
    end

    test "missing function" do
      exception = assert_raises RuntimeError do
        interpret_for("MISSING(1, 2)")
      end

      assert_equal "Undefined function MISSING", exception.message
    end
  end
end
