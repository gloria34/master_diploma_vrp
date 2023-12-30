import 'dart:math';

import 'package:master_diploma_vrp/model/customer_info.dart';
import 'package:master_diploma_vrp/model/problem.dart';

abstract class Parser {
  static Problem parseVariant(String data, int numberOfCustomers) {
    Problem problem = Problem();
    data = data.replaceAll("      ", " ");
    data = data.replaceAll("     ", " ");
    data = data.replaceAll("    ", " ");
    data = data.replaceAll("   ", " ");
    data = data.replaceAll("  ", " ");
    data = data.replaceAll("\n", "");
    for (var i = 0; i < numberOfCustomers; i++) {
      final split = data.split(" ").where((s) => s.isNotEmpty).toList();
      CustomerInfo point = CustomerInfo(
          number: int.parse(split[0 + i * 7]),
          position: [
            double.parse(split[1 + i * 7]),
            double.parse(split[2 + i * 7])
          ],
          demand: double.parse(split[3 + i * 7]),
          fromTime: double.parse(split[4 + i * 7]),
          dueTime: double.parse(split[5 + i * 7]),
          serviceTime: double.parse(split[6 + i * 7]));
      problem.customer.add(point);
    }
    for (int i = 0; i < problem.customer.length; i++) {
      List<double> dist_ = [];
      for (int j = 0; j < problem.customer.length; j++) {
        dist_.add(0.0);
      }
      problem.dist.add(dist_);
    }
    for (int i = 0; i < problem.customer.length - 1; i++) {
      for (int j = i + 1; j < problem.customer.length; j++) {
        problem.dist[i][j] = sqrt(pow(
                problem.customer[i].position[0] -
                    problem.customer[j].position[0],
                2) +
            pow(
                problem.customer[i].position[1] -
                    problem.customer[j].position[1],
                2));
        problem.dist[j][i] = problem.dist[i][j];
      }
    }
    return problem;
  }
}
