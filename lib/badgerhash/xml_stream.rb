module Badgerhash
  # Converts XML as IO to a Badgerfish Hash using a stream parser
  class XmlStream
    # Create a properly initialized Badgerhash::XmlStream object
    #
    # @param xml [IO, String] an object containing the XML to be parsed
    # @example
    #   io = StringIO.new("<alice>bob</alice>")
    #   Badgerhash::XmlStream.create(io)
    # @return [Badgerhash::XmlStream] the XmlStream
    # @api public
    def self.create(xml)
      new(Handlers::SaxHandler.new, Badgerhash.sax_parser, xml)
    end

    # The Badgerfish representation of the XML
    #
    # @example
    #  io = StringIO.new("<alice>bob</alice>")
    #  Badgerhash::XmlStream.create(io).to_badgerfish => {"alice" => {"$" => "bob" }}
    # @return [Hash] the Badgerfish hash
    # @api public
    def to_badgerfish
      @parser.parse(@handler, @xml)
      @handler.node.dup
    end

    # Initialize an XmlStream object.
    #
    # @param handler [Badgerhash::Handlers::SaxHandler] the handler
    # @param parser  [Object] a parser conforming to the required interface
    # @param xml [IO] object containing the XML to be parsed.
    # @api private
    def initialize(handler, parser, xml)
      @handler = handler
      @parser  = parser
      @xml     = xml
    end
  end
end
