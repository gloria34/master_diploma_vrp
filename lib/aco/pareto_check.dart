import 'package:master_diploma_vrp/model/tour.dart';

class ParetoCheck {
  static bool check(List<Tour> pareto_sols, Tour solution) {
    for (int i = 0; i < pareto_sols.length; i++) {
      if (solution.n >= pareto_sols[i].n && solution.J >= pareto_sols[i].J) {
        return false; //new solution is not a pareto solution
      }
    }
    return true; //new solution is a pareto solution
  }

  static List<Tour> rm_ind(List<Tour> pareto_sols, Tour solution) {
    List<Tour> dominated_sols_ind = [];
    for (int i = 0; i < pareto_sols.length; i++) {
      if (solution.n <= pareto_sols[i].n && solution.J <= pareto_sols[i].J) {
        dominated_sols_ind.add(pareto_sols[i]);
      }
    }
    return dominated_sols_ind;
  }
}
