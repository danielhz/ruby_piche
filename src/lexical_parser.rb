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
      @token = ""
      @buffer = []
    end

    # Get the next token.
    def next_token
      while (c = @file.getc)
        if "#" == c.chr
          @file.readline
        elsif (/^[|;,.\s]$/ =~ c.chr) == 0
          unless @token.strip == ""
            @buffer << @token.strip.to_sym
            @token = ""
          end
          unless (/^\s$/ =~ c.chr) == 0
            @buffer << c.chr.to_sym
          end
          return @buffer.shift unless @buffer.empty?
        else
          @token << c
        end
      end
      return nil
    end

    def each
      while (token = self.next_token)
        yield token
      end
    end

  end

end
