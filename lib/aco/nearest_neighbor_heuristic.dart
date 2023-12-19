import 'package:master_diploma_vrp/model/problem.dart';

class NearestNeighborHeuristic {
  List<List<int>> route = [];
  List<double> capacity = [];
  List<double> distance = [];
  late double n; //the number of customers and depots
  late double
      J_nnh = 0.0; //J_nnh is total traveling time (without considering waiting time)

  static NearestNeighborHeuristic nnh(Problem problem) {
    NearestNeighborHeuristic ini_sol = NearestNeighborHeuristic();
    List<int> unsearved_customers =
        []; //customers have not already served by a vehicle
    List<int> route_ = [0];
    ini_sol.route.add(route_);
    ini_sol.distance.add(0.0);
    ini_sol.capacity.add(0);
    for (int i = 1; i < problem.customer.length; i++)
      unsearved_customers.add(i);

    while (unsearved_customers.length != 0) {
      List<int> meet_const_customer = [];
      double min_dist;
      int index;
      int last_vehicle_ind = ini_sol.route.length - 1;
      int last_customer = ini_sol.route[last_vehicle_ind]
          [ini_sol.route[last_vehicle_ind].length - 1];
      int counter = 0;
      for (int i = 0; i < ini_sol.route[last_vehicle_ind].length; i++)
        if (ini_sol.route[last_vehicle_ind][i] == 0)
          counter = counter + 1; //check if the route is finished or not
      switch (counter) {
        case 2: //construct a new route (the route was finished constructing)
          List<int> route_1 = [0];
          ini_sol.route.add(route_1); //start from depot
          ini_sol.distance.add(0.0);
          ini_sol.capacity.add(0);
          last_vehicle_ind = ini_sol.route.length -
              1; //last_vehicle_ind was changed because the new route was created

          //search customers do not violate constrains
          meet_const_customer = [];
          for (int i = 0; i < unsearved_customers.length; i++) {
            if (ini_sol.distance[ini_sol.distance.length - 1] +
                    problem.dist[last_customer][unsearved_customers[i]] <=
                problem.customer[unsearved_customers[i]].dueTime) {
              //meet time constrain
              meet_const_customer.add(unsearved_customers[i]);
            }
          }

          //find nearest route from depot from meet_const_customer
          min_dist = problem.dist[0][meet_const_customer[0]];
          index = meet_const_customer[0];
          for (int i = 1; i < meet_const_customer.length; i++) {
            //search nearest route from depot
            double x = problem.dist[0][meet_const_customer[i]];
            if (x < min_dist) {
              min_dist = x;
              index = meet_const_customer[i];
            }
          }
          //find nearest route from depot from meet_const_customer

          //first customer is added to route and capacity and distance and remove from unsearved_customers
          ini_sol.capacity[ini_sol.capacity.length - 1] =
              ini_sol.capacity[last_vehicle_ind] +
                  problem.customer[index].demand;
          if (problem.dist[0][index] +
                  ini_sol.distance[ini_sol.distance.length - 1] <
              problem.customer[index].fromTime) {
            ini_sol.distance[ini_sol.distance.length - 1] =
                (problem.customer[index].fromTime +
                    problem.customer[index].serviceTime);
          } else
            ini_sol.distance[ini_sol.distance.length - 1] =
                problem.dist[0][index] + problem.customer[index].serviceTime;
          ini_sol.route[last_vehicle_ind].add(index);
          unsearved_customers.remove(index);
          break;

        default: //search next customer to be ridden
          //search customers do not violate constrains
          meet_const_customer = [];
          for (int i = 0; i < unsearved_customers.length; i++) {
            //search nearest route from customer i
            if (ini_sol.distance[ini_sol.distance.length - 1] +
                    problem.dist[last_customer][unsearved_customers[i]] <=
                problem.customer[unsearved_customers[i]].dueTime) {
              //meet time constrain
              if (ini_sol.capacity[ini_sol.capacity.length - 1] +
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
              ini_sol.route[last_vehicle_ind].add(0);
              ini_sol.distance[ini_sol.distance.length - 1] =
                  ini_sol.distance[ini_sol.distance.length - 1] +
                      problem.dist[last_customer][0];
              break;

            default: //there are customers meet constrains

              //find nearest route from last_customer from meet_const_customer
              min_dist = problem.dist[last_customer][meet_const_customer[0]];
              index = meet_const_customer[0];
              for (int i = 1; i < meet_const_customer.length; i++) {
                double x = problem.dist[0][meet_const_customer[i]];
                if (x < min_dist) {
                  min_dist = x;
                  index = meet_const_customer[i];
                }
              }
              //find nearest route from last_customer from meet_const_customer

              //customer is added to route and capacity and distance and remove from unsearved_customers
              ini_sol.capacity[ini_sol.capacity.length - 1] =
                  ini_sol.capacity[ini_sol.capacity.length - 1] +
                      problem.customer[index].demand;
              if (problem.dist[last_customer][index] +
                      ini_sol.distance[ini_sol.distance.length - 1] <
                  problem.customer[index].fromTime) {
                ini_sol.distance[ini_sol.distance.length - 1] =
                    (problem.customer[index].fromTime +
                        problem.customer[index].serviceTime);
              } else
                ini_sol.distance[ini_sol.distance.length - 1] =
                    ini_sol.distance[ini_sol.distance.length - 1] +
                        problem.dist[last_customer][index] +
                        problem.customer[index].serviceTime;
              ini_sol.route[last_vehicle_ind].add(index);
              unsearved_customers.remove(index);
          }
      }
    }
    ini_sol.route[ini_sol.route.length - 1].add(0);
    ini_sol.n = ini_sol.route.length + problem.customer.length - 1;
    for (int i = 0; i < ini_sol.route.length; i++) {
      for (int j = 0; j < ini_sol.route[i].length - 1; j++) {
        ini_sol.J_nnh = ini_sol.J_nnh +
            problem.dist[ini_sol.route[i][j]][ini_sol.route[i][j + 1]];
      }
    }
    return ini_sol;
  }
}
