import 'dart:math';

import 'package:master_diploma_vrp/main.dart';
import 'package:master_diploma_vrp/model/ant.dart';
import 'package:master_diploma_vrp/model/edge.dart';

abstract class Probability {
  static double calculateProbability(Ant ant, Edge edge) {
    final arrivalTime = ant.route.time + edge.getDistance();
    final dueTime = edge.endLocation.dueTime;
    final remainingTime = dueTime - arrivalTime;
    return (pow(edge.pheromone, pheromoneImportance) *
        pow(1 / edge.getDistance(), heuristicImportance) *
        pow(1 / remainingTime, timeWindowsImportance)).toDouble();
  }
}
