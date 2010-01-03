# This file is part of RubyPiche.
#
# RubyPiche is copyrighted free software by Daniel Hernández
# (http://www.molinoverde.cl): you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# RubyPiche is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with RubyPiche.  If not, see <http://www.gnu.org/licenses/>.

# RubyPiche is a Ruby parser for Piche, a language like Turtle.

module Piche

  # This class...

  class LexicalParser

    # Creates a parser for a file.
    def initialize(file)
      @file = file
      if @file.class == String
        @i = 0
        @next_char = Proc.new do
          c = @file[@i]
          @i += 1
          c.nil? ? nil : c.chr
        end
        @readline = Proc.new do
          while @file[@i] and @file[@i].chr != "\n"
            @i += 1
          end
        end
      elsif @file.class == File
        @next_char = Proc.new do
          c = @file.getc
          c.nil? ? nil : c.chr
        end
        @readline = Proc.new do
          @file.readline
        end
      end
      @token = ""
      @buffer = []
      @read_literal = Proc.new do
        while (c = @next_char.call)
          if c == '"'
            @buffer << @token
            @token = ""
            break
          else
            @token << c
          end
        end
      end
    end

    # Get the next token.
    def next_token
      while (c = @next_char.call)
        if c == '"'
          @read_literal.call
        elsif "#" == c
          @readline.call
        elsif (/^[|&;,.\s]$/ =~ c) == 0
          unless @token.strip == ""
            @buffer << @token.strip.to_sym
            @token = ""
          end
          unless (/^\s$/ =~ c) == 0
            @buffer << c.to_sym
          end
        else
          @token << c
        end
        return @buffer.shift unless @buffer.empty?
      end
      return nil
    end

    # Iterates over the file tokens.
    def each
      while (token = self.next_token)
        yield token
      end
    end

  end

end
