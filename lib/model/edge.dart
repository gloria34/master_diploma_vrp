import 'dart:math';

import 'package:master_diploma_vrp/model/point.dart';

class Edge {
  final Point startLocation;
  final Point endLocation;
  double pheromone;
  final List<double> costs = [];

  Edge(
      {required this.pheromone,
      required this.startLocation,
      required this.endLocation});

  double getDistance() {
    return sqrt(pow((startLocation.x - endLocation.x), 2) +
        pow((startLocation.y - endLocation.y), 2));
  }
}
