import 'dart:math';

import 'package:master_diploma_vrp/main.dart';
import 'package:master_diploma_vrp/model/customer_info.dart';
import 'package:master_diploma_vrp/model/problem_result.dart';

class DeterministicAnnealing {
  final List<CustomerInfo> customers;

  DeterministicAnnealing({required this.customers});

  ProblemResult deterministicAnnealing(List<List<double>> d) {
    List<List<int>> xTrip = generateInitialSolution(d);
    double xLength = calculateLength(d, xTrip);
    double x = xLength + calculateFines(d, xTrip);
    for (int i = 0; i < daIterations; i++) {
      double demonEnergy = initialDemonEnergy;
      int frozen = 0;
      int accepted = 0;
      int rejected = 0;
      while (frozen < 3) {
        List<List<int>> yTrip = getNeighbor(xTrip);
        double yLength = calculateLength(d, yTrip);
        double y = yLength + calculateFines(d, yTrip);
        final double delta = y - x;
        if (delta < demonEnergy && delta != 0.0) {
          xTrip = yTrip;
          xLength = yLength;
          x = y;
          frozen = 0;
          accepted++;
        } else {
          rejected++;
        }
        if (accepted == neighborhoodRadius ||
            rejected == 2 * neighborhoodRadius) {
          demonEnergy *= demonEnergyAlpha;
          if (rejected == 2 * neighborhoodRadius) {
            frozen++;
          }
          accepted = 0;
          rejected = 0;
        }
      }
    }
    return ProblemResult(bestLength: xLength, bestPath: xTrip);
  }

  List<List<int>> generateInitialSolution(List<List<double>> d) {
    List<List<int>> l = [
      [0]
    ];
    List<int> unservedCustomers = [];
    final List<double> demand = [0.0];
    int cur = 0;
    double currentTime = 0.0;
    for (int i = 1; i < customers.length; i++) {
      unservedCustomers.add(i);
    }
    while (unservedCustomers.isNotEmpty) {
      List<int> candidateList = [];
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
          probabilityDenominator += 1 / d[cur][candidateList[i]];
        }
        for (int i = 0; i < candidateList.length; i++) {
          double probabilityNumerator = 1 / d[cur][candidateList[i]];
          probabilities.add(probabilityNumerator / probabilityDenominator);
        }
        double rnd = Random().nextDouble();
        double sum = 0.0;
        for (int i = 0; i < probabilities.length; i++) {
          sum += probabilities[i];
          if (sum >= rnd) {
            currentTime = max(customers[candidateList[i]].fromTime,
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
    l[l.length - 1].add(0);
    return l;
  }

  double calculateLength(List<List<double>> d, List<List<int>> l) {
    double length = 0.0;
    for (int i = 0; i < l.length; i++) {
      for (int j = 0; j < l[i].length - 1; j++) {
        length += d[l[i][j]][l[i][j + 1]];
      }
    }
    return length;
  }

  double calculateFines(List<List<double>> d, List<List<int>> l) {
    for (int i = 0; i < l.length; i++) {
      double currentTime = 0.0;
      double demand = 0.0;
      for (int j = 0; j < l[i].length - 1; j++) {
        int fromCustomer = l[i][j];
        int toCustomer = l[i][j + 1];
        currentTime = max(customers[toCustomer].fromTime,
            currentTime + d[fromCustomer][toCustomer]);
        demand += customers[toCustomer].demand;
        if (currentTime > customers[toCustomer].dueTime) {
          return 9999999;
        }
        if (demand > vehicleCapacity) {
          return 9999999;
        }
        currentTime += customers[toCustomer].serviceTime;
      }
    }
    return 0.0;
  }

  List<List<int>> getNeighbor(List<List<int>> l) {
    final List<List<int>> neighbor = [];
    for (int i = 0; i < l.length; i++) {
      neighbor.add([]);
      for (int j = 0; j < l[i].length; j++) {
        neighbor[i].add(l[i][j]);
      }
    }
    int firstRandomRoute = Random().nextInt(l.length);
    int secondRandomRoute = Random().nextInt(l.length);
    while (firstRandomRoute == secondRandomRoute) {
      secondRandomRoute = Random().nextInt(l.length);
    }
    int firstRandomCustomer =
        Random().nextInt(l[firstRandomRoute].length - 2) + 1;
    int secondRandomCustomer =
        Random().nextInt(l[secondRandomRoute].length - 2) + 1;
    neighbor[firstRandomRoute][firstRandomCustomer] =
        l[secondRandomRoute][secondRandomCustomer];
    neighbor[secondRandomRoute][secondRandomCustomer] =
        l[firstRandomRoute][firstRandomCustomer];
    return neighbor;
  }
}
