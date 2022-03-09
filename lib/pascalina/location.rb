# frozen_string_literal: true

module Pascalina
  Location = Struct.new(:line, :col, :source_length) do
    alias_method :length, :source_length
    def ==(other)
      line == other.line &&
        col == other.col &&
        source_length == other.source_length
    end
  end
end
