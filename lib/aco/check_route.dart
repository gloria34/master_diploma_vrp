import 'package:master_diploma_vrp/aco/tour.dart';

class CheckRoute {
  static bool check(List<Tour> solutions, Tour solution) {
    for (int i = 0; i < solutions.length; i++) {
      if (solution.numberOfCustomers >= solutions[i].numberOfCustomers &&
          solution.totalDistance >= solutions[i].totalDistance) {
        return false;
      }
    }
    return true;
  }

  static List<Tour> getDominatedSolutions(
      List<Tour> solutions, Tour solution) {
    List<Tour> dominatedSolutions = [];
    for (int i = 0; i < solutions.length; i++) {
      if (solution.numberOfCustomers <= solutions[i].numberOfCustomers &&
          solution.totalDistance <= solutions[i].totalDistance) {
        dominatedSolutions.add(solutions[i]);
      }
    }
    return dominatedSolutions;
  }
}
