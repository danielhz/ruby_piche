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

require 'lib/grammatical_parser.rb'

describe Piche::GrammaticalParser do

  it 'should parse a piche string' do
    input = '@subj a | b | j c & d e , f ; g h . a i h .'
    spected = "@subj\n( ( a b j ) ( ( ( c d ) ( e f ) ) ( ( g ) ( h ) ) ) )\n( ( a ) ( ( ( i ) ( h ) ) ) )\n"
    output = ""

    parser = Piche::GrammaticalParser.new input

    parser.each do |sentence|
      unless Symbol === sentence
        output << "( ( "
        sentence.next_component.each { |atom| output << "#{atom} " }
        output << ") ( "
        sentence.next_component.each do |pair|
          output << "( ( "
          pair.next_component.each { |atom| output << "#{atom} " }
          output << ") ( "
          pair.next_component.each { |atom| output << "#{atom} " }
          output << ") ) "
        end
        output << ") )\n"
      else
        output << "#{sentence}\n"
      end
    end

    output.should == spected
  end

end
