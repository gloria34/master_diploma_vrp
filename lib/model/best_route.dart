import 'package:master_diploma_vrp/model/point.dart';
import 'package:master_diploma_vrp/model/route.dart';

class BestRoute {
  double cost = double.negativeInfinity;
  final Route route;

  BestRoute({required this.route});

  @override
  String toString() {
    String points = "";
    for (Point customer in route.visitedCustomers) {
      points += customer.number.toString();
    }
    return "cost = $cost, points = [$points], demand = ${route.demand}";
  }
}
