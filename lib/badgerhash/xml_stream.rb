module Badgerhash
  class XmlStream
    def self.create(io)
      new(Handlers::SaxHandler.new, Badgerhash.sax_parser, io)
    end

    def to_badgerfish
      @parser.parse(@handler, @io)
      @handler.node
    end

    def initialize(handler, parser, io)
      @handler = handler
      @parser  = parser
      @io      = io
    end
  end
end
