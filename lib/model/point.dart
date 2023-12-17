import 'package:equatable/equatable.dart';

class Point extends Equatable {
  final int number;
  final double x;
  final double y;
  final double demand;
  final double fromTime;
  final double dueTime;
  final double serviceTime;

  const Point(
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

  @override
  List<Object?> get props => [number];
}
