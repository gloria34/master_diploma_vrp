import 'package:equatable/equatable.dart';

class PointVariant extends Equatable{

  final int number;
  final List<double> position;
  final double demand;
  final double fromTime;
  final double dueTime;
  final double serviceTime;

  const PointVariant(
      {required this.number,
      required this.position,
      required this.demand,
      required this.fromTime,
      required this.dueTime,
      required this.serviceTime});

  @override
  String toString() {
    return "#$number position=$position; demand=$demand; form time=$fromTime; due time=$dueTime; service time=$serviceTime.";
  }

  @override
  List<Object?> get props => [number];
}