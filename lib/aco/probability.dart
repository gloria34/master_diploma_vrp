import 'package:master_diploma_vrp/aco/heuristic.dart';
import 'package:master_diploma_vrp/main.dart';
import 'package:master_diploma_vrp/model/ant.dart';
import 'package:master_diploma_vrp/model/edge.dart';

abstract class Probability {
  static double calculateProbability(Ant ant, Edge edge) {
    return edge.pheromone *
        pheromoneImportance *
        Heuristic.claculateHeuristic(ant, edge);
  }
}
