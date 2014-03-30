require File.expand_path "../spec_helper.rb", __FILE__

describe Badgerhash do
  describe ".dom_parser=" do
    let(:parser) { double(:parser) }
    after(:each) do
      reset_instance_variables Badgerhash
    end

    it "sets the parser" do
      Badgerhash.dom_parser = parser
      expect(Badgerhash.dom_parser).to eq(parser)
    end
  end

  describe ".dom_parser" do
    it "uses the rexml parser as default" do
      expect(Badgerhash.dom_parser)
        .to eq(Badgerhash::Parsers::REXML::DocumentParser)
    end
  end

  describe ".sax_parser=" do
    let(:parser) { double(:parser) }

    after :each do
      reset_instance_variables Badgerhash
    end

    it "sets the parser" do
      Badgerhash.sax_parser = parser
      expect(Badgerhash.sax_parser).to eq(parser)
    end
  end

  describe ".sax_parser" do
    it "uses the rexml parser as default" do
      expect(Badgerhash.sax_parser)
        .to eq(Badgerhash::Parsers::REXML::StreamParser)
    end
  end
end
