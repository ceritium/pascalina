# frozen_string_literal: true
require "readline"
require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect("ast" => "AST")
loader.setup # ready!

module Pascalina
  def self.run_prompt
    interpreter = Pascalina::Interpreter.new
    while buf = Readline.readline("> ", true)
      begin
        puts "=> #{run(buf, interpreter: interpreter)}"
      rescue => e
        puts e.backtrace
        puts e.message
      end
    end
  end

  def self.run(source, interpreter: nil)
    lexer = Pascalina::Lexer.new(source)
    parser = Pascalina::Parser.new(lexer.tokenize)
    interpreter ||= Pascalina::Interpreter.new
    parser.parse
    puts parser.errors

    interpreter.interpret(parser.ast)
  end
end
