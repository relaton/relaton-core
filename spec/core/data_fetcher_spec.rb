describe Relaton::Core::DataFetcher do
  let(:documents) { [] }
  let(:identifier) { "ISO 1" }
  let(:bib) { RelatonBib::BibliographicItem.new(docid: [RelatonBib::DocumentIdentifier.new(id: identifier)]) }
  describe "when fetches data from source" do
    it "should return data for parsing" do
      expect(described_class.fetch_data).to eq({})
    end
  end

  # Parser
  describe "when parses documents" do
    it "should return bib objects" do
      expect(described_class.parse())

      parsed_bib = described_class.parse([{ id: identifier }])
      expect(parsed_bib.first.docid.first.id).to eq(identifier)
    end
  end

  # Storage
  describe "when stores documents" do
    it "adds documents to storage"
  end

  it "index documents"

  describe "#get_output_file" do
    subject { described_class.new("data", "bibxml").get_output_file(bib) }

    it "returns output file" do
      expect(subject).to eq("data/ISO-1.xml")
    end
  end
end
