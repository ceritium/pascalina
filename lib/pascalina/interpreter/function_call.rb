# frozen_string_literal: true

module Pascalina
  class Interpreter
    class FunctionCall
      module FunctionCallHelpers
        def fn_name
          @fn_name ||= fn_call.name
        end

        def fn_def
          @fn_def ||= interpreter.context.function_registry[fn_name]
        end

        def call_args_count
          @call_args_count ||= fn_call.args.count
        end

        def fn_def_arity
          @fn_def_arity ||= if fn_def.is_a?(Proc)
                              fn_def.arity
                            else
                              fn_def.method(:call).arity
                            end
        end
      end

      include FunctionCallHelpers

      class FunctionCallError < Pascalina::Error
        include FunctionCallHelpers
        attr_reader :fn_call, :fn_def

        def initialize(fn_call, fn_def)
          @fn_call = fn_call
          @fn_def = fn_def

          super(message)
        end
      end

      class WrongNumberArgsError < FunctionCallError
        def message
          "`#{fn_call.name}`: wrong number of args (given #{call_args_count}, expected #{fn_def_arity})"
        end
      end

      class UndefinedFunctionError < FunctionCallError
        def message
          "Undefined function `#{fn_call.name}`"
        end
      end

      attr_reader :fn_call, :interpreter

      def initialize(fn_call, interpreter)
        @fn_call = fn_call
        @interpreter = interpreter
      end

      def call
        check_fn_def!
        check_arity!

        args = fn_call.args.map do |arg|
          interpreter.interpret_node(arg)
        end

        fn_def.call(*args)
      end

      private

      def check_fn_def!
        raise UndefinedFunctionError.new(fn_call, fn_def) unless fn_def
      end

      def check_arity!
        # -1 means any number
        return unless fn_def_arity >= 0 && (fn_def_arity != call_args_count)

        raise WrongNumberArgsError.new(fn_call, fn_def)
      end
    end
  end
end
