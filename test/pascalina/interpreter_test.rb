# frozen_string_literal: true

require "test_helper"

module Pascalina
  class InterpreterTest < Minitest::Test
    def interpret_for(code)
      Interpreter.new.interpret(Parser.new(Lexer.new(code).tokenize).parse)
    end

    test "parses number token" do
      interpret_for("1 + 1")
    end
  end
end
