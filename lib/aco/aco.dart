import 'dart:math';

import 'package:master_diploma_vrp/aco/heuristic.dart';
import 'package:master_diploma_vrp/aco/check_route.dart';
import 'package:master_diploma_vrp/model/problem.dart';
import 'package:master_diploma_vrp/aco/tour.dart';

class ACO {
  List<Tour> solutions = [];
  List<int> minNumbersOfVehicles = [];
  List<double> minDistances = [];

  static ACO aco(Problem problem, int start) {
    ACO aco = ACO();
    List<List<double>> pheromoneMatrix = [];
    Heuristic initHeuristics = Heuristic();
    initHeuristics = Heuristic.nearestNeighborHeuristic(problem);
    double pheromone = 1 /
        (initHeuristics.numberOfCustomers *
            initHeuristics.totalDistance); //initial pheromone
    for (int i = 0; i < problem.customer.length; i++) {
      List<double> pheromones = [];
      for (int j = 0; j < problem.customer.length; j++) {
        pheromones.add(0.0);
      }
      pheromoneMatrix.add(pheromones);
    }
    for (int i = 0; i < problem.customer.length - 1; i++) {
      for (int j = i + 1; j < problem.customer.length; j++) {
        pheromoneMatrix[i][j] = pheromone;
        pheromoneMatrix[j][i] = pheromoneMatrix[i][j];
      }
    }
    //Initialize solution and pheromone
    int improveCheck = 0;
    double fixPheromone = pheromone;
    for (int criteria = 0; criteria < problem.iteration; criteria++) {
      int end = DateTime.now().millisecondsSinceEpoch;
      int time = end - start;
      if (time > problem.time * 1000) return aco;
      for (int i = 1; i <= problem.numberOfAnts; i++) {
        Tour solution = Tour(); //ant i create a solution
        solution = Tour.tour(problem, pheromoneMatrix, fixPheromone);
        if (aco.solutions.isEmpty) aco.solutions.add(solution);
        if (CheckRoute.check(aco.solutions, solution) == true &&
            aco.solutions.isNotEmpty) {
          List<Tour> dominatedSolutions =
              CheckRoute.getDominatedSolutions(aco.solutions, solution);
          for (int j = 0; j < dominatedSolutions.length; j++) {
            aco.solutions.remove(dominatedSolutions[j]);
          }
          aco.solutions.add(solution);
        }
      }
      double pn = 0.0;
      double pJ = 0.0;
      for (int i = 0; i < aco.solutions.length; i++) {
        pn = pn + aco.solutions[i].numberOfCustomers;
        pJ = pJ + aco.solutions[i].totalDistance;
      }
      pn = pn / aco.solutions.length;
      pJ = pJ / aco.solutions.length;
      double tau0t = 1 / (pn * pJ);
      if (tau0t > pheromone) {
        improveCheck = 0;
        pheromone = tau0t;
      } else {
        improveCheck = improveCheck + 1;
        if (improveCheck >= problem.improve) {
          return aco;
        }
        //evaporate pheromone
        for (int i = 0; i < problem.customer.length; i++) {
          for (int j = i + 1; j < problem.customer.length; j++) {
            pheromoneMatrix[i][j] =
                (1.0 - problem.alpha) * pheromoneMatrix[i][j];
            pheromoneMatrix[j][i] = pheromoneMatrix[i][j];
          }
        }
        //global pheromone update
        for (int p = 0; p < aco.solutions.length; p++) {
          for (int vehicle = 0;
              vehicle < aco.solutions[p].route.length;
              vehicle++) {
            for (int i = 0;
                i < aco.solutions[p].route[vehicle].length - 1;
                i++) {
              int cusI = aco.solutions[p].route[vehicle][i];
              int cusJ = aco.solutions[p].route[vehicle][i + 1];
              pheromoneMatrix[cusI][cusJ] =
                  pheromoneMatrix[cusI][cusJ] + problem.alpha / pJ;
              pheromoneMatrix[cusJ][cusI] = pheromoneMatrix[cusI][cusJ];
            }
          }
        }
      }
      int minVehiclesNumber =
          aco.solutions[0].numberOfCustomers - (problem.customer.length - 1);
      double minDistance = aco.solutions[0].totalDistance;
      for (int i = 1; i < aco.solutions.length; i++) {
        minVehiclesNumber = min(minVehiclesNumber,
            aco.solutions[i].numberOfCustomers - (problem.customer.length - 1));
        minDistance = min(minDistance, aco.solutions[i].totalDistance);
      }
      aco.minNumbersOfVehicles.add(minVehiclesNumber);
      aco.minDistances.add(minDistance);
    }
    return aco;
  }
}
