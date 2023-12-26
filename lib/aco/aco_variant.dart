import 'dart:math';

import 'package:master_diploma_vrp/main.dart';
import 'package:master_diploma_vrp/model/ant_colony_result.dart';
import 'package:master_diploma_vrp/model/ant_path_result.dart';
import 'package:master_diploma_vrp/model/point_variant.dart';

class ACOVariant {
  final List<PointVariant> customers;

  ACOVariant({required this.customers});

  //d - matrix of distances
  //start is depot [0][0]
  AntColonyResult antColony(List<List<double>> d) {
    double bestLength = 9999999999;
    List<int> bestPath = [];
    for (int it = 0; it < iterations; it++) {
      //initialize pheromone matrix
      List<List<double>> pr = [];
      for (int i = 0; i < customers.length; i++) {
        pr.add([]);
        for (int j = 0; j < customers.length; j++) {
          pr[i].add(xi);
        }
      }
      for (int i = 0; i < ants; i++) {
        final result = antActivity(d, pr);
        if (result.length < bestLength) {
          bestLength = result.length;
          bestPath = result.path;
        }
        //evaporation
        for (int i = 0; i < pr.length; i++) {
          for (int j = 0; j < pr[i].length; j++) {
            pr[i][j] = pr[i][j] * (1 - delta);
          }
        }
      }
    }
    List<List<int>> bestPathResult = [];
    int k = 0;
    for (int i = 0; i < bestPath.length; i++) {
      if (bestPathResult.length - 1 < k) {
        bestPathResult.add([]);
      }
      bestPathResult[k].add(bestPath[i]);
      if (bestPath[i] == 0 && bestPathResult[k].length > 1) {
        k++;
      }
    }

    return AntColonyResult(bestLength: bestLength, bestPath: bestPathResult);
  }

  //d - matrix of distances
  //pr - matrix of pheromone
  //start and target are in depot [0][0]
  AntPathResult antActivity(List<List<double>> d, List<List<double>> pr) {
    List<int> path = [0]; // start at depot
    List<int> unvisited = List<int>.generate(customers.length, (i) => i)
      ..remove(0); // all customers except depot

    while (unvisited.isNotEmpty) {
      int lastVisited = path.last;
      List<double> probabilities = unvisited
          .map((i) =>
              pow(pr[lastVisited][i], alpha) / pow(d[lastVisited][i], beta))
          .toList();

      double sum = probabilities.reduce((a, b) => a + b);
      probabilities = probabilities.map((p) => p / sum).toList();

      int nextCustomer = rouletteWheelSelection(probabilities);
      unvisited.remove(nextCustomer);
      path.add(nextCustomer);
    }

    path.add(0); // return to depot

    double length = calculatePathLength(path, d);

    return AntPathResult(length: length, path: path);
  }

  int rouletteWheelSelection(List<double> probabilities) {
    double r = Random().nextDouble();
    double c = 0.0;
    for (int i = 0; i < probabilities.length; i++) {
      c += probabilities[i];
      if (c >= r) {
        return i;
      }
    }
    return probabilities.length -
        1; // return last index if no selection made (should not happen if probabilities sum to 1)
  }

  double calculatePathLength(List<int> path, List<List<double>> d) {
    double length = 0.0;
    for (int i = 0; i < path.length - 1; i++) {
      length += d[path[i]][path[i + 1]];
    }
    return length;
  }
}
