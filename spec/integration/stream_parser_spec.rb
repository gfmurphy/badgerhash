require File.expand_path "../../spec_helper.rb", __FILE__

describe "Parsing XML Stream", integration: true do
  it_behaves_like "a badgerfish parser" do
    subject(:badgerfish) { Badgerhash::XmlStream.create(xml).to_badgerfish }
  end
end
