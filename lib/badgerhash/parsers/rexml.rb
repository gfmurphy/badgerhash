require "forwardable"
require "rexml/document"
require "rexml/streamlistener"

module Badgerhash
  module Parsers
    module REXML
      # SaxDocument provides an implmentation of the required
      # public interface for a parser that is to be used when parsing
      # an XmlStream. An implementation is required to provide a parse method
      # that accepts a Badgerhash::Handler::SaxHandler and an IO object.
      # When parsing the given IO stream, it must send messages to the handler
      # in order to build the correct Hash. This also serves as a reference
      # implementation for other sax parsers.
      #
      # @api private
      class SaxDocument
        include ::REXML::StreamListener
        extend Forwardable

        def_delegators :@handler, :text, :cdata
        def_delegator  :@handler, :end_element, :tag_end

        # Parse the given stream and update the handler.
        #
        # @param handler [Badgerhash::Handler::SaxHandler] parsing handler
        # @param io [IO] the XML to be parsed.
        # @return void
        def self.parse(handler, io)
          ::REXML::Document.parse_stream(io, new(handler))
        end

        # Initialize the parser.
        #
        # @param handler [Badgerhash::Handlers::SaxHandler]
        def initialize(handler)
          @handler = handler
        end

        def tag_start(name, attributes=[])
          @handler.start_element name
          Array(attributes).each do |attr|
            @handler.attr(*attr)
          end
        end
      end
    end
  end
end
