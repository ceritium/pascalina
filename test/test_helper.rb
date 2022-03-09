# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "pascalina"

require "minitest/autorun"

require "support/test_macro"
require "support/pick_array"

Minitest::Test.class_eval do
  extend TestMacro
end
