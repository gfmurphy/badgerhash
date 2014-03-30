require File.expand_path "../../spec_helper.rb", __FILE__

module Badgerhash
  describe XmlDocument do
    let(:io) { double(:io) }

    describe ".create" do
      it "creates a properly initialized XmlDocument from String" do
        expect(XmlDocument).to receive(:new).and_call_original
        XmlDocument.create("<alice>bob</alice>")
      end

      it "creates a new XmlDocument from IO" do
        expect(XmlDocument).to receive(:new).and_call_original
        XmlDocument.create(io)
      end
    end

    describe "#to_badgerfish" do
      let(:result) { { "foo" => { "$" => "bar" } } }
      let(:handler) { double(:handler, node: result) }
      let(:parser) { double(:parser) }
      let(:node) { double(:node) }
      subject(:xml_document) { XmlDocument.new(handler, parser, io) }

      it "parses io using the given parser and handler" do
        expect(parser).to receive(:parse).with(io).and_return(node)
        expect(handler).to receive(:process_node).with(node).and_return(result)
        expect(xml_document.to_badgerfish).to eq(result)
      end
    end
  end
end
