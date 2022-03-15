# frozen_string_literal: true

module Pascalina
  class Interpreter
    attr_reader :program, :output, :context, :call_stack, :unwind_call_stack

    def initialize(context = Context.new)
      @output = []
      @call_stack = []
      @unwind_call_stack = -1
      @context = context
    end

    def interpret(ast)
      @program = ast

      interpret_nodes(program.expressions)
    end

    private

    attr_writer :unwind_call_stack

    def interpret_nodes(nodes)
      last_value = nil

      nodes.each do |node|
        last_value = interpret_node(node)

        return last_value if unwind_call_stack == call_stack.length

        # We returned from the function, so we reset the "unwind indicator".
        self.unwind_call_stack = -1
      end

      last_value
    end

    def interpret_node(node)
      interpreter_method = "interpret_#{node.type}"
      send(interpreter_method, node)
    end

    # TODO: Is this implementation REALLY the most straightforward in Ruby (apart from using eval)?
    def interpret_unary_operator(unary_op)
      case unary_op.operator
      when :'-'
        -interpret_node(unary_op.operand)
      else # :'!'
        !interpret_node(unary_op.operand)
      end
    end

    def interpret_binary_operator(binary_op)
      interpret_node(binary_op.left).send(binary_op.operator, interpret_node(binary_op.right))
    end

    def interpret_number(number)
      number.value
    end

    def interpret_function_call(function_call)
      fn_name = function_call.name
      fn_def = context.function_registry[fn_name]

      raise "Undefined function #{fn_name}" unless fn_def

      check_arity!(function_call, fn_def)

      args = function_call.args.map do |arg|
        interpret_node(arg)
      end

      fn_def.call(*args)
    end

    def check_arity!(function_call, fn_def)
      arity = if fn_def.is_a?(Proc)
                fn_def.arity
              else
                fn_def.method(:call).arity
              end

      args_count = function_call.args.count

      # -1 means any number
      return unless arity >= 0 && (arity != args_count)

      raise "`#{function_call.name}`: wrong number of args (given #{args_count}, expected #{arity}})"
    end
  end
end
