class RailRoadService
  attr_reader :graph, :source, :destination, :start_time
  def initialize(graph, source, destination, start_time = nil)
      @graph = graph
      @source = source
      @destination = destination
      @start_time = start_time
  end

  def shortest_station_path_codes
    results = []
    get_path_codes_recur(hash_path, destination, results)
    results << graph.get_node(hash_path[destination]).get_neighbors[destination][:destination_station]
    results
  end

  def shortest_station_path_instructions
    results = []
    get_path_instructions_recur(hash_path, destination, results)
    destination_node = graph.get_node(hash_path[destination]).get_neighbors[destination]
    results
  end

  def station_count
    temp = destination
    count = 1
    while(hash_path[temp] != -1)
      count = count + 1
      temp = hash_path[temp]
    end

    count
  end

  def time_cost
    p (graph.dijkstra_bonus(source, destination, start_time)[:time_cost][destination] - start_time)/60
  end

  private

  def get_path_instructions_recur(hash_path, node_key, results)
    return if (node_key == -1)
    get_path_instructions_recur(hash_path, hash_path[node_key], results)
    return if hash_path[node_key] == -1
    parent_node = graph.get_node(hash_path[node_key])
    source_line = get_neighbor_nodes(hash_path[node_key], node_key)[:source_station][0..1]

    if (hash_path[parent_node.get_label] != -1)
      destination_line = get_neighbor_nodes(hash_path[parent_node.get_label], hash_path[node_key])[:destination_station][0..1]
      results << "Change from #{destination_line} line to #{source_line} line" if (source_line != destination_line)
    end

    results <<  instruction_path(get_neighbor_nodes(hash_path[node_key], node_key)[:source_station][0..1], hash_path[node_key], node_key)
  end

  def get_neighbor_nodes(parent_key, node_key)
    graph.get_node(parent_key).get_neighbors[node_key]
  end

  def instruction_path(line, source_station, destination_station)
    "Take #{line} line from #{source_station} to #{destination_station}"
  end

  def get_path_codes_recur(hash_path, node_key, results)
    return if (node_key == -1)
    get_path_codes_recur(hash_path, hash_path[node_key], results)
    return if hash_path[node_key] == -1
    parent_node = graph.get_node(hash_path[node_key])
    source_line = get_neighbor_nodes(hash_path[node_key], node_key)[:source_station][0..1]

    if (hash_path[parent_node.get_label] != -1)
      destination_line = get_neighbor_nodes(hash_path[parent_node.get_label], hash_path[node_key])[:destination_station][0..1]
      results << get_neighbor_nodes(hash_path[parent_node.get_label], hash_path[node_key])[:destination_station] if (source_line != destination_line)
    end

    results <<  get_neighbor_nodes(hash_path[node_key], node_key)[:source_station]
  end

  def hash_path
    @hash_path =
      if (start_time.nil?)
        graph.dijkstra(source, destination)
      else
        graph.dijkstra_bonus(source, destination, start_time)[:hash_path]
      end
  end
end
