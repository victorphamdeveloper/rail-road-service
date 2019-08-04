require_relative '../models/graph'
class GraphBuilderService
    def initialize(edges)
        @edges = edges
        @graph = Graph.new
    end

    def execute
        @edges.each do |edge|
            @graph.add_edge(edge)
        end
        @graph
    end
end