require File.expand_path "../../../spec_helper.rb", __FILE__

module Badgerhash
  module Parsers
    module REXML
      describe DocumentParser do
        describe ".parse" do
          let(:xml) { double(:xml) }

          it "delegates to rexml parser" do
            expect(::REXML::Document).to receive(:new)
              .with(xml, { compress_whitespace: :all })
              .and_return(double(root: double(:node)))
            DocumentParser.parse(xml)
          end
        end
      end

      describe DocumentParser::XmlNode do
        let(:rexml_document) { double(:rexml_document) }
        subject(:xml_node) { DocumentParser::XmlNode.new(rexml_document) }

        describe "#children" do
          let(:children) { [double(:child), double(:child) ]}
          let(:rexml_document) { double(:rexml_document, children: children) }

          it "processes all the children" do
            expect(xml_node.children.size).to eq(children.size)
          end

          it "wraps document child elements in xml nodes" do
            xml_node.children.each do |child|
              expect(child).to be_a(DocumentParser::XmlNode)
            end
          end
        end

        describe "#attributes" do
          let(:attributes) { [["foo", "bar"], ["charlie", "bravo"]] }
          let(:rexml_document) { double(:rexml_document, attributes: attributes) }

          it "maps the attributes on the node to a Hash" do
            expect(xml_node.attributes).to eq({ "foo" => "bar", "charlie" => "bravo"})
          end
        end

        describe "#text" do
          it "delegates to document" do
            expect(rexml_document).to receive(:value).and_return "foo"
            expect(xml_node.text).to eq("foo")
          end
        end

        describe "#name" do
          it "delegates to document" do
            expect(rexml_document).to receive(:name).and_return "foo"
            expect(rexml_document.name).to eq("foo")
          end
        end

        describe "#text?" do
          context "when documen is a text node" do
            let(:rexml_document) { double(:rexml_document, node_type: :text) }

            it "indicates that document node type is text" do
              expect(xml_node).to be_text
            end
          end

          context "when document is not a text node" do
            let(:rexml_document) { double(:rexml_document, node_type: :foo) }

            it "indicates that document node type is not text" do
              expect(xml_node).not_to be_text
            end
          end
        end
      end

      describe StreamParser do
        let(:handler) { double(:handler) }
        subject(:document) { StreamParser.new(handler) }

        describe ".parse" do
          let(:parser) { double(:parser) }
          let(:io)     { double(:io) }

          it "delegates to the REXML sax parser" do
            expect(::REXML::Document).to receive(:parse_stream)
            StreamParser.parse(handler, io)
          end
        end

        describe "#tag_end" do
          it "delegates to handler" do
            expect(handler).to receive(:end_element).with("foo")
            document.tag_end("foo")
          end
        end

        describe "#cdata" do
          it "delegates to handler's text method" do
            expect(handler).to receive(:cdata).with "foo"
            document.cdata "foo"
          end
        end

        describe "#text" do
          it "delegates to the handler's text method" do
            expect(handler).to receive(:text).with "foo"
            document.text "foo"
          end
        end

        describe "#tag_start" do
          let(:attributes) { [["one", '1'], ["two", '2']] }

          before do
            expect(handler).to receive(:start_element).with "foo"
          end

          it "delegates to handler's start_element_method" do
            document.tag_start "foo"
          end

          it "delegates attributes to handler's attr method" do
            expect(handler).to receive(:attr).exactly(attributes.size).times
            document.tag_start "foo", attributes
          end
        end
      end
    end
  end
end
