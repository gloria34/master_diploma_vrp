import 'package:master_diploma_vrp/model/point.dart';
import 'package:master_diploma_vrp/model/route.dart';

class Ant {
  late Point currentPosition;
  late Route route;

  Ant(List<Point> points) {
    currentPosition = points[0];
    route = Route();
  }
}
