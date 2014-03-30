require File.expand_path "../../spec_helper.rb", __FILE__

describe "Parsing XML Document", integration: true do
  it_behaves_like "a badgerfish parser" do
    subject(:badgerfish) { Badgerhash::XmlDocument.create(xml).to_badgerfish }
  end
end
