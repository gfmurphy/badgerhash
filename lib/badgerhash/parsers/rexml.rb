require "forwardable"
require "rexml/document"
require "rexml/streamlistener"

module Badgerhash
  module Parsers
    module REXML
      class SaxDocument
        include ::REXML::StreamListener
        extend Forwardable

        def_delegators :@handler, :text, :cdata
        def_delegator  :@handler, :end_element, :tag_end

        def self.parse(handler, io)
          ::REXML::Parsers::StreamParser.new(io, new(handler)).parse
        end

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
