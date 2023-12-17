import 'package:master_diploma_vrp/aco/cost.dart';
import 'package:master_diploma_vrp/aco/probability.dart';
import 'package:master_diploma_vrp/main.dart';
import 'package:master_diploma_vrp/model/answer.dart';
import 'package:master_diploma_vrp/model/ant.dart';
import 'package:master_diploma_vrp/model/best_route.dart';
import 'package:master_diploma_vrp/model/edge.dart';
import 'package:master_diploma_vrp/model/point.dart';
import 'package:master_diploma_vrp/model/route.dart';

class ACO {
  final List<Point> points;
  final Map<Point, List<Edge>> edges;
  final List<Route> _routes = [];
  final List<Ant> _ants = [];
  final List<Point> _points = [];
  late Map<Point, List<Edge>> _edgesWithCost;
  Answer bestAnswer = Answer();

  ACO({required this.points, required this.edges}) {
    _edgesWithCost = edges;
  }

  Answer solve() {
    _initAntColony();
    for (int i = 0; i < numberOfIterations; i++) {
      for (Ant ant in _ants) {
        _resetRoutes();
        _resetAntRoute(ant);
        while (_points.length > 1) {
          Edge nextEdge = _selectNextEdge(ant);
          _updateAntRoute(ant, nextEdge);
          if (nextEdge.endLocation != depot) {
            _points.remove(nextEdge.endLocation);
          } else {
            _routes.add(ant.route);
            _resetAntRoute(ant);
          }
        }
        BestRoute bestRoute = _getBestRoute();
        _updatePheromoneOnBestRoute(bestRoute);
      }
      _pheromoneEvaporation();
    }
    return bestAnswer;
  }

  void _initAntColony() {
    _ants.clear();
    for (int i = 0; i < numberOfAnts; i++) {
      _ants.add(Ant(points));
    }
  }

  void _resetRoutes() {
    _routes.clear();
    _points.clear();
    _points.addAll(points);
    _edgesWithCost = edges;
  }

  void _resetAntRoute(Ant ant) {
    ant.route = Route();
  }

  Edge _selectNextEdge(Ant ant) {
    Edge? depotEdge;
    for (Edge edge in edges[ant.currentPosition]!) {
      if (edge.endLocation == depot) {
        depotEdge = edge;
      } else if (_points.contains(edge.endLocation) &&
          Probability.calculateProbability(ant, edge) > 0) {
        return edge;
      }
    }
    return depotEdge!;
  }

  void _updateAntRoute(Ant ant, Edge edge) {
    ant.route.demand -= edge.endLocation.demand;
    ant.route.distance += edge.getDistance();
    if (edge.getDistance() < edge.endLocation.fromTime) {
      ant.route.time += edge.endLocation.fromTime;
    } else {
      ant.route.time += edge.getDistance();
    }
    ant.route.time += edge.endLocation.serviceTime;
    ant.route.visitedCustomers.add(edge.endLocation);
    ant.route.visitedEdges.add(edge);
    ant.currentPosition = edge.endLocation;
  }

  BestRoute _getBestRoute() {
    BestRoute bestRoute = BestRoute(route: _routes.first);
    Answer answer = Answer();
    for (Route route in _routes) {
      var routeCost = Cost.calculateCost(route);
      for (Edge visitedEdge in route.visitedEdges) {
        _edgesWithCost[visitedEdge.startLocation]!
            .where((element) => element.endLocation == visitedEdge.endLocation)
            .first
            .costs
            .add(routeCost);
      }
      answer.bestRoutes.add(BestRoute(route: route)..cost = routeCost);
      answer.cost += routeCost;
      if (routeCost > bestRoute.cost) {
        bestRoute = BestRoute(route: route);
        bestRoute.cost = routeCost;
      }
    }
    if (answer.cost > bestAnswer.cost) {
      bestAnswer = answer;
    }
    return bestRoute;
  }

  void _updatePheromoneOnBestRoute(BestRoute bestRoute) {
    for (Edge edge1 in bestRoute.route.visitedEdges) {
      for (Edge edge2 in edges[edge1.startLocation]!) {
        if (edge1.endLocation == edge2.endLocation) {
          double sum = 0.0;
          for (final cost in _edgesWithCost[edge1.startLocation]!
              .where((element) => element.endLocation == edge2.endLocation)
              .first
              .costs) {
            sum += cost;
          }
          edge2.pheromone = (1 - evaporationRate) * edge2.pheromone + sum;
        }
      }
    }
  }

  void _pheromoneEvaporation() {
    for (final key in edges.keys) {
      for (Edge edge in edges[key]!) {
        edge.pheromone = edge.pheromone * evaporationRate;
      }
    }
  }
}
