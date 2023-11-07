import 'dart:math';

import 'package:master_diploma_vrp/model/point.dart';

class Edge {
  final Point startLocation;
  final Point endLocation;
  double pheromone;
  double heuristic;

  Edge(
      {required this.pheromone,
      required this.startLocation,
      required this.endLocation,
      required this.heuristic});

  double getDistance() {
    return sqrt(pow((startLocation.x - endLocation.x), 2) +
        pow((startLocation.y - endLocation.y), 2));
  }

  double _calculateArrivalTime(double currentTime) {
    double travelTime = getDistance();
    double arrivalTime = currentTime + travelTime;
    return arrivalTime;
  }

  double calculateHeuristicValue(double maxDistance, double currentTime,
      double remainingCapacity, double maxTime) {
    double distanceFactor = _calculateDistanceFactor(maxDistance);
    double timeWindowFactor = _calculateTimeWindowFactor(currentTime, maxTime);
    double demandFactor = _calculateDemandFactor(remainingCapacity);
    double heuristicValue = distanceFactor * timeWindowFactor * demandFactor;
    return heuristicValue;
  }

  double _calculateDistanceFactor(double maxDistance) {
    double euclideanDistance = getDistance();
    double distanceFactor = 1.0 - (euclideanDistance / maxDistance);
    return distanceFactor;
  }

  double _calculateTimeWindowFactor(double currentTime, double maxTime) {
    double arrivalTime = _calculateArrivalTime(currentTime);
    if (arrivalTime >= endLocation.fromTime &&
        arrivalTime <= endLocation.dueTime) {
      return 1.0;
    }
    if (arrivalTime < endLocation.fromTime) {
      return 1 - ((arrivalTime - endLocation.fromTime) / maxTime);
    } else {
      return 0.0;
    }
  }

  double _calculateDemandFactor(double remainingCapacity) {
    double customerDemand = endLocation.demand;
    if (customerDemand <= remainingCapacity) {
      return 1.0;
    } else {
      return 0.0;
    }
  }
}
