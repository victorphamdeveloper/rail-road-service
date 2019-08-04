require 'csv'

module Parser
  class GraphInputProcessingService
    def initialize(file_path)
      @path = file_path
    end

    def process_file
      file_contents = CSV.read(@path, headers: true)
      file_contents.each_with_index.map do |destination_line, index|
        next if index == 0
        source_line = file_contents[index-1]
        source_station_code = source_line['Station Code']
        destination_station_code = destination_line['Station Code']
        next unless source_station_code[0..1] == destination_station_code[0..1]
        [source_line['Station Name'], destination_line['Station Name'], source_line['Station Code'], destination_line['Station Code'], 1]
      end.compact
    end
  end
end
