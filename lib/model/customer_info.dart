import 'package:equatable/equatable.dart';

class CustomerInfo extends Equatable {
  final int number;
  final List<double> position;
  final double demand;
  final double fromTime;
  final double dueTime;
  final double serviceTime;

  const CustomerInfo(
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
