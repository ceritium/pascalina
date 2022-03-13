# frozen_string_literal: true

require "test_helper"

module Pascalina
  class LexerTest < Minitest::Test
    using PickArray

    def lexer(code)
      Pascalina::Lexer.new(code).tokenize
    end

    def pick(collection, *methods)
      collection.map do |item|
        methods.map do |method|
          item.public_send(method)
        end
      end
    end

    test "empty code" do
      assert_equal lexer("").pick(:type), [[:eof]]
    end

    test "ignore whitespace" do
      assert_equal lexer(" ").pick(:type), [[:eof]]
    end

    test "single breakline" do
      tokens = lexer("
                   ")
      assert_equal [Pascalina::Token::BREAK_LINE, :eof], tokens.map(&:type)
    end

    test "consecutive breaklines" do
      tokens = lexer("

                   ")

      assert_equal [Pascalina::Token::BREAK_LINE, :eof], tokens.map(&:type)
    end

    test "ignore comment" do
      assert_equal [[:eof]], lexer("#").pick(:type)
    end

    test "a single digit number" do
      tokens = lexer("4")
      assert_equal [[:number, 4], [:eof, nil]], tokens.pick(:type, :literal)
    end

    test "multiple digit number" do
      tokens = lexer("42")
      assert_equal [[:number, 42], [:eof, nil]], tokens.pick(:type, :literal)
    end

    test "consume decimals" do
      tokens = lexer("42.5")
      assert_equal [[:number, 42.5], [:eof, nil]], tokens.pick(:type, :literal)
    end

    test "consume negative numbers" do
      tokens = lexer("-42.5")
      assert_equal [[:-, nil], [:number, 42.5], [:eof, nil]], tokens.pick(:type, :literal)
    end

    test "consume single symbols" do
      tokens = lexer("( ) + - / *")
      assert_equal %i[( ) + - / * eof], tokens.map(&:type)
    end

    test "invalid char" do
      lexer = Pascalina::Lexer.new("2 ~ 3")
      lexer.tokenize
      assert_equal [[:number, 2], [:BAD_TOKEN, nil], [:number, 3], [:eof, nil]], lexer.tokens.pick(:type, :literal)
      assert_equal 1, lexer.errors.count
    end

    test "consume function calls" do
      tokens = lexer("SUM(1, 2, 3)")
      assert_equal [
        [:identifier, "SUM"],
        [:"(", "("],
        [:number, "1"],
        [:",", ","],
        [:number, "2"],
        [:",", ","],
        [:number, "3"],
        [:")", ")"],
        [:eof, ""]
      ], tokens.pick(:type, :lexeme)
    end
  end
end
