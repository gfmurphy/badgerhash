require File.expand_path "../../../spec_helper.rb", __FILE__

module Badgerhash
  module Parsers
    module REXML
      describe SaxDocument do
        let(:handler) { double(:handler) }
        subject(:document) { SaxDocument.new(handler) }

        describe ".parse" do
          let(:parser) { double(:parser) }
          let(:io)     { double(:io) }

          it "delegates to the Nokogiri XML SAX parser" do
            expect(::REXML::Parsers::StreamParser).to receive(:new)
              .and_return(parser)
            expect(parser).to receive(:parse)
            SaxDocument.parse(handler, io)
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
