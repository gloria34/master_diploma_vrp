import 'package:master_diploma_vrp/model/point.dart';

abstract class Parser {
  static List<Point> parse(String data, int numberOfCustomers) {
    List<Point> points = [];
    data = data.replaceAll("      ", " ");
    data = data.replaceAll("     ", " ");
    data = data.replaceAll("    ", " ");
    data = data.replaceAll("   ", " ");
    data = data.replaceAll("  ", " ");
    for (var i = 0; i < numberOfCustomers; i++) {
      Point point = Point(
          number: int.parse(data.split(" ")[0 + i * 7]),
          x: double.parse(data.split(" ")[1 + i * 7]),
          y: double.parse(data.split(" ")[2 + i * 7]),
          demand: double.parse(data.split(" ")[3 + i * 7]),
          fromTime: double.parse(data.split(" ")[4 + i * 7]),
          dueTime: double.parse(data.split(" ")[5 + i * 7]),
          serviceTime: double.parse(data.split(" ")[6 + i * 7]));
      points.add(point);
    }
    return points;
  }
}
