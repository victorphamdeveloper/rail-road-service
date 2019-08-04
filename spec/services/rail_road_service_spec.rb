describe RailRoadService do
  let(:graph_file_path) { Rails.root.join('tmp', 'StationMap.csv') }
  let(:edges) { Parser::GraphInputProcessingService.new(graph_file_path).process_file }
  let(:graph) { GraphBuilderService.new(edges).execute }

  context '.station_count' do
    let(:source) { 'Holland Village'}
    let(:destination) { 'Bugis' }
    it 'retun correct station count' do
      expect(described_class.new(graph, source, destination).station_count).to eq(8)
    end
  end

  context '.shortest_station_path_codes' do
    let(:source) { 'Holland Village'}
    let(:destination) { 'Bugis' }
    let(:expected_result) { ['CC21', 'CC20', 'CC19', 'DT9', 'DT10', 'DT11', 'DT12', 'DT13', 'DT14'] }
    it 'retun correct station count' do
      expect(described_class.new(graph, source, destination).shortest_station_path_codes).to eq(expected_result)
    end
  end

  context '.shortest_station_path_instructions' do
    let(:source) { 'Holland Village'}
    let(:destination) { 'Bugis' }
    let(:expected_result) do
      [
        'Take CC line from Holland Village to Farrer Road',
        'Take CC line from Farrer Road to Botanic Gardens',
        'Change from CC line to DT line',
        'Take DT line from Botanic Gardens to Stevens',
        'Take DT line from Stevens to Newton',
        'Take DT line from Newton to Little India',
        'Take DT line from Little India to Rochor',
        'Take DT line from Rochor to Bugis'
      ]
    end
    it 'retun correct station count' do
      expect(described_class.new(graph, source, destination).shortest_station_path_instructions).to eq(expected_result)
    end
  end

  context '.time_cost' do
    let(:source) { 'Boon Lay'}
    let(:destination) { 'Little India' }
    let(:time) { Time.parse('2019-08-05T07:00') }
    it 'retun correct time cost' do
      expect(described_class.new(graph, source, destination, time).time_cost).to eq(150)
    end
  end
end
