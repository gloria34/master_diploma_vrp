import 'package:master_diploma_vrp/model/point.dart';

class Ant {
  late Point currentPosition;
  late List<Point> currentRoute;
  late List<Point> visitedCustomers;

  Ant(List<Point> points) {
    currentPosition = points[0];
    currentRoute = [points[0]];
    visitedCustomers = [];
  }
}
