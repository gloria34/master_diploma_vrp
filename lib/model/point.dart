import 'dart:math';

class Point {
  final int number;
  final double x;
  final double y;
  final double demand;
  final double fromTime;
  final double dueTime;
  final double serviceTime;

  Point(
      {required this.number,
      required this.x,
      required this.y,
      required this.demand,
      required this.fromTime,
      required this.dueTime,
      required this.serviceTime});

  @override
  String toString() {
    return "#$number x=$x; y=$y; demand=$demand; form time=$fromTime; due time=$dueTime; service time=$serviceTime.";
  }

  Map<Point, double> getDistancesToPoints(List<Point> points) {
    Map<Point, double> distances = {};
    for (Point point in points) {
      if (point != this) {
        double distance = sqrt(pow((point.x - x), 2) + pow((point.y - y), 2));
        distances[point] = distance;
      }
    }
    return distances;
  }
}
