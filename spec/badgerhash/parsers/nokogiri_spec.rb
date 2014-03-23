require File.expand_path "../../../spec_helper.rb", __FILE__

module Badgerhash
  module Parsers
    module Nokogiri
      describe SaxDocument do
        let(:handler) { double(:handler) }
        subject(:document) { SaxDocument.new(handler) }

        describe ".parse" do
          let(:parser) { double(:parser) }
          let(:io)     { double(:io) }

          it "delegates to the Nokogiri XML SAX parser" do
            expect(::Nokogiri::XML::SAX::Parser).to receive(:new)
              .and_return(parser)
            expect(parser).to receive(:parse).with(io)
            SaxDocument.parse(handler, io)
          end
        end

        describe "#end_element" do
          it "delegates to handler" do
            expect(handler).to receive(:end_element).with("foo")
            document.end_element("foo")
          end
        end

        describe "#cdata_block" do
          it "delegates to handler's text method" do
            expect(handler).to receive(:text).with "foo"
            document.cdata_block "foo"
          end
        end

        describe "#characters" do
          it "delegates to the handler's text method" do
            expect(handler).to receive(:text).with "foo"
            document.characters "foo"
          end
        end

        describe "#start_element" do
          let(:attributes) { [["one", '1'], ["two", '2']] }

          before do
            expect(handler).to receive(:start_element).with "foo"
          end

          it "delegates to handler's start_element_method" do
            document.start_element "foo"
          end

          it "delegates attributes to handler's attr method" do
            expect(handler).to receive(:attr).exactly(attributes.size).times
            document.start_element "foo", attributes
          end
        end
      end
    end
  end
end
