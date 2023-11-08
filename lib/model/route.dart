import 'package:master_diploma_vrp/main.dart';
import 'package:master_diploma_vrp/model/edge.dart';
import 'package:master_diploma_vrp/model/point.dart';

class Route {
  double distance = 0.0;
  double time = 0.0;
  double demand = vahicleCapacity;
  List<Point> visitedCustomers = [];
  List<Edge> visitedEdges = [];
}
