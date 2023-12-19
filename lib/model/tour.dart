import 'dart:math';

import 'package:master_diploma_vrp/model/problem.dart';

class Tour {
  List<List<int>> route = [];
  List<double> capacity = [];
  List<double> distance = [];
  late int n; //the number of customers and depots
  late double J =
      0.0; //J_nnh is total distance (without considering waiting time)

  static Tour tour(Problem problem, List<List<double>> tau, double tau_0) {
    Tour sol = Tour();
    List<int> unsearved_customers =
        []; //customers have not already served by a vehicle
    List<int> route_ = [0];
    sol.route.add(route_);
    sol.distance.add(0.0);
    sol.capacity.add(0);
    for (int i = 1; i < problem.customer.length; i++)
      unsearved_customers.add(i);
    int seed = 1000;
    Random rnd = Random(seed);

    while (unsearved_customers.isNotEmpty) {
      int last_vehicle_ind = sol.route.length - 1;
      int last_customer =
          sol.route[last_vehicle_ind][sol.route[last_vehicle_ind].length - 1];
      int counter = 0;
      for (int i = 0; i < sol.route[last_vehicle_ind].length; i++)
        if (sol.route[last_vehicle_ind][i] == 0)
          counter = counter + 1; //check if the route is finished or not
      List<double> prob = [];
      double prob_denom = 0.0; //denominator of probability
      List<double> prob_nume = []; //numerator of probability
      List<double> nu_L = []; //the formula considered time window
      List<int> meet_const_customer = [];
      double max_prob_nume;
      int index = 0;
      switch (counter) {
        case 2: //construct a new route (the route was finished constructing)
          List<int> route_1 = [0];
          sol.route.add(route_1); //start from depot
          sol.distance.add(0.0);
          sol.capacity.add(0);
          last_vehicle_ind = sol.route.length -
              1; //last_vehicle_ind was changed because the new route was created

          //search customers do not violate constrains
          meet_const_customer = [];
          for (int i = 0; i < unsearved_customers.length; i++) {
            if (sol.distance[sol.distance.length - 1] +
                    problem.dist[last_customer][unsearved_customers[i]] <=
                problem.customer[unsearved_customers[i]].dueTime) {
              //meet time constrain
              meet_const_customer.add(unsearved_customers[i]);
            }
          }

          //calculate and nu_L (array)
          for (int i = 0; i < meet_const_customer.length; i++) {
            double ct_j = max(problem.dist[0][meet_const_customer[i]],
                problem.customer[meet_const_customer[i]].fromTime);
            double delta_tij = ct_j;
            double d_ij = max(1.0,
                delta_tij * problem.customer[meet_const_customer[i]].dueTime);
            nu_L.add(1 / d_ij);
          }
          //calculate the numerator of the probability and the power of nu_L
          for (int i = 0; i < nu_L.length; i++) {
            nu_L[i] = pow(nu_L[i], problem.beta).toDouble();
            prob_nume.add(tau[0][meet_const_customer[i]] * nu_L[i]);
          }
          //calculate the denominator of the probability and search max value in probability
          max_prob_nume = prob_nume[0];
          index = 0;
          for (int i = 0; i < nu_L.length; i++) {
            prob_denom = prob_denom + prob_nume[i];
            if (max_prob_nume < prob_nume[i]) {
              max_prob_nume = prob_nume[i];
              index = i;
            }
          }
          //calculate the probabilities
          for (int i = 0; i < nu_L.length; i++)
            prob.add(prob_nume[i] / prob_denom);

          if (rnd.nextDouble() < problem.q0) {
            //the case where the node j is chosen as next customer within probability q0
            int next = meet_const_customer[index];
            sol.capacity[sol.capacity.length - 1] =
                sol.capacity[last_vehicle_ind] + problem.customer[next].demand;
            if (problem.dist[0][next] + sol.distance[sol.distance.length - 1] <
                problem.customer[next].fromTime) {
              sol.distance[sol.distance.length - 1] =
                  (problem.customer[next].fromTime +
                      problem.customer[next].serviceTime);
            } else
              sol.distance[sol.distance.length - 1] =
                  problem.dist[0][next] + problem.customer[next].serviceTime;
            sol.route[last_vehicle_ind].add(next);
            unsearved_customers.remove(next);
            //the ant drop pheromone as tracking
            tau[0][next] =
                (1.0 - problem.rho) * tau[0][next] + problem.rho * tau_0;
            tau[next][0] = tau[0][next];
          } else {
            //the case where the node j is chosen as next customer with probabilities
            //choose the next node j at probabilities
            double prob_sum = 0.0;
            index = 0;
            List<double> prob_tmp = prob;
            prob.sort();
            for (int i = 0; i < prob.length; i++) {
              prob_sum = prob_sum + prob[i];
              if (prob_sum > rnd.nextDouble()) {
                index = prob_tmp.indexOf(prob[i]);
                break;
              }
            }
            //the next customer is added to the route
            int next = meet_const_customer[index];
            sol.capacity[sol.capacity.length - 1] =
                sol.capacity[last_vehicle_ind] + problem.customer[next].demand;
            if (problem.dist[0][next] + sol.distance[sol.distance.length - 1] <
                problem.customer[next].fromTime) {
              sol.distance[sol.distance.length - 1] =
                  (problem.customer[next].fromTime +
                      problem.customer[next].serviceTime);
            } else
              sol.distance[sol.distance.length - 1] =
                  problem.dist[0][next] + problem.customer[next].serviceTime;
            sol.route[last_vehicle_ind].add(next);
            unsearved_customers.remove(next);
            //the ant drop pheromone as tracking
            tau[0][next] =
                (1.0 - problem.rho) * tau[0][next] + problem.rho * tau_0;
            tau[next][0] = tau[0][next];
          }

          break;

        default: //search next customer to be ridden
          //search customers do not violate constrains
          meet_const_customer = [];
          for (int i = 0; i < unsearved_customers.length; i++) {
            //search nearest route from customer i
            if (sol.distance[sol.distance.length - 1] +
                    problem.dist[last_customer][unsearved_customers[i]] <=
                problem.customer[unsearved_customers[i]].dueTime) {
              //meet time constrain
              if (sol.capacity[sol.capacity.length - 1] +
                      problem.customer[unsearved_customers[i]].demand <=
                  problem.max_capacity) {
                //meet capacity constrain
                meet_const_customer.add(unsearved_customers[i]);
              }
            }
          }

          switch (meet_const_customer.length) {
            case 0: //there is no customer meets constrains
              //go back to depot
              sol.route[last_vehicle_ind].add(0);
              sol.distance[sol.distance.length - 1] =
                  sol.distance[sol.distance.length - 1] +
                      problem.dist[last_customer][0];
              break;

            default: //there are customers meet constrains
              //calculate and nu_L (array)
              for (int i = 0; i < meet_const_customer.length; i++) {
                double ct_j = max(
                    sol.distance[last_vehicle_ind] +
                        problem.dist[last_customer][meet_const_customer[i]],
                    problem.customer[meet_const_customer[i]].fromTime);
                double delta_tij = ct_j - sol.distance[last_vehicle_ind];
                double d_ij = max(
                    1.0,
                    delta_tij *
                        (problem.customer[meet_const_customer[i]].dueTime -
                            sol.distance[last_vehicle_ind]));
                nu_L.add(1 / d_ij);
              }
              //calculate the numerator of the probability and the power of nu_L
              for (int i = 0; i < nu_L.length; i++) {
                nu_L[i] = pow(nu_L[i], problem.beta).toDouble();
                prob_nume
                    .add(tau[last_customer][meet_const_customer[i]] * nu_L[i]);
              }
              //calculate the denominator of the probability
              max_prob_nume = prob_nume[0];
              index = 0;
              for (int i = 0; i < nu_L.length; i++) {
                prob_denom = prob_denom + prob_nume[i];
                if (max_prob_nume < prob_nume[i]) {
                  max_prob_nume = prob_nume[i];
                  index = i;
                }
              }
              //calculate the probabilities
              for (int i = 0; i < nu_L.length; i++)
                prob.add(prob_nume[i] / prob_denom);

              if (rnd.nextDouble() < problem.q0) {
                //the case where the node j is chosen as next customer within probability q0
                int next = meet_const_customer[index];
                sol.capacity[sol.capacity.length - 1] =
                    sol.capacity[last_vehicle_ind] +
                        problem.customer[next].demand;
                if (problem.dist[last_customer][next] +
                        sol.distance[sol.distance.length - 1] <
                    problem.customer[next].fromTime) {
                  sol.distance[sol.distance.length - 1] =
                      (problem.customer[next].fromTime +
                          problem.customer[next].serviceTime);
                } else
                  sol.distance[sol.distance.length - 1] =
                      sol.distance[last_vehicle_ind] +
                          problem.dist[last_customer][next] +
                          problem.customer[next].serviceTime;
                sol.route[last_vehicle_ind].add(next);
                unsearved_customers.remove(next);
                //the ant drop pheromone as tracking
                tau[last_customer][next] =
                    (1.0 - problem.rho) * tau[last_customer][next] +
                        problem.rho * tau_0;
                tau[next][last_customer] = tau[last_customer][next];
              } else {
                //the case where the node j is chosen as next customer with probabilities
                //choose the next node j at probabilities
                double prob_sum = 0.0;
                index = 0;
                List<double> prob_tmp = prob;
                prob.sort();
                for (int i = 0; i < prob.length; i++) {
                  prob_sum = prob_sum + prob[i];
                  if (prob_sum > rnd.nextDouble()) {
                    index = prob_tmp.indexOf(prob[i]);
                    break;
                  }
                }

                //the next customer is added to the route
                int next = meet_const_customer[index];
                sol.capacity[sol.capacity.length - 1] =
                    sol.capacity[last_vehicle_ind] +
                        problem.customer[next].demand;
                if (problem.dist[last_customer][next] +
                        sol.distance[sol.distance.length - 1] <
                    problem.customer[next].fromTime) {
                  sol.distance[sol.distance.length - 1] =
                      (problem.customer[next].fromTime +
                          problem.customer[next].serviceTime);
                } else
                  sol.distance[sol.distance.length - 1] =
                      sol.distance[last_vehicle_ind] +
                          problem.dist[last_customer][next] +
                          problem.customer[next].serviceTime;
                sol.route[last_vehicle_ind].add(next);
                unsearved_customers.remove(next);
                //the ant drop pheromone as tracking
                tau[last_customer][next] =
                    (1.0 - problem.rho) * tau[last_customer][next] +
                        problem.rho * tau_0;
                tau[next][last_customer] = tau[last_customer][next];
              }
          }
      }
    }
    sol.route[sol.route.length - 1].add(0);
    sol.n = sol.route.length + problem.customer.length - 1;
    for (int i = 0; i < sol.route.length; i++) {
      for (int j = 0; j < sol.route[i].length - 1; j++) {
        sol.J = sol.J + problem.dist[sol.route[i][j]][sol.route[i][j + 1]];
      }
    }
    return sol;
  }
}
