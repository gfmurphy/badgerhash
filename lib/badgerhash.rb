require "badgerhash/handlers/sax_handler"
require "badgerhash/parsers/rexml"
require "badgerhash/version"
require "badgerhash/xml_stream"

# Convert XML to Ruby Hash using Badgerfish convention: http://badgerfish.ning.com/
# @api public
module Badgerhash
  # Class of the default sax parser implementation
  DEFAULT_SAX_PARSER = Parsers::REXML::SaxDocument

  # Set the sax parser for the module
  #
  # @param parser [Class] a parser that supports the required interface
  # @see Parsers::REXML::SaxDocument for the reference implementation
  # @example
  #   Badgerhash.sax_parser = MyFastParser => MyFastParser
  # @return [Class] the new parser class
  def self.sax_parser=(parser)
    @sax_parser = parser
  end

  # The current sax parser implementation
  #
  # @example
  #   Badgerhash.sax_parser => Parsers::REXML::SaxDocument
  # @return [Class] the current sax parser implementation
  def self.sax_parser
    @sax_parser || DEFAULT_SAX_PARSER
  end
end
