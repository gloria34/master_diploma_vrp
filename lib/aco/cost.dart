import 'package:master_diploma_vrp/main.dart';
import 'package:master_diploma_vrp/model/edge.dart';
import 'package:master_diploma_vrp/model/route.dart';

abstract class Cost {
  static double calculateCost(Route route) {
    final distance = _calculateDistance(route);
   // final timeFines = _calculateTimeFines(route);
    return distance;
  }

  static double _calculateDistance(Route route) {
    var distance = 0.0;
    for (Edge edge in route.visitedEdges) {
      distance += edge.getDistance();
    }
    return distance;
  }

  static double _calculateTimeFines(Route route) {
    if (route.time > depot.dueTime) {
      return depot.dueTime - route.time;
    } else {
      return 0;
    }
  }
}
