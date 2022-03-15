# frozen_string_literal: true

module Pascalina
  class Context
    attr_reader :function_registry, :variable_registry

    def initialize
      @function_registry = {}
      @variable_registry = {}
    end
  end
end
