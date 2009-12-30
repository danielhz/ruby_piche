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

require 'src/lexical_parser.rb'

TOKENS = [
  :"PersonaNatural", :"rut", :"rut", :";",
  :"nombres", :"texto", :";",
  :"apellidoPaterno", :"texto", :";",
  :"apellidoMaterno", :"texto", :".",
  :"PersonaJurídica", :"rut", :"rut", :";",
  :"razónSocial", :"texto", :".",
  :"ContrataciónHonorarios", :"|",
  :"ContrataciónPlanta", :"|",
  :"ContrataciónCódigoTrabajo", :"contratado", :"PersonaNatural", :";",
  :"función", :"texto", :";",
  :"región", :"Región", :";",
  :"observaciones", :"texto", :".",
  :"ContrataciónHonorarios", :"|",
  :"ContrataciónCódigoTrabajo", :"|",
  :"RemuneracionesSegúnGrado", :"grado", :"gradoEUS", :";",
  :"unidadMonetaria", :"unidadMonetaria", :";",
  :"montoMensual", :"número", :".",
  :"ContrataciónPlanta", :"remuneraciones", :"RemuneracionesSegúnGrado",
  :".",
  :"RemuneracionesSegúnGrado", :"estamento", :"estamento", :".",
  :"ContrataciónAdquisición", :"contratado", :"PersonaNatural", :",",
  :"PersonaJurídica", :";",
  :"unidadMonetaria", :"unidadMonetaria", :";",
  :"montoTotal", :"número", :";",
  :"actoNormativo", :"Normativa", :".", nil
]

describe 'Lexical Parser' do

  it 'should get the correct token for the file' do
    file = File.new 'test/fixture.piche'
    parser = Piche::LexicalParser.new file

    TOKENS.each do |token|
      parser.next_token.should == token
    end
  end

  it 'should get the correct token for the file' do
    file = File.new 'test/fixture.piche'
    parser = Piche::LexicalParser.new file

    t = 0
    parser.each do |token|
      token.should == TOKENS[t]
      t += 1
    end
  end

end
