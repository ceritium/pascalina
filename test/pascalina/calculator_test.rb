# frozen_string_literal: true

require "test_helper"

module Pascalina
  class CalculatorTest < Minitest::Test
    def setup
      @calculator = Calculator.new
    end

    test "it works" do
      assert_equal 3, @calculator.evaluate("1 + 2")
    end

    test "register a function with a lambda" do
      @calculator.register_function("SUM", ->(*numbers) { numbers.sum })
      assert_equal 3, @calculator.evaluate("SUM(1,2)")
    end

    # rubocop:disable
    class DummyCallableClass
      def initialize(multiplicator)
        @multiplicator = multiplicator
      end

      def call(*numbers)
        numbers.sum * @multiplicator
      end
    end
    # rubocop:enable

    test "register a function with a instance class" do
      callable = DummyCallableClass.new(2)

      @calculator.register_function("SUM_X", callable)
      assert_equal 6, @calculator.evaluate("SUM_X(1,2)")
    end

    module DummyCalllableModule
      def self.call(*numbers)
        numbers.sum
      end
    end

    test "register a function with a module" do
      @calculator.register_function("SUM", DummyCalllableModule)
      assert_equal 3, @calculator.evaluate("SUM(1,2)")
    end

    test "passing variables" do
      assert_equal 4, @calculator.evaluate("X + 2", "X" => 2)
      assert_equal 3, @calculator.evaluate("X + 2", "X" => 1)
    end

    test "assigned variables persist between evaluations" do
      assert_equal 4, @calculator.evaluate("X + 2", "X" => 2)
      assert_equal 3, @calculator.evaluate("X + 1")
    end

    test "can use variables as params on functions" do
      @calculator.register_function("SUM", ->(*numbers) { numbers.sum })
      assert_equal 3, @calculator.evaluate("SUM(1,X)", "X" => 2)
    end

    test "evaluate! raises Parser::UnrecognizedTokenError" do
      assert_raises Parser::UnrecognizedTokenError do
        @calculator.evaluate!("1 ** 1")
      end
    end

    test "evaluate returns nil when UnrecognizedTokenError" do
      assert_nil @calculator.evaluate("1 ** 1")
    end

    test "evaluate! raises Interpreter::UndefinedVariableError" do
      assert_raises Interpreter::UndefinedVariableError do
        @calculator.evaluate!("A * 1")
      end
    end

    test "evaluate returns nil when Interpreter::UndefinedVariableError" do
      assert_nil @calculator.evaluate("A * 1")
    end
  end
end
