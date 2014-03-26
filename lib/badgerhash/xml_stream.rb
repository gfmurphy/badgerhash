module Badgerhash
  class XmlStream
    def self.create
      new(Handlers::SaxHandler.new, Badgerhash.sax_parser)
    end

    def to_badgerfish(io)
      @parser.parse(@handler, io)
      @handler.node
    end

    def initialize(handler, parser)
      @handler = handler
      @parser  = parser
    end
  end
end
