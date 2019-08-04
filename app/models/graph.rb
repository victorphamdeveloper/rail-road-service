require_relative 'node'
require_relative '../utils/priority_queue'

class Graph
    MAX_INTEGER = 1 << 64
    def initialize
        @node_map = {}
    end

    def add_edge(path)
        source, destination, source_station_code, destination_station_code, distance = path
        source_node = get_or_create_node(source)
        destination_node = get_or_create_node(destination)
        source_node.set_neighbor(
          destination,
          source_station: source_station_code,
          destination_station: destination_station_code,
          distance: distance
        )
        destination_node.set_neighbor(
          source,
          source_station: destination_station_code,
          destination_station: source_station_code,
          distance: distance
        )
    end

    def dijkstra(source, destination)
        dist = Hash.new
        dist[source] = 0
        parent = Hash.new
        parent[source] = -1
        max_heap = PriorityQueue.new.tap { |heap| heap << ComparableNodeDistanceTuple.new(source, 0) }
        @node_map.keys.each do |key|
            next if key == source
            max_heap << ComparableNodeDistanceTuple.new(key, MAX_INTEGER)
            dist[key] = MAX_INTEGER
        end

        while(!max_heap.empty?) do
            node_tuple = max_heap.pop()
            node_key = node_tuple.node
            get_node(node_key).get_neighbors.each do |neighbor, _|
                alt = dist[node_key] + get_node(node_key).get_neighbor(neighbor)[:distance]
                if alt < dist[neighbor]
                    dist[neighbor] = alt
                    parent[neighbor] = node_key
                    max_heap << ComparableNodeDistanceTuple.new(neighbor, alt)
                end
            end
        end

        parent
    end


    def dijkstra_bonus(source, destination, start_time)
      dist = Hash.new
      dist[source] = start_time
      parent = Hash.new
      parent[source] = -1
      max_heap = PriorityQueue.new.tap { |heap| heap << ComparableNodeDistanceTuple.new(source, start_time) }
      @node_map.keys.each do |key|
          next if key == source
          max_heap << ComparableNodeDistanceTuple.new(key, start_time + 10.days)
          dist[key] = start_time + 10.days
      end

      while(!max_heap.empty?) do
          node_tuple = max_heap.pop()
          node_key = node_tuple.node
          get_node(node_key).get_neighbors.each do |neighbor, _|
              source_line = (parent[node_key] != -1) && (parent[node_key].present?) && get_node(parent[node_key]).get_neighbors[node_key][:source_station][0..1]
              destination_line = get_node(node_key).get_neighbors[neighbor][:destination_station][0..1]

              if (parent[node_key] != -1) && (parent[node_key].present?) && (source_line != destination_line)

                time_cost = get_time_cost(destination_line, dist[node_key]+get_switch_line_cost(dist[node_key]).minutes)

                next if time_cost == -1
                time_cost = (time_cost + get_switch_line_cost(dist[node_key]))
                alt = dist[node_key] + time_cost.minutes
              else
                time_cost = get_time_cost(destination_line, dist[node_key])
                next if time_cost == -1
              end

              alt = dist[node_key] + time_cost.minutes
              if alt < dist[neighbor]

                  dist[neighbor] = alt
                  parent[neighbor] = node_key

                  max_heap << ComparableNodeDistanceTuple.new(neighbor, alt)
              end
          end
      end

      {hash_path: parent, time_cost: dist}
    end

    def get_switch_line_cost(time)
      if ((time.hour >= 6 && time.hour <= 9) || (time.hour >= 18 && time.hour <= 21)) && (time.wday >= 1 && time.wday <= 5)
        15
      elsif (time.hour >= 22 && time.hour <= 24) || (time.hour >= 0 && time.hour <= 6)
        10
      else
        10
      end
    end

    def get_time_cost(line, time)
      if ((time.hour >= 6 && time.hour <= 9) || (time.hour >= 18 && time.hour <= 21)) && (time.wday >= 1 && time.wday <= 5)
        if line.in?(%w[NS NE])
          12
        else
          10
        end
      elsif (time.hour >= 22 && time.hour <= 24) || (time.hour >= 0 && time.hour <= 6)
        if line.in?(%w[DT CG CE])
          -1
        elsif line.in?(%w[TE])
          8
        else
          10
        end
      else
        if line.in?(%w[DT TE])
          8
        else
          10
        end
      end
    end

    def get_node(label)
        @node_map[label]
    end

    private

    def get_or_create_node(node_key)
        if !get_node(node_key)
            @node_map[node_key] = Node.new(node_key)
        else
            get_node(node_key)
        end
    end

    ComparableNodeDistanceTuple = Struct.new(:node, :distance) do
        include Comparable
        def <=>(other)
            if distance < other.distance
                return 1
            elsif distance > other.distance
                return -1
            else
                return 0
            end
        end
    end
end
