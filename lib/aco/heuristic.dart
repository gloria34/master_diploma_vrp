import 'package:master_diploma_vrp/main.dart';
import 'package:master_diploma_vrp/model/ant.dart';
import 'package:master_diploma_vrp/model/edge.dart';

abstract class Heuristic {
  static double calculateHeuristic(Ant ant, Edge edge) {
    final timeWindowsProbability = _calculateTimeWindowsProbability(ant, edge);
    final demandProbability = _calculateDemandProbability(ant, edge);
    return timeWindowsProbability * demandProbability * heuristicImportance;
  }

  static double _calculateTimeWindowsProbability(Ant ant, Edge edge) {
    final arrivalTime = ant.route.time + edge.getDistance();
    if (arrivalTime >= edge.endLocation.fromTime &&
        arrivalTime <= edge.endLocation.dueTime) {
      return 1.0;
    } else if (arrivalTime < edge.endLocation.fromTime) {
      return arrivalTime / edge.endLocation.fromTime;
    } else {
      return 0.0;
    }
  }

  static double _calculateDemandProbability(Ant ant, Edge edge) {
    if (ant.route.demand >= edge.endLocation.demand) {
      return 1.0;
    } else {
      return 0.0;
    }
  }
}
