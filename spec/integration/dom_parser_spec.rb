require File.expand_path "../../spec_helper.rb", __FILE__

describe "Parsing XML Document", integration: true do
  subject(:badgerfish) { Badgerhash::XmlDocument.create(xml).to_badgerfish }

  context "with simple document" do
    let(:xml) { StringIO.new("<alice>bob</alice>") }

    it "parses document correctly" do
      expect(badgerfish).to eq({"alice" => {"\$" => "bob"}})
    end
  end
end
