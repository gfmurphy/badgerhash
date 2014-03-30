require File.expand_path "../../../spec_helper.rb", __FILE__

module Badgerhash
  module Handlers
    describe DomHandler do
      describe "#process_node" do
        subject(:node) { DomHandler.new.process_node(xml_node) }

        context "with attributes" do
          let(:attributes) { {"foo" => "bar", "charlie" => "bravo"} }
          let(:xml_node) { double(attributes: attributes, children: []) }

          it "adds attributes as a property that begin with '@'" do
            expect(node["@foo"]).to eq("bar")
            expect(node["@charlie"]).to eq("bravo")
          end
        end

        context "with namespaces" do
          let(:attributes) { { "xmlns" => "http://foo.com",
              "xmlns:bar" => "http://foo.com/bar" } }
          let(:xml_node) { double(attributes: attributes, children: []) }

          it "stores main namespace in @xmlns $ property" do
            expect(node["@xmlns"].fetch("$")).to eq("http://foo.com")
          end

          it "stores additional namespaces in a named property" do
            expect(node["@xmlns"].fetch("bar")).to eq("http://foo.com/bar")
          end
        end

        context "with text children" do
          let(:children) { [double(:node, :text? => true, text: "bar")] }
          let(:xml_node) { double(attributes: [], children: children) }

          it "assigns text nodes to the $ property" do
            expect(node["$"]).to eq("bar")
          end
        end

        context "with non text children" do
          let(:children) { [
              double(:node, name: "foo", :text? => false,
                attributes: [],
                children: [double(:node, :text? => true, text: "bar")])
            ]
          }
          let(:xml_node) { double(attributes: [], children: children) }

          it "nests the hash properly" do
            expect(node["foo"]).to eq({ "$" => "bar" })
          end
        end

        context "with parent namespaces" do
          let(:attributes) { { "xmlns" => "http://foo.com" } }
          let(:children) { [double(name: "foo", :text? => false,
                attributes: [], children: [])] }
          let(:xml_node) { double(attributes: attributes, children: children) }

          it "assigns the parent namespaces to the child" do
            expect(node["foo"]["@xmlns"].fetch("$")).to eq("http://foo.com")
          end
        end
      end
    end
  end
end
