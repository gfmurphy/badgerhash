module Badgerhash
  module Handlers
    class SaxHandler
      attr_reader :node

      def initialize(node={})
        @parents = []
        @node = node
      end

      def start_element(name)
        name = name.to_s
        element = node_namespaces

        @node[name] = case @node[name]
                      when nil
                        element
                      when Hash
                        [@node[name], element]
                      else
                        @node[name] << element
                      end

        @parents << @node
        @node = element
        self
      end

      def attr(name, value)
        if name =~ /^xmlns(:?(.*))/i
          key = $2.to_s.length > 0 ? $2 : "$"
          (@node["@xmlns"] ||= {})[key] = value
        else
          @node["@#{name}"] = value
        end
        self
      end

      def text(value)
        @node["$"] = value
        self
      end

      alias :cdata :text

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
