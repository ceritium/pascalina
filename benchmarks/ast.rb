#!/usr/bin/env ruby
# frozen_string_literal: true

require "bundler/setup"
require "pascalina"
require "benchmark/ips"

code = "X = (1 + 2) * 3
SUM(2 * 2, SUM(2,3,4,5), 5)
"
ast = Pascalina::Calculator.new.generate_ast(code)
marshal_ast = Marshal.dump(ast)

preloaded_calculator = Pascalina::Calculator.new
preloaded_calculator.add_basic_functions

Benchmark.ips do |benchmark|
  benchmark.report("evaluate") do
    calculator = Pascalina::Calculator.new
    calculator.add_basic_functions
    calculator.evaluate(code)
  end

  benchmark.report("marshal evaluate_ast") do
    calculator = Pascalina::Calculator.new
    calculator.add_basic_functions
    calculator.evaluate_ast(Marshal.load(marshal_ast)) # rubocop:disable Security/MarshalLoad
  end

  benchmark.report("direct evaluate_ast") do
    calculator = Pascalina::Calculator.new
    calculator.add_basic_functions
    calculator.evaluate_ast(ast)
  end

  benchmark.report("preloaded") do
    preloaded_calculator.evaluate_ast(ast)
  end

  benchmark.compare!
end
