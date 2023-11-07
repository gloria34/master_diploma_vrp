import 'package:master_diploma_vrp/model/point.dart';
import 'package:master_diploma_vrp/model/route.dart';

class Ant {
  late Point currentPosition;
  late Route currentRoute;
  late List<Point> visitedCustomers;

  Ant(List<Point> points) {
    currentPosition = points[0];
    currentRoute = Route();
    visitedCustomers = [points[0]];
  }
}
