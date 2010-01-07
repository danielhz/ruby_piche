require 'lib/lexical_parser.rb'

module Piche

  # The GrammaticalParser class give us iterators to the
  # piche grammatic and can be used in many ways, particulary
  # to build an Graph with and index to perform queries.
  # 
  # For example, the next code can generate the output below:
  #
  #   s = '@subj a | b c & d e , f ; g h . a i h .'
  #   parser = GramaticalParser.new s
  # 
  #   parser.each do |sentence|
  #     unless Symbol === sentence
  #       print "( ( "
  #       sentence.next_component.each { |atom| print "#{atom} " }
  #       print ") ( "
  #       sentence.next_component.each do |pair|
  #         print "( ( "
  #         pair.next_component.each { |atom| print "#{atom} " }
  #         print ") ( "
  #         pair.next_component.each { |atom| print "#{atom} " }
  #         print ") ) "
  #       end
  #       print ") )\n"
  #     else
  #       print "#{sentence.value}\n"
  #     end
  #   end
  #
  # Output to de code above:
  #
  #   @subj
  #   ( ( a b ) ( ( ( c d ) ( e f ) ) ( ( g ) ( h ) ) ) )
  #   ( ( a ) ( ( ( i ) ( h ) ) ) )

  class GrammaticalParser

    SEPS = [:'|', :'&', :',', :';', :'.']
    MODULES = [:'@subj', :'@pred', :'@obj']

    attr_accessor :buffer

    def initialize(input)
      @tokenizer = Piche::LexicalParser.new input
      @module = :'@subj'
      @buffer = []
    end

    def next_token
      @buffer.shift || @tokenizer.next_token
    end

    # A parser for sequences of values like a1 & a2 & ... & aN
    class SequenceParser

      # Initialize a new sequence parser.
      def initialize(parser, sep, proc = nil)
        @parser = parser
        @sep = sep
        if proc.nil?
          @proc = Proc.new do
            token = @parser.next_token
            if token.nil? or MODULES.include? token or SEPS.include? token
              raise "spected identifier, got #{token.inspect}"
            end
            token
          end
        else
          @proc = proc
        end
      end

      # Iterates over the sequence items.
      def each
        yield item = @proc.call
        while (token = @parser.next_token)
          if token == @sep
            item = @proc.call
            if item.nil?
              raise "spected sub-component, got nil"
            end
            yield item
          else
            @parser.buffer << token
            break
          end
        end
      end
      
    end

    # A parser for the last two components of a triple.
    class PairParser
      def initialize(parser)
        @parser = parser
        @step = 0
      end

      def next_component
        case @step
        when 0
          comp = SequenceParser.new @parser, :'&'
          @step += 1
        when 1
          comp = SequenceParser.new @parser, :','
          @step += 1
        else
          comp = nil
        end
        comp
      end
    end

    # Represents a structure that code triples.
    class TripleParser
      def initialize(parser)
        @parser = parser
        @step = 0
        @pair_parser = PairParser.new @parser
      end

      def next_component
        case @step
        when 0
          comp = SequenceParser.new @parser, :'|'
          @step += 1
        when 1
          proc = Proc.new { PairParser.new(@parser) }
          comp = SequenceParser.new @parser, :';', proc
          @step += 1
        else
          nil
        end
        comp
      end
    end

    # Iterates over sentences
    def each
      while (token = self.next_token)
        if MODULES.include? token
          yield token
        else
          @buffer << token
          yield TripleParser.new self
          unless self.next_token == :"."
            raise 'expected :"."'
          end
        end
      end
    end

  end

end
