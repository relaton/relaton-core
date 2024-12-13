module Relaton::Core
  class DataFetcher
    attr_accessor :docs
    #
    # Initialize fetcher
    #
    # @param [String] output path to output directory
    # @param [String] format output format (yaml, xml, bibxml)
    #
    def initialize(output, format)
      @output = output
      @format = format
      @ext = format.sub "bibxml", "xml"
      @files = []
      @docs = []
    end

    def index
      @index ||= Relaton::Index.find_or_create self.class::INDEX_TYPE,
                                               file: self.class::INDEX_FILE,
                                               pubid_class: self.class.get_identifier_class
    end

    # API method for external service
    def self.fetch(output: "data", format: "yaml")
      t1 = Time.now
      puts "Started at: #{t1}"
      FileUtils.mkdir_p output
      new(output, format).fetch
      t2 = Time.now
      puts "Stopped at: #{t2}"
      puts "Done in: #{(t2 - t1).round} sec."
    end

    def self.get_identifier_class
      raise NotImplementedError, "#{self.class}#get_identifier_class method must be implemented"
    end

    def fetch
      fetch_docs ACTIVE_PUBS_URL
      fetch_docs OBSOLETE_PUBS_URL, retired: true
      index.save
    end

    # Parse hash and return RelatonBib
    # @param [Hash] doc document data
    # @return [RelatonBib]
    def parse(doc)
      raise NotImplementedError, "#{self.class}#parse method must be implemented"
    end

    # @param [RelatonBib::BibliographicItem] bib
    # @return [String] filename based on PubID identifier
    def get_output_file(bib)
      File.join @output, "#{bib.docidentifier.first.id.gsub(/[.\s-]+/, '-')}.#{@ext}"
    end

    #
    # Parse document and save to file
    #
    # @param [Hash] doc document data
    # @param [Boolean] retired if true then document is retired
    #
    # @return [void]
    #
    def parse_and_save(doc)
      bibitem = parse(doc)
      save_bib(bibitem)
    end

    #
    # Save bibitem to file
    #
    # @param [RelatonBib::BibliographicItem] bib bibitem
    #
    # @return [void]
    #
    def save_bib(bib)
      #search_instance_translation bib
      file = get_output_file(bib)
      #merge_links bib, file
      File.write file, serialize(bib), encoding: "UTF-8"
      # why do we need to know filename to update index?
      index.add_or_update self.get_identifier_class.parse(bib.docidentifier.first.id), file
      #old_index.add_or_update bib.docidentifier.first.id, file
    end

    #
    # Serialize bibliographic item
    #
    # @param [RelatonCcsds::BibliographicItem] bib <description>
    #
    # @return [String] serialized bibliographic item
    #
    def serialize(bib)
      case @format
      when "yaml" then bib.to_hash.to_yaml
      when "xml" then bib.to_xml(bibdata: true)
      else bib.send "to_#{@format}"
      end
    end
  end
end
