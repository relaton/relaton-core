module Relaton::Core
  class DataFetcher
    # attr_accessor :docs
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
      @files = Set.new
      # @docs = []
      @errors = Hash.new(true)
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

    def fetch
      raise NotImplementedError, "#{self.class}#fetch method must be implemented"
    end

    def gh_issue
      return @gh_issue if defined? @gh_issue

      @gh_issue = Relaton::Logger::Channels::GhIssue.new(*gh_issue_channel)
      Relaton.logger_pool[:gh_issue] = Relaton::Logger::Log.new(@gh_issue, levels: [:error])
      @gh_issue
    end

    def gh_issue_channel
      raise NotImplementedError, "#{self.class}#gh_issue_channel method must be implemented"
    end

    def repot_errors
      @errors.select { |_, v| v }.each_key { |k| log_error "Failed to fetch #{k}" }
      gh_issue.create_issue
    end

    def log_error(_msg)
      raise NoMatchingPatternError, "#{self.class}#log_error method must be implemented"
    end

    # @param [String] document ID
    # @return [String] filename based on PubID identifier
    def output_file(docid)
      File.join @output, "#{docid.downcase.gsub(/[.\s\/-]+/, '-')}.#{@ext}"
    end

    #
    # Serialize bibliographic item
    #
    # @param [RelatonCcsds::BibliographicItem] bib <description>
    #
    # @return [String] serialized bibliographic item
    #
    def serialize(bib)
      send "to_#{@format}", bib
    end

    def to_yaml(bib)
      raise NotImplementedError, "#{self.class}#to_yaml method must be implemented"
    end

    def to_xml(bib)
      raise NotImplementedError, "#{self.class}#to_xml method must be implemented"
    end

    def to_bibxml(bib)
      raise NotImplementedError, "#{self.class}#to_bibxml method must be implemented"
    end
  end
end
