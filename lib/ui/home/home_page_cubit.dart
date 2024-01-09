import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_diploma_vrp/algorithm/ant_colony_optimization.dart';
import 'package:master_diploma_vrp/algorithm/deterministic_annealing.dart';
import 'package:master_diploma_vrp/model/algorithm.dart';
import 'package:master_diploma_vrp/model/problem.dart';
import 'package:master_diploma_vrp/model/problem_result.dart';
import 'package:master_diploma_vrp/ui/home/home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit()
      : super(HomePageState(
            points: [], solution: null, tenSolutions: [], time: 0));

  void solveProblem(Algorithm algorithm, Problem problem) {
    emit(HomePageState(
        points: problem.customer,
        solution: state.solution,
        tenSolutions: state.tenSolutions,
        time: state.time));
    int start = DateTime.now().millisecondsSinceEpoch;
    final solution = _getSolution(algorithm, problem);
    int end = DateTime.now().millisecondsSinceEpoch;
    emit(HomePageState(
        points: state.points,
        solution: solution,
        tenSolutions: state.tenSolutions,
        time: end - start));
  }

  void getTenSolutions(Algorithm algorithm, Problem problem) {
    emit(HomePageState(
        points: problem.customer,
        solution: state.solution,
        tenSolutions: [],
        time: state.time));
    for (int i = 0; i < 10; i++) {
      int start = DateTime.now().millisecondsSinceEpoch;
      final solution = _getSolution(algorithm, problem);
      int end = DateTime.now().millisecondsSinceEpoch;
      solution.time = end - start;
      state.tenSolutions.add(solution);
      emit(HomePageState(
          points: state.points,
          solution: state.solution,
          tenSolutions: state.tenSolutions,
          time: state.time));
    }
    ProblemResult shortest = state.tenSolutions.reduce((current, next) =>
        current.bestLength < next.bestLength ? current : next);
    emit(HomePageState(
        points: state.points,
        solution: shortest,
        tenSolutions: state.tenSolutions,
        time: shortest.time));
  }

  ProblemResult _getSolution(Algorithm algorithm, Problem problem) {
    switch (algorithm) {
      case Algorithm.antColonyOptimization:
        return AntColonyOptimization(customers: problem.customer)
            .antColony(problem.dist);
      case Algorithm.deterministicAnnealing:
        return DeterministicAnnealing(customers: problem.customer)
            .deterministicAnnealing(problem.dist);
    }
  }
}
