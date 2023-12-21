import 'dart:developer' as d;
import 'dart:math';

import 'package:master_diploma_vrp/aco/heuristic.dart';
import 'package:master_diploma_vrp/aco/check_route.dart';
import 'package:master_diploma_vrp/model/problem.dart';
import 'package:master_diploma_vrp/aco/tour.dart';

class ACOVariant {
  List<Tour> pareto_sols = [];
  List<int> min_vehinum_tracker = [];
  List<double> min_distance_tracker = [];

  static ACOVariant ant_main(Problem problem, int start) {
    ACOVariant aco = ACOVariant();
    List<List<double>> tau = []; //tau = pheromone matrix

    //Initialize solution and pheromone
    Heuristic ini_sol = new Heuristic();
    ini_sol = Heuristic.nearestNeighborHeuristic(
        problem); //initial solution which is perfectly meet constrains
    double tau_0 = 1 /
        (ini_sol.numberOfCustomers * ini_sol.totalDistance); //initial pheromone
    for (int i = 0; i < problem.customer.length; i++) {
      List<double> phe_mat = [];
      for (int j = 0; j < problem.customer.length; j++) {
        phe_mat.add(0.0);
      }
      tau.add(phe_mat);
    }
    for (int i = 0; i < problem.customer.length - 1; i++) {
      for (int j = i + 1; j < problem.customer.length; j++) {
        tau[i][j] = tau_0;
        tau[j][i] = tau[i][j];
      }
    }
    //Initialize solution and pheromone

    int improve_check = 0;
    double fix_tau_0 = tau_0;
    for (int criteria = 0; criteria < problem.iteration; criteria++) {
      int end = DateTime.now().millisecondsSinceEpoch;
      int e_s = end - start;
      if (e_s > problem.time * 1000) return aco;

      for (int i = 1; i <= problem.numberOfAnts; i++) {
        Tour solution = Tour(); //ant i create a solution
        solution = Tour.tour(problem, tau, fix_tau_0);
        if (aco.pareto_sols.length == 0) aco.pareto_sols.add(solution);
        if (CheckRoute.check(aco.pareto_sols, solution) == true &&
            aco.pareto_sols.length != 0) {
          //the case where the solution is in pareto solutions
          List<Tour> dominated_sols_ind =
              CheckRoute.getDominatedSolutions(aco.pareto_sols, solution);
          for (int j = 0; j < dominated_sols_ind.length; j++)
            aco.pareto_sols.remove(dominated_sols_ind[
                j]); //remove dominated solutions from aco.pareto_sols
          aco.pareto_sols.add(solution); //new solution is added to pareto_sols
        }
      }

      double P_n = 0.0;
      double P_J = 0.0;
      for (int i = 0; i < aco.pareto_sols.length; i++) {
        P_n = P_n + aco.pareto_sols[i].numberOfCustomers;
        P_J = P_J + aco.pareto_sols[i].totalDistance;
      }
      P_n =
          P_n / aco.pareto_sols.length; //the average value in pareto solutions
      P_J =
          P_J / aco.pareto_sols.length; //the average value in pareto solutions

      double tau_0t = 1 / (P_n * P_J); //calculate tau_0t
      if (tau_0t > tau_0) {
        //pareto solutions are better than before
        improve_check = 0;
        tau_0 = tau_0t; //update tau_0
        d.log("better solution was found");
      } else {
        //pareto solutions are not better than before (global update)
        improve_check = improve_check + 1;
        if (improve_check >= problem.improve) {
          return aco;
          /*
					for (int i=0; i<problem.customer.length; i++) {
						for (int j=i+1; j<problem.customer.length; j++) {
								tau[i].set(j, tau_0);
								tau[j].set(i, tau_0);
						}
					}
					*/
        }

        //evaporate pheromone
        for (int i = 0; i < problem.customer.length; i++) {
          for (int j = i + 1; j < problem.customer.length; j++) {
            tau[i][j] = (1.0 - problem.alpha) * tau[i][j];
            tau[j][i] = tau[i][j];
          }
        }

        //global pheromon update
        for (int p = 0; p < aco.pareto_sols.length; p++) {
          for (int vehi = 0; vehi < aco.pareto_sols[p].route.length; vehi++) {
            for (int i = 0;
                i < aco.pareto_sols[p].route[vehi].length - 1;
                i++) {
              int cus_i = aco.pareto_sols[p].route[vehi][i];
              int cus_j = aco.pareto_sols[p].route[vehi][i + 1];
              tau[cus_i][cus_j] = tau[cus_i][cus_j] + problem.alpha / P_J;
              tau[cus_j][cus_i] = tau[cus_i][cus_j];
            }
          }
        }
      }

      //tracking minimum vehicle number, total time and total distance
      int min_vehinum =
          aco.pareto_sols[0].numberOfCustomers - (problem.customer.length - 1);
      double min_distance = aco.pareto_sols[0].totalDistance;
      for (int i = 1; i < aco.pareto_sols.length; i++) {
        min_vehinum = min(
            min_vehinum,
            aco.pareto_sols[i].numberOfCustomers -
                (problem.customer.length - 1));
        min_distance = min(min_distance, aco.pareto_sols[i].totalDistance);
      }

      aco.min_vehinum_tracker.add(min_vehinum);
      aco.min_distance_tracker.add(min_distance);
    }

    return aco;
  }
}
