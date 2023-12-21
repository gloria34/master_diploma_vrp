import 'package:master_diploma_vrp/model/problem.dart';

class Heuristic {
  List<List<int>> route = [];
  List<double> capacity = [];
  List<double> distance = [];
  late double numberOfCustomers;
  late double totalDistance = 0.0;

  static Heuristic nearestNeighborHeuristic(Problem problem) {
    Heuristic result = Heuristic();
    List<int> unservedCustomers = [];
    List<int> visitedCustomers = [0];
    result.route.add(visitedCustomers);
    result.distance.add(0.0);
    result.capacity.add(0);
    for (int i = 1; i < problem.customer.length; i++) {
      unservedCustomers.add(i);
    }

    while (unservedCustomers.isNotEmpty) {
      List<int> availableCustomers = [];
      double minDistance;
      int index;
      int lastVehicle = result.route.length - 1;
      int lastCustomer =
          result.route[lastVehicle][result.route[lastVehicle].length - 1];
      int counter = 0;
      for (int i = 0; i < result.route[lastVehicle].length; i++) {
        if (result.route[lastVehicle][i] == 0) {
          counter = counter + 1; //check if the route is finished or not
        }
      }
      if (counter == 2) {
        result.route.add([0]); //start from depot
        result.distance.add(0.0);
        result.capacity.add(0);
        lastVehicle = result.route.length - 1;
        availableCustomers = []; //search available customers
        for (int i = 0; i < unservedCustomers.length; i++) {
          if (result.distance[result.distance.length - 1] +
                  problem.dist[lastCustomer][unservedCustomers[i]] <=
              problem.customer[unservedCustomers[i]].dueTime) {
            availableCustomers
                .add(unservedCustomers[i]); //meet time constraints
          }
        }
        minDistance = problem.dist[0][availableCustomers[0]];
        index = availableCustomers[0];
        for (int i = 1; i < availableCustomers.length; i++) {
          double x = problem.dist[0][availableCustomers[i]];
          if (x < minDistance) {
            minDistance = x;
            index = availableCustomers[i];
          }
        }
        result.capacity[result.capacity.length - 1] =
            result.capacity[lastVehicle] + problem.customer[index].demand;
        if (problem.dist[0][index] +
                result.distance[result.distance.length - 1] <
            problem.customer[index].fromTime) {
          result.distance[result.distance.length - 1] =
              (problem.customer[index].fromTime +
                  problem.customer[index].serviceTime);
        } else {
          result.distance[result.distance.length - 1] =
              problem.dist[0][index] + problem.customer[index].serviceTime;
        }
        result.route[lastVehicle].add(index);
        unservedCustomers.remove(index);
      } else {
        availableCustomers = [];
        for (int i = 0; i < unservedCustomers.length; i++) {
          if (result.distance[result.distance.length - 1] +
                  problem.dist[lastCustomer][unservedCustomers[i]] <=
              problem.customer[unservedCustomers[i]].dueTime) {
            if (result.capacity[result.capacity.length - 1] +
                    problem.customer[unservedCustomers[i]].demand <=
                problem.maxVehicleCapacity) {
              availableCustomers
                  .add(unservedCustomers[i]); //meet capacity constrain
            }
          }
        }
        if (availableCustomers.isEmpty) {
          result.route[lastVehicle].add(0); //go in depot
          result.distance[result.distance.length - 1] =
              result.distance[result.distance.length - 1] +
                  problem.dist[lastCustomer][0];
        } else {
          minDistance = problem.dist[lastCustomer][availableCustomers[0]];
          index = availableCustomers[0];
          for (int i = 1; i < availableCustomers.length; i++) {
            double x = problem.dist[0][availableCustomers[i]];
            if (x < minDistance) {
              minDistance = x;
              index = availableCustomers[i];
            }
          }
          result.capacity[result.capacity.length - 1] =
              result.capacity[result.capacity.length - 1] +
                  problem.customer[index].demand;
          if (problem.dist[lastCustomer][index] +
                  result.distance[result.distance.length - 1] <
              problem.customer[index].fromTime) {
            result.distance[result.distance.length - 1] =
                (problem.customer[index].fromTime +
                    problem.customer[index].serviceTime);
          } else {
            result.distance[result.distance.length - 1] =
                result.distance[result.distance.length - 1] +
                    problem.dist[lastCustomer][index] +
                    problem.customer[index].serviceTime;
          }
          result.route[lastVehicle].add(index);
          unservedCustomers.remove(index);
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
