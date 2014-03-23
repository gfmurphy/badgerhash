require "forwardable"
require "nokogiri"

module Badgerhash
  module Parsers
    module Nokogiri
      class Document < ::Nokogiri::XML::SAX::Document
        extend Forwardable

        def_delegator :@handler, :text, :characters
        def_delegator :@handler, :text, :cdata_block
        def_delegator :@handler, :end_element

        def self.parse(handler, io)
          ::Nokogiri::XML::SAX::Parser.new(new(handler)).parse(io)
        end

        def initialize(handler)
          @handler = handler
        end

        def start_element(name, attributes=[])
          @handler.start_element name
          Array(attributes).each do |attr|
            @handler.attr(*attr)
          end
        end
      end
    end
  end
end
