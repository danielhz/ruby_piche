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

require 'lib/lexical_parser.rb'

TOKENS = [
  :"@subject",
  :"=PersonaNatural", :"|", :"=PersonaJurídica", :"+rut", :"$rut", :".",
  :"=PersonaNatural", :"+nombres", :"&", :"+apellidoPaterno", :"&", :"+apellidoMaterno", :"$texto", :".",
  :"=PersonaJurídica", :"+razónSocial", :"$texto", :";", :"+socio", :"=PersonaNatural", :",", :"=PersonaJurídica", :".",
  :"=ContrataciónHonorarios", :"|", :"=ContrataciónPlanta", :"|", :"=ContrataciónCódigoTrabajo",
  :"+contratado", :"=PersonaNatural", :";",
  :"+región", :"=Región", :";",
  :"+observaciones", :"$texto", :".",
  :"=ContrataciónHonorarios", :"+descripción", :"$texto", :".",
  :"=ContrataciónPlanta", :"|", :"=ContrataciónCódigoTrabajo", :"+cargo", :"=Cargo", :".",
  :"=ContrataciónHonorarios", :"|", :"=ContrataciónCódigoTrabajo", :"|", :"=RemuneracionesSegúnGrado",
  :"+gradoEUS", :"$gradoEUS", :";",
  :"+unidadMonetaria", :"$unidadMonetaria", :";",
  :"+montoMensual", :"$número", :".",
  :"=ContrataciónPlanta", :"+remuneraciones", :"=RemuneracionesSegúnGrado", :".",
  :"=RemuneracionesSegúnGrado", :"+estamento", :"$estamento", :".",
  :"=ContrataciónAdquisición", :"+contratado", :"=PersonaNatural", :",", :"=PersonaJurídica", :";",
  :"+unidadMonetaria", :"$unidadMonetaria", :";",
  :"+montoTotal", :"$número", :";",
  :"+actoNormativo", :"=Normativa", :".",
  :"id001", :"+typeof", :"=PersonaNatural", :";",
  :"+names", "Juan Rodrigo", :";",
  :"+apellidoPaterno", "Morales", :";",
  :"+apellidoMaterno", "Ramírez", :".",
  nil
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
