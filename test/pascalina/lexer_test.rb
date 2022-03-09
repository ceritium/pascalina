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
      assert_equal lexer(""), []
    end

    test "ignore whitespace" do
      assert_equal lexer(" "), []
    end

    test "single breakline" do
      tokens = lexer("
                   ")
      assert_equal [Pascalina::Token::BREAK_LINE], tokens.map(&:type)
    end

    test "consecutive breaklines" do
      tokens = lexer("

                   ")

      assert_equal [Pascalina::Token::BREAK_LINE], tokens.map(&:type)
    end

    test "ignore comment" do
      assert_equal lexer("#"), []
    end

    test "a single digit number" do
      tokens = lexer("4")
      assert_equal [[:number, 4]], tokens.pick(:type, :literal)
    end

    test "multiple digit number" do
      tokens = lexer("42")
      assert_equal [[:number, 42]], tokens.pick(:type, :literal)
    end

    test "consume decimals" do
      tokens = lexer("42.5")
      assert_equal [[:number, 42.5]], tokens.pick(:type, :literal)
    end

    test "consume negative numbers" do
      tokens = lexer("-42.5")
      assert_equal [[:-, nil], [:number, 42.5]], tokens.pick(:type, :literal)
    end

    test "consume single symbols" do
      tokens = lexer("= ( ) + - / *")
      assert_equal %i[= ( ) + - / *], tokens.map(&:type)
    end
  end
end
