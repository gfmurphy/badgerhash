require "badgerhash/handlers/node_processing"

module Badgerhash
  module Handlers
    # SaxHandler that is passed to a sax parser implementation
    # @api public
    class SaxHandler
      include Handlers::NodeProcessing

      attr_reader :node

      # Initialize the SaxHandler
      #
      # @param node [Hash] Used to preinitialzie the internal node.
      # @api private
      def initialize(node={})
        @parents = []
        @node = node
      end

      # Sends message to handler that a new element was encountered in
      # stream
      #
      # @param name [String] the name of the new element
      #
      # @example
      #  handler.start_element "foo" => handler
      # @return [SaxHandler]
      def start_element(name)
        name = name.to_s
        element = node_namespaces

        @node = update_node(@node, name, element)

        @parents << @node
        @node = element
        self
      end

      # Sends message to handler that an attribute was encountered in
      # the stream
      #
      # @param name [String] the name of the attribute
      # @param value [String] the attribute's value
      # @example
      #   handler.attr "foo", "bar"  => handler
      # @return [SaxHandler]
      def attr(name, value)
        @node = add_attribute(@node, name, value)
        self
      end

      # Sends a message to handler that a text node or cdata section
      # was found in the stream
      #
      # @param value [String] the text encountered
      # @example
      #   handler.text "this is my text node" => handler
      # @return [SaxHandler]
      def text(value)
        value = value.to_s.strip
        @node["$"] = value unless value.empty?
        self
      end

      alias :cdata :text

      # Sends a message to the handler that the end of an element has
      # been found in the stream
      #
      # @param name [String] the name of the element
      # @example
      #   handler.end_element "foo" => handler
      # @return [SaxHandler]
      def end_element(name)
        @node = @parents.pop || {}
        self
      end

      private
      def node_namespaces
        ns = @node.fetch("@xmlns", {})
        ns.size > 0 ? { "@xmlns" => ns } : {}
      end
    end
  end
end
