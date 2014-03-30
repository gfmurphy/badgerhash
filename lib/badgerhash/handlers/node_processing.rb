module Badgerhash
  module Handlers
    module NodeProcessing
      # Add an attribute to a node Hash using the Badgerfish rules
      #
      # @param node [Hash] the node
      # @param name [String] the name (or key) of the attribute
      # @param value [Object] the value of the attribute
      # @return [Hash] the updated node
      # @api private
      def add_attribute(node, name, value)
        name = name.to_s
        if name =~ /^xmlns(:?(.*))/i
          key = $2.to_s.length > 0 ? $2 : "$"
          (node["@xmlns"] ||= {})[key] = value
        else
          node["@#{name}"] = value
        end
        node
      end

      # Update the given node's value using the Badgerfish rules
      #
      # @param node [Hash] the node to update
      # @param name [String] the name (or key) of the node value to update
      # @param value [Object] the value of the node
      # @return [Hash] the updated node
      # @api private
      def update_node(node, name, value)
        node[name] = case node[name]
                     when nil
                       value
                     when Hash
                       [node[name], value]
                     else
                       node[name] << value
                     end
        node
      end
    end
  end
end
