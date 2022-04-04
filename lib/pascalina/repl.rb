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
      new_calculator
    end

    def run
      print_help
      while @running
        command = wait_for_command

        process_command(command)
      end
    end

    private

    attr_reader :calculator

    def new_calculator
      @calculator = Pascalina::Calculator.new
    end

    def process_command(command)
      case command
      when "help"
        print_help
      when "reload"
        new_calculator
        output("reloaded!")
      when "exit"
        output("bye!")
        @running = false
      else
        evaluate(command)
      end
    end

    def evaluate(command)
      output calculator.evaluate!(command)
    rescue Pascalina::Error => e
      output(e)
    end

    def print_help
      output "Pascalina REPL"
      output "Write `exit` for quit"
    end

    def output(string)
      puts "=> #{string}"
    end

    def wait_for_command
      Readline.readline("pascalina> ", true)
    end
  end
end
