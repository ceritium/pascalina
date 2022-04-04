# frozen_string_literal: true

require "readline"
require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect("ast" => "AST")
loader.setup # ready!

module Pascalina
  def self.run_prompt
    Pascalina::Repl.run
  end

  def self.run_file(file_path)
    code = File.read(file_path)
    puts Pascalina::Calculator.new.evaluate!(code)
  end
end
