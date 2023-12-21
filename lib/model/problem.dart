import 'package:master_diploma_vrp/model/point_variant.dart';

class Problem {
  List<PointVariant> customer = [];
  List<List<double>> dist = [];
  int maxNumberOfVehicles = 999;
  int maxVehicleCapacity;
  int numberOfAnts;
  double beta; //the weight in the probability formula
  double q0; //the probability to choose next node j
  double alpha; //parameter of evaporation (global update)
  double rho; //parameter of evaporation (local update)
  int iteration;
  double time = 9999999999;
  int improve = 300;
  Problem(this.maxVehicleCapacity, this.numberOfAnts, this.beta, this.q0,
      this.alpha, this.rho, this.iteration);
}
