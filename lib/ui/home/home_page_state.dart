import 'package:master_diploma_vrp/model/customer_info.dart';
import 'package:master_diploma_vrp/model/problem_result.dart';

class HomePageState {
  final List<CustomerInfo> points;
  final ProblemResult? solution;
  final List<ProblemResult> tenSolutions;
  final int time;

  HomePageState(
      {required this.points,
      required this.solution,
      required this.tenSolutions,
      required this.time});
}
