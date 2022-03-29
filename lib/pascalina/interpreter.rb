# frozen_string_literal: true

module Pascalina
  class Interpreter
    class UndefinedVariableError < Error
      attr_reader :name

      def initialize(name)
        @name = name
        message = "Undefined variable `#{name}`"
        super(message)
      end
    end

    attr_reader :program, :output, :context, :call_stack
    attr_accessor :unwind_call_stack

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

    def interpret_var_binding(var_binding)
      context.variable_registry[var_binding.left.name] = var_binding.right.value
    end

    def interpret_function_call(fn_call)
      Interpreter::FunctionCall.new(fn_call, self).call
    end

    def interpret_identifier(identifier)
      value = context.variable_registry[identifier.name]
      raise UndefinedVariableError, identifier.name unless value

      value
    end
  end
end
