describe Graph do
  let(:graph) { described_class.new }
  context '.add_edge' do
    let(:source) { 'Redhill' }
    let(:destination) { 'Queenstown' }
    it 'set correct edge information' do
      graph.add_edge([source, destination, 'EW11', 'EW12', 1])
      expect(graph.get_node(source).get_neighbor(destination)).to match(
        source_station: 'EW11',
        destination_station: 'EW12',
        distance: 1
      )
    end
  end
end
