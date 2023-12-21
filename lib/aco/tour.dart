import 'dart:math';

import 'package:master_diploma_vrp/model/problem.dart';

class Tour {
  List<List<int>> route = [];
  List<double> capacity = [];
  List<double> distance = [];
  late int numberOfCustomers;
  late double totalDistance = 0.0;

  static Tour tour(Problem problem, List<List<double>> tau, double tau_0) {
    Tour result = Tour();
    List<int> unservedCustomers = [];
    List<int> visitedCustomers = [0];
    result.route.add(visitedCustomers);
    result.distance.add(0.0);
    result.capacity.add(0);
    for (int i = 1; i < problem.customer.length; i++) {
      unservedCustomers.add(i);
    }
    int seed = 1000;
    Random rnd = Random(seed);
    while (unservedCustomers.isNotEmpty) {
      int lastPointId = result.route.length - 1;
      int lastCustomer =
          result.route[lastPointId][result.route[lastPointId].length - 1];
      int counter = 0;
      for (int i = 0; i < result.route[lastPointId].length; i++) {
        if (result.route[lastPointId][i] == 0) {
          counter = counter + 1; //check if the route is finished or not
        }
      }
      List<double> prob = [];
      double probabilityDenominator = 0.0;
      List<double> probabilityNumerator = [];
      List<double> fitTimeWindows = [];
      List<int> availableCustomers = [];
      double maxProbability;
      int index = 0;
      if (counter == 2) {
        result.route.add([0]); //start from depot
        result.distance.add(0.0);
        result.capacity.add(0);
        lastPointId = result.route.length - 1;
        availableCustomers = [];
        for (int i = 0; i < unservedCustomers.length; i++) {
          if (result.distance[result.distance.length - 1] +
                  problem.dist[lastCustomer][unservedCustomers[i]] <=
              problem.customer[unservedCustomers[i]].dueTime) {
            availableCustomers.add(unservedCustomers[i]);
          }
        }
        for (int i = 0; i < availableCustomers.length; i++) {
          double ctJ = max(problem.dist[0][availableCustomers[i]],
              problem.customer[availableCustomers[i]].fromTime);
          double deltaTij = ctJ;
          double dij = max(
              1.0, deltaTij * problem.customer[availableCustomers[i]].dueTime);
          fitTimeWindows.add(1 / dij);
        }
        //calculate the numerator of the probability
        for (int i = 0; i < fitTimeWindows.length; i++) {
          fitTimeWindows[i] = pow(fitTimeWindows[i], problem.beta).toDouble();
          probabilityNumerator
              .add(tau[0][availableCustomers[i]] * fitTimeWindows[i]);
        }

        maxProbability = probabilityNumerator[
            0]; //calculate the denominator of the probability and search max value in probability
        index = 0;
        for (int i = 0; i < fitTimeWindows.length; i++) {
          probabilityDenominator =
              probabilityDenominator + probabilityNumerator[i];
          if (maxProbability < probabilityNumerator[i]) {
            maxProbability = probabilityNumerator[i];
            index = i;
          }
        }
        for (int i = 0; i < fitTimeWindows.length; i++) {
          //calculate the probabilities
          prob.add(probabilityNumerator[i] / probabilityDenominator);
        }

        if (rnd.nextDouble() < problem.q0) {
          int next = availableCustomers[index];
          result.capacity[result.capacity.length - 1] =
              result.capacity[lastPointId] + problem.customer[next].demand;
          if (problem.dist[0][next] +
                  result.distance[result.distance.length - 1] <
              problem.customer[next].fromTime) {
            result.distance[result.distance.length - 1] =
                (problem.customer[next].fromTime +
                    problem.customer[next].serviceTime);
          } else {
            result.distance[result.distance.length - 1] =
                problem.dist[0][next] + problem.customer[next].serviceTime;
          }
          result.route[lastPointId].add(next);
          unservedCustomers.remove(next);
          //the ant drop pheromone as tracking
          tau[0][next] =
              (1.0 - problem.rho) * tau[0][next] + problem.rho * tau_0;
          tau[next][0] = tau[0][next];
        } else {
          double probabilitySum = 0.0;
          index = 0;
          List<double> tempProbability = prob;
          prob.sort();
          for (int i = 0; i < prob.length; i++) {
            probabilitySum = probabilitySum + prob[i];
            if (probabilitySum > rnd.nextDouble()) {
              index = tempProbability.indexOf(prob[i]);
              break;
            }
          }
          //the next customer is added to the route
          int next = availableCustomers[index];
          result.capacity[result.capacity.length - 1] =
              result.capacity[lastPointId] + problem.customer[next].demand;
          if (problem.dist[0][next] +
                  result.distance[result.distance.length - 1] <
              problem.customer[next].fromTime) {
            result.distance[result.distance.length - 1] =
                (problem.customer[next].fromTime +
                    problem.customer[next].serviceTime);
          } else {
            result.distance[result.distance.length - 1] =
                problem.dist[0][next] + problem.customer[next].serviceTime;
          }
          result.route[lastPointId].add(next);
          unservedCustomers.remove(next);
          //the ant drop pheromone as tracking
          tau[0][next] =
              (1.0 - problem.rho) * tau[0][next] + problem.rho * tau_0;
          tau[next][0] = tau[0][next];
        }
      } else {
        availableCustomers = [];
        for (int i = 0; i < unservedCustomers.length; i++) {
          //search nearest route from customer i
          if (result.distance[result.distance.length - 1] +
                  problem.dist[lastCustomer][unservedCustomers[i]] <=
              problem.customer[unservedCustomers[i]].dueTime) {
            //meet time constrain
            if (result.capacity[result.capacity.length - 1] +
                    problem.customer[unservedCustomers[i]].demand <=
                problem.maxVehicleCapacity) {
              //meet capacity constrain
              availableCustomers.add(unservedCustomers[i]);
            }
          }
        }
        if (availableCustomers.isEmpty) {
          //go back to depot
          result.route[lastPointId].add(0);
          result.distance[result.distance.length - 1] =
              result.distance[result.distance.length - 1] +
                  problem.dist[lastCustomer][0];
        } else {
          for (int i = 0; i < availableCustomers.length; i++) {
            double ctJ = max(
                result.distance[lastPointId] +
                    problem.dist[lastCustomer][availableCustomers[i]],
                problem.customer[availableCustomers[i]].fromTime);
            double deltaTij = ctJ - result.distance[lastPointId];
            double dij = max(
                1.0,
                deltaTij *
                    (problem.customer[availableCustomers[i]].dueTime -
                        result.distance[lastPointId]));
            fitTimeWindows.add(1 / dij);
          }
          //calculate the numerator of the probability
          for (int i = 0; i < fitTimeWindows.length; i++) {
            fitTimeWindows[i] = pow(fitTimeWindows[i], problem.beta).toDouble();
            probabilityNumerator.add(
                tau[lastCustomer][availableCustomers[i]] * fitTimeWindows[i]);
          }
          //calculate the denominator of the probability
          maxProbability = probabilityNumerator[0];
          index = 0;
          for (int i = 0; i < fitTimeWindows.length; i++) {
            probabilityDenominator =
                probabilityDenominator + probabilityNumerator[i];
            if (maxProbability < probabilityNumerator[i]) {
              maxProbability = probabilityNumerator[i];
              index = i;
            }
          }
          //calculate the probabilities
          for (int i = 0; i < fitTimeWindows.length; i++) {
            prob.add(probabilityNumerator[i] / probabilityDenominator);
          }

          if (rnd.nextDouble() < problem.q0) {
            //the case where the node j is chosen as next customer within probability q0
            int next = availableCustomers[index];
            result.capacity[result.capacity.length - 1] =
                result.capacity[lastPointId] + problem.customer[next].demand;
            if (problem.dist[lastCustomer][next] +
                    result.distance[result.distance.length - 1] <
                problem.customer[next].fromTime) {
              result.distance[result.distance.length - 1] =
                  (problem.customer[next].fromTime +
                      problem.customer[next].serviceTime);
            } else {
              result.distance[result.distance.length - 1] =
                  result.distance[lastPointId] +
                      problem.dist[lastCustomer][next] +
                      problem.customer[next].serviceTime;
            }
            result.route[lastPointId].add(next);
            unservedCustomers.remove(next);
            //the ant drop pheromone as tracking
            tau[lastCustomer][next] =
                (1.0 - problem.rho) * tau[lastCustomer][next] +
                    problem.rho * tau_0;
            tau[next][lastCustomer] = tau[lastCustomer][next];
          } else {
            //the case where the node j is chosen as next customer with probabilities
            //choose the next node j at probabilities
            double probSum = 0.0;
            index = 0;
            List<double> probTmp = prob;
            prob.sort();
            for (int i = 0; i < prob.length; i++) {
              probSum = probSum + prob[i];
              if (probSum > rnd.nextDouble()) {
                index = probTmp.indexOf(prob[i]);
                break;
              }
            }
            //the next customer is added to the route
            int next = availableCustomers[index];
            result.capacity[result.capacity.length - 1] =
                result.capacity[lastPointId] + problem.customer[next].demand;
            if (problem.dist[lastCustomer][next] +
                    result.distance[result.distance.length - 1] <
                problem.customer[next].fromTime) {
              result.distance[result.distance.length - 1] =
                  (problem.customer[next].fromTime +
                      problem.customer[next].serviceTime);
            } else {
              result.distance[result.distance.length - 1] =
                  result.distance[lastPointId] +
                      problem.dist[lastCustomer][next] +
                      problem.customer[next].serviceTime;
            }
            result.route[lastPointId].add(next);
            unservedCustomers.remove(next);
            //the ant drop pheromone as tracking
            tau[lastCustomer][next] =
                (1.0 - problem.rho) * tau[lastCustomer][next] +
                    problem.rho * tau_0;
            tau[next][lastCustomer] = tau[lastCustomer][next];
          }
        }
      }
    }
    result.route[result.route.length - 1].add(0);
    result.numberOfCustomers =
        result.route.length + problem.customer.length - 1;
    for (int i = 0; i < result.route.length; i++) {
      for (int j = 0; j < result.route[i].length - 1; j++) {
        result.totalDistance = result.totalDistance +
            problem.dist[result.route[i][j]][result.route[i][j + 1]];
      }
    }
    return result;
  }
}
