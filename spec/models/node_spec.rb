describe Node do
  let(:node) { described_class.new('Redhill') }
  context '.set_neighbor' do
    let(:destination) { 'Queenstown' }
    it 'set correct edge information' do
      node.set_neighbor(destination, source_station: 'EW1', destination_station: 'EW2', distance: 5)
      expect(node.get_neighbor(destination)).to match(
        source_station: 'EW1',
        destination_station: 'EW2',
        distance: 5
      )
    end
  end
end
