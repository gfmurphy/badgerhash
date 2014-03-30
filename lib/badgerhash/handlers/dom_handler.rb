require "badgerhash/handlers/node_processing"

module Badgerhash
  module Handlers
    # DomHandler builds the badgerfish Hash from provided xml nodes
    # @api public
    class DomHandler
      include Handlers::NodeProcessing

      # Initialize the Dom Handler
      #
      # @api private
      def initialize
      end

      # Convert the given node to a badgerfish Hash
      #
      # @param xml_node [Object] the xml_node to be processed.
      def process_node(xml_node, namespaces={})
        namespaces = Hash[Array(namespaces)]
        node = {}
        node.merge! "@xmlns" => namespaces unless namespaces.empty?

        node = xml_node.attributes.reduce(node) { |node, attribute|
          add_attribute(node, *attribute)
        }

        xml_node.children.reduce(node) do |node, child|
          if child.text?
            key, value = "$", child.text
          else
            key, value = child.name, process_node(child,
              node.fetch("@xmlns", {}))
          end

          node = update_node(node, key, value)
        end
      end
    end
  end
end
