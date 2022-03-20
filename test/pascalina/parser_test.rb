# frozen_string_literal: true

require "test_helper"

module Pascalina
  class ParserTest < Minitest::Test
    using PickArray

    def tokens_for(code)
      Lexer.new(code).tokenize
    end

    def errors_for(code)
      parser = Parser.new(tokens_for(code))
      parser.parse
      parser.errors
    end

    test "parses number token" do
      assert_equal [], errors_for("4")
    end

    test "parses break line" do
      assert_equal [], errors_for("
                                  ")
    end

    test "parses operation and parenthesis" do
      assert_equal [], errors_for("(1 + 2)")
    end

    test "parses a function call" do
      assert_equal [], errors_for("SUM(1, 2, 3)")
    end

    test "parses a variable" do
      assert_equal [], errors_for("X * 2")
    end

    test "parses an assignment variable" do
      assert_equal [], errors_for("X = 2")
    end
  end
end
