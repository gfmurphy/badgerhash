require File.expand_path "../../spec_helper.rb", __FILE__

module Badgerhash
  describe XmlStream do
    describe ".create" do
      it "creates a new XmlStream" do
        expect(XmlStream).to receive(:new)
        XmlStream.create
      end
    end

    describe "#to_badgerfish" do
      let(:result) { { "foo" => { "$" => "bar"} } }
      let(:io) { double(:io) }
      let(:handler) { double(:handler, node: result) }
      let(:parser) { double(:parser) }
      subject(:xml_stream) { XmlStream.new(handler, parser) }

      it "parses io using the given parser and handler" do
        expect(parser).to receive(:parse).with(handler, io)
        expect(xml_stream.to_badgerfish(io)).to eq(result)
      end
    end
  end
end
