module Badgerhash
  class XmlDocument
    # Create a properly initialized Badgerhash::XmlDocument object from the
    # provided xml
    #
    # @param xml [IO, String] an object containing the xml to be parsed
    # @example
    #   io = StringIO.new("<alice>bob</alice>")
    #   Badgerhash::XmlDocument.create(io) => #<XmlDocument:0x007fc004966038>
    # @return [Badgerhash::XmlDocument] the XmlDocument
    # @api public
    def self.create(xml)
      new(Badgerhash::Handlers::DomHandler.new, Badgerhash.dom_parser, xml)
    end

    # The Badgerfish representation of the XML
    #
    # @example
    #  io = StringIO.new("<alice>bob</alice>")
    #  Badgerhash::XmlDocument.create(io).to_badgerfish => {"alice" => {"$" => "bob" }}
    # @return [Hash] the Badgerfish hash
    # @api public
    def to_badgerfish
      @node ||= @handler.process_node(@parser.parse(@xml))
    end

    # Initialize an XmlDocument object
    #
    # @param handler [Badgerhash::Handlers:DomHandler] the handler
    # @param parser [Object] a parser conforming to the required interface
    # @param xml [IO] the xml to be parsed
    def initialize(handler, parser, xml)
      @handler = handler
      @parser  = parser
      @xml     = xml
    end
  end
end
