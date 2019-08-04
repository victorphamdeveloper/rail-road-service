describe Parser::GraphInputProcessingService do
  let(:graph_file_path) { Rails.root.join('tmp', 'StationMap.csv') }
  let(:parser) { described_class.new(graph_file_path) }
  context '.process_file' do
    it 'parse input file correctly' do
      expect(parser.process_file.count).to eq(158)
    end
  end
end
