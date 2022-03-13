# frozen_string_literal: true

module Pascalina
  class Repl
    class << self
      def run
        new.run
      end
    end

    def initialize
      @running = true
      new_interpreter
    end

    def run
      print_help
      while @running
        command = wait_for_command

        process_command(command)
      end
    end

    private

    attr_reader :interpreter

    def new_interpreter
      @interpreter = Pascalina::Interpreter.new
    end

    def process_command(command)
      case command
      when "help"
        print_help
      when "reload"
        new_interpreter
        output("reloaded!")
      when "exit"
        output("bye!")
        @running = false
      else
        lexer = Pascalina::Lexer.new(command)
        parser = Pascalina::Parser.new(lexer.tokenize)
        parser.parse
        output(interpreter.interpret(parser.ast))
      end
    end

    def print_help
      output "Pascalina REPL"
      output "Write `exit` for quite"
      puts
      output "help"
      output "write `exit` for quit"
    end

    def output(string)
      puts "=> #{string}"
    end

    def wait_for_command
      Readline.readline("pascalina> ", true)
    end
  end
end
