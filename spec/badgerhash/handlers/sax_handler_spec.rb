require File.expand_path "../../../spec_helper.rb", __FILE__

module Badgerhash
  module Handlers
    describe SaxHandler do
      subject(:handler) { SaxHandler.new }

      describe "#start_element" do
        it "sets the current node to new hash" do
          handler.start_element "foo"
          expect(handler.node).to eq({})
        end

        context "when no element present with name" do
          subject(:handler) { SaxHandler.new }
          it "adds the node name and empty hash" do
            handler.start_element("foo").end_element("foo")
            expect(handler.node).to eq({"foo" => {}})
          end
        end

        context "when one element present with name" do
          subject(:handler) { SaxHandler.new({"foo" => { "$" => "bar" }}) }
          it "add the new node and old node to an Array" do
            handler.start_element("foo").end_element("foo")
            expect(handler.node)
              .to eq({"foo" => [{"\$" => "bar"}, {}]})
          end
        end

        context "when more than one element present with name" do
          subject(:handler) { SaxHandler.new({ "foo" => [{ "\$" => "bar" },
                  { "\$" => "baz" }] }) }
          it "adds the new node to the Array" do
            handler.start_element("foo").end_element("foo")
            expect(handler.node)
              .to eq({"foo" => [{"\$" => "bar"}, {"\$" => "baz"}, {}]})
          end
        end
      end

      describe "#attr" do
        it "adds attribute as property that begins with '@'" do
          handler.start_element("foo")
            .attr("george", "bar")
            .end_element("foo")
          expect(handler.node).to eq("foo" => {"@george"=>  "bar"})
        end

        context "with parent namespaces" do
          before do
            handler.start_element("foo")
              .text("test")
              .attr("xmlns", "http://foo.com/namespace")
              .attr("xmlns:charlie", "http://foo.com/charlie")
              .start_element("charlie:bar")
              .text("test2")
              .end_element("charlie:bar")
          end

          it "adds parents namespaces" do
            expect(handler.node["charlie:bar"]["@xmlns"]["$"])
              .to eq("http://foo.com/namespace")
            expect(handler.node["charlie:bar"]["@xmlns"]["charlie"])
              .to eq("http://foo.com/charlie")
          end
        end

        context "when namespace" do
          it "stores main namespace in @xmlns $ property" do
            handler.start_element("foo")
              .attr("xmlns", "http://foo.com/namespace")
              .end_element("foo")
            expect(handler.node)
              .to eq("foo" => {"@xmlns" => {"$" => "http://foo.com/namespace"}})
          end

          it "stores additional namespaces in named property" do
            handler.start_element("foo")
              .attr("xmlns:george", "http://foo.com/george")
              .end_element("foo")
            expect(handler.node)
              .to eq("foo" => {"@xmlns" => {"george" => "http://foo.com/george"}})
          end
        end
      end

      describe "#text" do
        it "sets the $ key in the hash with the text value" do
          handler.text "foo"
          expect(handler.node).to eq({"\$" => "foo"})
        end
      end

      describe "#cdata" do
        it "sets the $ key in the hash with the cdata section" do
          handler.cdata "foo"
          expect(handler.node).to eq({"\$" => "foo"})
        end
      end

      describe "#end_element" do
        context "with parent tag on stack" do
          before do
            handler.start_element "foo"
          end

          it "closes the current node" do
            handler.end_element "foo"
            expect(handler.node).to eq({"foo" => {}})
          end
        end

        context "when no parent tag on stack" do
          it "sets node to empty hash" do
            handler.end_element "foo"
            expect(handler.node).to eq({})
          end
        end
      end
    end
  end
end

