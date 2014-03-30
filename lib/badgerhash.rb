require "badgerhash/handlers/dom_handler"
require "badgerhash/handlers/sax_handler"
require "badgerhash/parsers/rexml"
require "badgerhash/xml_document"
require "badgerhash/xml_stream"
require "badgerhash/version"


# Convert XML to Ruby Hash using Badgerfish convention: http://badgerfish.ning.com/
# @api public
module Badgerhash
  # The default sax parser implementation
  DEFAULT_SAX_PARSER = Parsers::REXML::StreamParser

  # The default dom parser implementation
  DEFAULT_DOM_PARSER = Parsers::REXML::DocumentParser

  # Set the sax parser for the module
  #
  # @param parser [Object] a parser that supports the required interface
  # @see Parsers::REXML::StreamParser for the reference implementation
  # @example
  #   Badgerhash.sax_parser = MyFastParser => MyFastParser
  # @return [Object] the new parser class
  def self.sax_parser=(parser)
    @sax_parser = parser
  end

  # The current sax parser implementation
  #
  # @example
  #   Badgerhash.sax_parser => Parsers::REXML::StreamParser
  # @return [Object] the current sax parser implementation
  def self.sax_parser
    @sax_parser || DEFAULT_SAX_PARSER
  end

  # Set the dom parser for the module
  #
  # @param parser [Object] a parser that supports the required interface
  # @see Parsers::REXML::DocumentParser for the reference implementation
  # @example
  #   Badgerhash.dom_parser = MyFastParser => MyFastParser
  # @return [Object] the new parser
  def self.dom_parser=(parser)
    @dom_parser = parser
  end

  # The current dom parser implementation
  #
  # @example
  #   Badgerhash.dom_parser => Parsers::REXML::DocumentParser
  # @return [Object] the current dom parser implementation
  def self.dom_parser
    @dom_parser || DEFAULT_DOM_PARSER
  end
end
