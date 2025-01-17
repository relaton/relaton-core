describe Relaton::Core::DataFetcher do
  let(:documents) { [] }
  let(:identifier) { "ISO 1" }
  let(:bib) { RelatonBib::BibliographicItem.new(docid: [RelatonBib::DocumentIdentifier.new(id: identifier)]) }

  let(:data_fetcher) { Relaton::Core::DummyDataFetcher.new("data", "bibxml") }

  # Storage
  describe "when stores documents" do
    it "adds documents to storage"
  end

  it "index documents"

  describe "#get_output_file" do
    subject { data_fetcher.get_output_file(bib) }

    it "returns output file" do
      expect(subject).to eq("data/ISO-1.xml")
    end
  end

  describe "#index_add_or_update" do
    before { data_fetcher.index_add_or_update(bib) }
    subject { data_fetcher.index }

    it "adds document to index" do
      expect(subject.index.map { |v| { v[:id].to_s => v[:file] } })
        .to eq([{ "ISO 1" => "data/ISO-1.xml" }])
    end
  end
end
