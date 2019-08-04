class RoutesController < ApplicationController
  def find_routes
    graph_file_path = Rails.root.join('tmp', 'StationMap.csv')
    edges = Parser::GraphInputProcessingService.new(graph_file_path).process_file
    graph = GraphBuilderService.new(edges).execute
    rail_road_service = RailRoadService.new(graph, params[:source], params[:destination])

    render json: {
      shortest_station_path_codes: rail_road_service.shortest_station_path_codes,
      station_count: rail_road_service.station_count,
      shortest_station_path_instructions: rail_road_service.shortest_station_path_instructions
    }
  end

  def find_routes_bonus
    graph_file_path = Rails.root.join('tmp', 'StationMap.csv')
    edges = Parser::GraphInputProcessingService.new(graph_file_path).process_file
    graph = GraphBuilderService.new(edges).execute
    rail_road_service = RailRoadService.new(graph, params[:source], params[:destination], Time.parse(params[:time]))

    render json: {
      shortest_station_path_codes: rail_road_service.shortest_station_path_codes,
      time_cost: rail_road_service.time_cost,
      shortest_station_path_instructions: rail_road_service.shortest_station_path_instructions
    }
  end
end
