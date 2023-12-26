import 'dart:math';

import 'package:master_diploma_vrp/main.dart';
import 'package:master_diploma_vrp/model/ant_activity_result.dart';
import 'package:master_diploma_vrp/model/ant_colony_result.dart';
import 'package:master_diploma_vrp/model/point_variant.dart';

class ACOVariant {
  final List<PointVariant> customers;

  ACOVariant({required this.customers});

  //d - matrix of distances
  //start is depot [0][0]
  AntColonyResult antColony(List<List<double>> d) {
    double bestLength = 9999999999;
    List<List<int>> bestPath = [];
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
        if (result == null) {
          continue;
        }
        if (result.length < bestLength) {
          bestLength = result.length;
          bestPath = result.l;
        }
        //evaporation
        for (int i = 0; i < pr.length; i++) {
          for (int j = 0; j < pr[i].length; j++) {
            pr[i][j] = pr[i][j] * (1 - delta);
          }
        }
      }
    }
    return AntColonyResult(bestLength: bestLength, bestPath: bestPath);
  }

  //d - matrix of distances
  //pr - matrix of pheromone
  //start and target are in depot [0][0]
  AntActivityResult? antActivity(List<List<double>> d, List<List<double>> pr) {
    final List<List<int>> l = [
      [0]
    ];
    final List<double> demand = [0.0];
    int cur = 0;
    double currentTime = 0.0;
    List<int> unservedCustomers = [];
    for (int i = 1; i < customers.length; i++) {
      unservedCustomers.add(i);
    }
    while (unservedCustomers.isNotEmpty) {
      List<int> candidateList = [];
      bool die = true;
      for (int i = 0; i < unservedCustomers.length; i++) {
        if (d[cur][unservedCustomers[i]] <= averageDistance * 1.5) {
          die = false;
        }
      }
      if (die && d[cur][0] > averageDistance * 1.5) {
        return null;
      }
      for (int i = 0; i < unservedCustomers.length; i++) {
        //check demand constraints
        if (demand[demand.length - 1] +
                customers[unservedCustomers[i]].demand <=
            vehicleCapacity) {
          //check time windows constraints
          if (currentTime + d[cur][unservedCustomers[i]] <=
              customers[unservedCustomers[i]].dueTime) {
            candidateList.add(unservedCustomers[i]);
          }
        }
      }
      if (candidateList.isEmpty) {
        //go to depot
        l[l.length - 1].add(0);
        l.add([0]);
        demand.add(0.0);
        currentTime = 0.0;
        cur = 0;
        continue;
      } else {
        List<double> probabilities = [];
        double probabilityDenominator = 0.0;
        for (int i = 0; i < candidateList.length; i++) {
          // final t = customers[candidateList[i]].dueTime -
          //     currentTime +
          //     d[cur][candidateList[i]];
          probabilityDenominator += pow(pr[cur][candidateList[i]], alpha) *
                  pow(1 / d[cur][candidateList[i]],
                      beta) /*
              pow(1 / t, gamma)*/
              ;
        }
        for (int i = 0; i < candidateList.length; i++) {
          // final t = customers[candidateList[i]].dueTime -
          //     currentTime +
          //     d[cur][candidateList[i]];
          double probabilityNumerator = (pow(pr[cur][candidateList[i]], alpha) *
                  pow(1 / d[cur][candidateList[i]],
                      beta) /*
                  pow(1 / t, gamma)*/
              )
              .toDouble();
          probabilities.add(probabilityNumerator / probabilityDenominator);
        }
        double rnd = Random().nextDouble();
        double sum = 0.0;
        for (int i = 0; i < probabilities.length; i++) {
          sum += probabilities[i];
          if (sum >= rnd) {
            currentTime += max(customers[candidateList[i]].fromTime,
                currentTime + d[cur][candidateList[i]]);
            currentTime += customers[candidateList[i]].serviceTime;
            cur = candidateList[i];
            l[l.length - 1].add(cur);
            unservedCustomers.remove(cur);
            demand[demand.length - 1] += customers[cur].demand;
            break;
          }
        }
      }
    }
    //go to depot
    l[l.length - 1].add(0);
    //calculate length
    double length = 0.0;
    int k = 0;
    for (int i = 0; i < l.length; i++) {
      for (int j = 0; j < l[i].length - 1; j++) {
        length += d[l[i][j]][l[i][j + 1]];
        k++;
      }
    }
    //update pheromone
    List<List<double>> prNew = [];
    prNew.addAll(pr);
    for (int i = 0; i < l.length; i++) {
      for (int j = 0; j < l[i].length - 1; j++) {
        prNew[l[i][j]][l[i][j + 1]] += upsilon / (k * length);
      }
    }
    return AntActivityResult(l: l, pr: prNew, demand: demand, length: length);
  }
}
