describe Relaton::Core::DataFetcher do
  subject { described_class.new("data", "bibxml") }

  describe "::initialize" do
    it { expect(subject.instance_variable_get(:@output)).to eq "data" }
    it { expect(subject.instance_variable_get(:@format)).to eq "bibxml" }
    it { expect(subject.instance_variable_get(:@ext)).to eq "xml" }
    it { expect(subject.instance_variable_get(:@files)).to be_instance_of Set }
    it { expect(subject.instance_variable_get(:@errors)).to be_instance_of Hash }
  end

  describe "::fetch" do
    it "create data fetcher object and call instance method fetch" do
      expect(FileUtils).to receive(:mkdir_p).with("data")
      expect(described_class).to receive(:new).and_return subject
      expect(subject).to receive(:fetch)
      described_class.fetch
    end
  end

  describe "#fetch" do
    it "raise NotImplementedError" do
      expect { subject.fetch }.to raise_error NotImplementedError
    end
  end

  describe "#gh_issue" do
    before { allow(subject).to receive(:gh_issue_channel).and_return ["repo", "msg"]}

    it "clereate GH issue channel" do
      expect(subject.gh_issue).to be_instance_of Relaton::Logger::Channels::GhIssue
    end
  end

  describe "#gh_issue_channel" do
    it "raise NotImplementedError" do
      expect { subject.gh_issue_channel }.to raise_error NotImplementedError
    end
  end

  describe "#repot_errors" do
    before { subject.instance_variable_set(:@errors, { "key" => true }) }

    it "call Util.error and create GH issue" do
      expect(subject).to receive(:gh_issue).and_return double(create_issue: nil)
      expect(subject).to receive(:log_error).with("Failed to fetch key")
      subject.repot_errors
    end
  end

  describe "#log_error" do
    it "raise NoMatchingPatternError" do
      expect { subject.log_error("msg") }.to raise_error NoMatchingPatternError
    end
  end

  describe "#get_output_file" do
    let(:file) { subject.output_file("ISO/IEC 123-4 Amd. 2") }
    it { expect(file).to eq("data/iso-iec-123-4-amd-2.xml") }
  end

  describe "#serialize"  do
    it "BibXML serialization" do
      expect(subject).to receive(:to_bibxml).with(:doc)
      subject.serialize(:doc)
    end

    it "YAML serialization" do
      subject.instance_variable_set(:@format, "yaml")
      expect(subject).to receive(:to_yaml).with(:doc)
      subject.serialize(:doc)
    end

    it "XML serialization" do
      subject.instance_variable_set(:@format, "xml")
      expect(subject).to receive(:to_xml).with(:doc)
      subject.serialize(:doc)
    end
  end

  describe "#to_yaml" do
    it "raise NotImplementedError" do
      expect { subject.to_yaml(:doc) }.to raise_error NotImplementedError
    end
  end

  describe "#to_xml" do
    it "raise NotImplementedError" do
      expect { subject.to_xml(:doc) }.to raise_error NotImplementedError
    end
  end

  describe "#to_bibxml" do
    it "raise NotImplementedError" do
      expect { subject.to_bibxml(:doc) }.to raise_error NotImplementedError
    end
  end
end
