# frozen_string_literal: true

require_relative "../lib/pascalina"

# **

puts Pascalina::Calculator.new.evaluate("1+1")

calculator = Pascalina::Calculator.new
puts calculator.evaluate("1 ** 1")
# puts calculator.evaluate!("1 ** 1")
puts calculator.evaluate!("A + 1")
