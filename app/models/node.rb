class Node
    def initialize(label, neighbors: {})
        @label = label
        @neighbors = neighbors
    end

    def get_neighbors
        @neighbors
    end

    def get_label
      @label
    end

    def get_neighbor(node_key)
        @neighbors[node_key]
    end

    def set_neighbor(node_key, source_station: nil, destination_station: nil, distance: 1)
        @neighbors[node_key] = {
          source_station: source_station,
          destination_station: destination_station,
          distance: distance
        }
    end
end
