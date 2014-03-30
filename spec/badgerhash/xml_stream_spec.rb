require File.expand_path "../../spec_helper.rb", __FILE__

module Badgerhash
  describe XmlStream do
    let(:io) { double(:io) }

    describe ".create" do
      it "creates a new XmlStream from String" do
        expect(XmlStream).to receive(:new).and_call_original
        XmlStream.create("<alice>bob</alice>")
      end

      it "creates a new XmlStream" do
        expect(XmlStream).to receive(:new).and_call_original
        XmlStream.create(io)
      end
    end

    describe "#to_badgerfish" do
      let(:result) { { "foo" => { "$" => "bar"} } }
      let(:handler) { double(:handler, node: result) }
      let(:parser) { double(:parser) }
      subject(:xml_stream) { XmlStream.new(handler, parser, io) }

      it "parses io using the given parser and handler" do
        expect(parser).to receive(:parse).with(handler, io)
        expect(xml_stream.to_badgerfish).to eq(result)
      end
    end
  end
end
