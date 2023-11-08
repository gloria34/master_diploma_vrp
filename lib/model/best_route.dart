import 'package:master_diploma_vrp/model/route.dart';

class BestRoute {
  double cost = double.negativeInfinity;
  final Route route;

  BestRoute({required this.route});
}
