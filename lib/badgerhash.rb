require "badgerhash/parsers/nokogiri"
require "badgerhash/version"

module Badgerhash
  DEFAULT_SAX_PARSER = Parsers::Nokogiri::SaxDocument

  def self.sax_parser=(parser)
    @@sax_parser = parser
  end

  def self.sax_parser
    @@sax_parser || DEFAULT_SAX_PARSER
  end
end
