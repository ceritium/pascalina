# frozen_string_literal: true

module Pascalina
  class Parser
    attr_accessor :tokens, :ast, :errors

    EXPRESSION_TOKENS = [
      Token::NUMBER
    ].freeze

    BINARY_OPERATORS = [
      Token::PLUS,
      Token::MINUS,
      Token::STAR,
      Token::SLASH
    ].freeze

    LOWEST_PRECEDENCE = 0
    PREFIX_PRECEDENCE = 7
    OPERATOR_PRECEDENCE = {
      Token::PLUS => 5,
      Token::MINUS => 5,
      Token::STAR => 6,
      Token::SLASH => 6,
      Token::LPAREN => 8
    }.freeze

    def initialize(tokens)
      @tokens = tokens
      @ast = Pascalina::AST::Program.new
      @next_p = 0
      @errors = []
    end

    def parse
      while pending_tokens?
        consume

        node = parse_expr_recursively
        ast << node unless node.nil?
      end

      ast
    end

    private

    attr_accessor :next_p

    def build_token(type, lexeme = nil)
      Token.new(type, lexeme, nil, nil)
    end

    # Parsers

    def parse_expr_recursively(precedence = LOWEST_PRECEDENCE)
      parsing_function = determine_parsing_function
      if parsing_function.nil?
        unrecognized_token_error
        return
      end

      expr = send(parsing_function)
      return if expr.nil? # When expr is nil, it means we have reached a \n or a eof.

      # Note that here we are checking the NEXT token.
      while !end_of_line?(current) && precedence < nxt_precedence
        infix_parsing_function = determine_infix_function(nxt)

        return expr if infix_parsing_function.nil?

        consume
        expr = send(infix_parsing_function, expr)
      end

      expr
    end

    def parse_grouped_expr
      consume

      expr = parse_expr_recursively

      # me...
      return unless consume_if_nxt_is(build_token(:')', ")"))

      expr
    end

    def parse_binary_operator(left)
      op = AST::BinaryOperator.new(current.type, left)
      op_precedence = current_precedence

      consume
      op.right = parse_expr_recursively(op_precedence)

      op
    end

    def parse_number
      AST::Number.new(current.literal)
    end

    def parse_terminator
      nil
    end

    def determine_parsing_function
      if current.is?(*EXPRESSION_TOKENS)
        "parse_#{current.type}".to_sym
      elsif current.is?(Token::LPAREN)
        :parse_grouped_expr
      elsif end_of_line?(current)
        :parse_terminator
      end
    end

    def determine_infix_function(token = current)
      :parse_binary_operator if token.is?(*BINARY_OPERATORS)
    end

    # Consume helpers

    def consume(type = nil)
      return advance if type.nil? || check(*type)

      unexpected_token_error(type) if type
    end

    def consume_if_nxt_is(expected)
      if nxt.type == expected.type
        consume
        true
      else
        unexpected_token_error(expected)
        false
      end
    end

    def advance
      self.next_p += 1 unless at_end?
      previous
    end

    def previous
      lookahead(-1)
    end

    def current
      lookahead(0)
    end

    def nxt
      lookahead
    end

    def end_of_line?(token)
      token.is?(Token::BREAK_LINE) || at_end?
    end

    def current_precedence
      OPERATOR_PRECEDENCE[current.type] || LOWEST_PRECEDENCE
    end

    def nxt_precedence
      OPERATOR_PRECEDENCE[nxt.type] || LOWEST_PRECEDENCE
    end

    def lookahead(offset = 1)
      lookahead_p = (next_p - 1) + offset
      return nil if lookahead_p.negative? || lookahead_p >= tokens.length

      tokens[lookahead_p]
    end

    def pending_tokens?
      next_p < tokens.length
    end

    def at_end?
      current&.is?(Token::EOF)
    end
  end
end
