# frozen_string_literal: true

module Pascalina
  class Lexer
    BREAK_LINE = "\n"
    COMMENT = "#"
    WHITESPACE = [" ", "\r", "\t"].freeze
    SINGLE_SYMBOLS = ["=", "(", ")", "+", "-", "/", "*"].freeze

    attr_reader :source, :tokens

    def initialize(source)
      @source = source
      @tokens = []
      @line = 0
      @next_p = 0
      @lexeme_start_p = 0
    end

    def tokenize
      parse_next_token while source_uncompleted?

      tokens
    end

    private

    attr_accessor :line, :next_p, :lexeme_start_p

    def parse_next_token
      self.lexeme_start_p = next_p

      char = consume
      return if WHITESPACE.include?(char)
      return ignore_comment_line if char == COMMENT

      if char == BREAK_LINE
        if tokens.last&.type != Token::BREAK_LINE
          # Only adds one break line
          tokens << Token.new(Token::BREAK_LINE, char, nil, current_location)
        end
        self.line += 1
        return
      end

      token = case char
              when *SINGLE_SYMBOLS
                token_from_single_char(char)
              else
                consume_number if digit?(char)
              end

      raise "Error" unless token

      tokens << token
    end

    def token_from_single_char(char)
      # TODO: avoid to to_sym
      Token.new(char.to_sym, char, nil, current_location)
    end

    def ignore_comment_line
      consume while lookahead != BREAK_LINE && source_uncompleted?
    end

    ## Identify chars

    def digit?(char)
      char >= "0" && char <= "9"
    end

    ## Consumers

    def consume_number
      consume_digits

      # Check if is a decimal number
      if lookahead(1) == "." && digit?(lookahead(2))
        consume # consume the '.'
        consume_digits # consume the decimal part
      end

      lexeme = source[lexeme_start_p..(next_p - 1)]
      Token.new(:number, lexeme, lexeme.to_f, current_location)
    end

    def consume_digits
      consume while digit?(lookahead)
    end

    def consume
      c = lookahead
      self.next_p += 1
      c
    end

    def current_location
      Location.new(line, lexeme_start_p, next_p - lexeme_start_p)
    end

    ## Move in the source

    def lookahead(offset = 1)
      lookahead_p = (next_p - 1) + offset
      return "\0" if lookahead_p >= source.length

      source[lookahead_p]
    end

    ## Limits

    def source_completed?
      next_p >= source.length # our pointer starts at 0, so the last char is length - 1.
    end

    def source_uncompleted?
      !source_completed?
    end
  end
end
