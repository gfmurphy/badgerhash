require File.expand_path "../../spec_helper.rb", __FILE__

describe "Parsing XML Stream", integration: true do
  subject(:xml_stream) { Badgerhash::XmlStream.create(xml) }

  context "with simple document" do
    let(:xml) { StringIO.new("<alice>bob</alice>") }

    it "parses document correctly" do
      expect(xml_stream.to_badgerfish).to eq({"alice" => {"\$" => "bob"}})
    end
  end

  context "with whitespace in nodes" do
    let(:xml_str) {
      <<-XML
      <alice>
        bob
      </alice>
      XML
    }
    let(:xml) { StringIO.new(xml_str) }

    it "compresses the whitespace" do
      expect(xml_stream.to_badgerfish).to eq({"alice" => {"\$" => "bob"}})
    end
  end

  context "with nested elements" do
    let(:xml_str) { "<alice><bob>charlie</bob><david>edgar</david></alice>" }
    let(:xml) { StringIO.new(xml_str) }
    let(:expected) { {"alice" => {"bob" => {"\$" => "charlie" },
          "david" => { "\$" => "edgar"}}} }

    it "parses document correctly" do
      expect(xml_stream.to_badgerfish).to eq(expected)
    end
  end

  context "with multiple elements at the same level" do
    let(:xml_str) { "<alice><bob>charlie</bob><bob>david</bob></alice>" }
    let(:xml) { StringIO.new(xml_str) }
    let(:expected) { { "alice" => {"bob" =>  [{"\$" => "charlie"},
            {"\$" => "david" }]}} }

    it "parses document correctly" do
      expect(xml_stream.to_badgerfish).to eq(expected)
    end
  end

  context "with attributes on elements" do
    let(:xml) { StringIO.new("<alice charlie=\"david\">bob</alice>") }
    let(:expected) { {"alice" => { "\$" => "bob", "@charlie" => "david" } } }

    it "add attribute as properties begining with '@'" do
      expect(xml_stream.to_badgerfish).to eq(expected)
    end
  end

  context "with a default namespace" do
    let(:xml) { StringIO.new("<alice xmlns=\"http://some-namespace\">bob</alice>") }
    let(:expected) { {"alice" => {"\$" => "bob", "@xmlns" => {
            "\$" => "http:\/\/some-namespace"}} } }

    it "places it in the @xmlns.$ property" do
      expect(xml_stream.to_badgerfish).to eq(expected)
    end
  end

  context "with other namespaces" do
    let(:xml_str) { "<alice xmlns=\"http:\/\/some-namespace\" xmlns:charlie=\"http:\/\/some-other-namespace\">bob</alice>" }
    let(:xml) { StringIO.new(xml_str) }
    let(:expected) { {"alice" => {"\$" => "bob", "@xmlns" => {
            "\$" => "http:\/\/some-namespace",
            "charlie" => "http:\/\/some-other-namespace" }}} }

    it "places them in properties of @xmlns" do
      expect(xml_stream.to_badgerfish).to eq(expected)
    end
  end

  context "with elements containing namespace prefixes" do
    let(:xml_str) {
      "<alice xmlns=\"http://some-namespace\" xmlns:charlie=\"http://some-other-namespace\"><bob>david</bob><charlie:edgar>frank</charlie:edgar></alice>"
    }
    let(:xml) { StringIO.new(xml_str) }
    let(:expected) { {"alice" => {"bob" => {"\$" => "david" ,
            "@xmlns" => {"charlie" => "http:\/\/some-other-namespace",
              "\$" => "http:\/\/some-namespace"}},
          "charlie:edgar" => {"\$" => "frank",
            "@xmlns" => {"charlie" => "http:\/\/some-other-namespace",
              "\$" => "http:\/\/some-namespace"}},
          "@xmlns" => {"charlie" => "http:\/\/some-other-namespace", 
            "\$" => "http:\/\/some-namespace"}}} }

    it "add them as properties" do
      expect(xml_stream.to_badgerfish).to eq(expected)
    end
  end
end
