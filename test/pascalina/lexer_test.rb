# frozen_string_literal: true

require "test_helper"

class Pascalina::LexerTest < Minitest::Test

  def lexer(code)
    Pascalina::Lexer.new(code).tokenize
  end

  test "empty code" do
    assert_equal lexer(""), []
  end

  test "ignore whitespace" do
    assert_equal lexer(" "), []
  end

  test "ignore breaklines" do
    assert_equal lexer("
                       "), []
  end

  test "ignore comment" do
    assert_equal lexer("#"), []
  end

  test "a single digit number" do
    tokens = lexer("4")
    assert_equal [4], tokens.map(&:literal)
    assert_equal [:number], tokens.map(&:type)
  end

  test "multiple digit number" do
    tokens = lexer("42")
    assert_equal [42], tokens.map(&:literal)
    assert_equal [:number], tokens.map(&:type)
  end

  test "consume decimals" do
    tokens = lexer("42.5")
    assert_equal [42.5], tokens.map(&:literal)
    assert_equal [:number], tokens.map(&:type)
  end
end
