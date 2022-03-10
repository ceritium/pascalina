# frozen_string_literal: true

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect("ast" => "AST")
loader.setup # ready!

module Pascalina
end
