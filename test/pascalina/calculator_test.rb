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
  end
end
