require "forwardable"
require "rexml/document"
require "rexml/streamlistener"

module Badgerhash
  module Parsers
    module REXML
      # DocumentParser provides an implmentation of the required
      # public interface for a parser that is to be used when parsing
      # an XmlDocument. An implementation is required to provide a parse method
      # that accepts XML as a String, IO or Document and returns an XmlNode
      # that provides the required interface to the DomHandler#process_node.
      #
      # @see Badgerhash::Handlers::DomHandler
      # @api private
      class DocumentParser
        # Parse the given stream into an XmlNode
        #
        # @param xml [String, XML, Document] the XML to be parsed
        # @return [DocumentParser::XmlNode] the parsed node
        def self.parse(xml)
          XmlNode.new ::REXML::Document.new(xml, compress_whitespace: :all)
        end

        # The XmlNode provides information about the encapsulated
        # the REXML::Element via a standard interface.
        #
        # @api private
        class XmlNode
          extend Forwardable

          def_delegator :@doc, :value, :text
          def_delegator :@doc, :expanded_name, :name

          # Initialize the XmlNode
          #
          # @param rexml_document [REXML::Element] the encapsulated element
          def initialize(rexml_document)
            @doc = rexml_document
          end

          # The child nodes for the given element
          #
          # @return [Array] an array of child XmlNodes
          def children
            @children ||= @doc.children.map { |node| XmlNode.new(node) }
          end

          # The attributes on the node
          #
          # @return [Hash] the attributes on the element
          def attributes
            @attributes ||= @doc.attributes.reduce({}) { |attr, value|
              name, value = *value
              attr[name] = value
              attr
            }
          end

          # Indicates that the node is a text or cdata element
          #
          # @return [TrueClass, FalseClass]
          def text?
            @doc.node_type == :text
          end
        end
      end

      # StreamParser provides an implmentation of the required
      # public interface for a parser that is to be used when parsing
      # an XmlStream. An implementation is required to provide a parse method
      # that accepts a Badgerhash::Handlers::SaxHandler and an IO object.
      # When parsing the given IO stream, it must send messages to the handler
      # in order to build the correct Hash. This also serves as a reference
      # implementation for other sax parsers.
      #
      # @see Badgerhash::Handlers::SaxHandler
      # @api private
      class StreamParser
        include ::REXML::StreamListener
        extend Forwardable

        def_delegators :@handler, :text, :cdata
        def_delegator  :@handler, :end_element, :tag_end

        # Parse the given stream and update the handler.
        #
        # @param handler [Badgerhash::Handler::SaxHandler] parsing handler
        # @param xml [String, IO] the XML to be parsed.
        # @return void
        def self.parse(handler, xml)
          ::REXML::Document.parse_stream(xml, new(handler))
        end

        # Initialize the parser.
        #
        # @param handler [Badgerhash::Handlers::SaxHandler]
        def initialize(handler)
          @handler = handler
        end

        # Tell the handler that a new tag has been encountered in the stream
        #
        # @param name [String] the name of the attribute
        # @param attributes [Array] an Array of tag attributes
        # @return void
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
