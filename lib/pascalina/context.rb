# frozen_string_literal: true

module Pascalina
  class Context
    attr_reader :function_registry, :variable_registry

    def initialize
      @function_registry = {}
      @variable_registry = {}
    end

    def register_vars(vars = {})
      vars.each_pair do |k, v|
        variable_registry[k] = v
      end
    end
  end
end
