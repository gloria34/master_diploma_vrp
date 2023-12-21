import 'package:master_diploma_vrp/main.dart';
import 'package:master_diploma_vrp/model/point_variant.dart';

class Problem {
  List<PointVariant> customer = [];
  List<List<double>> dist = [];
  int maxNumberOfVehicles = 999;
  int maxVehicleCapacity = vehicleCapacity;
  int numberOfAnts = 40;
  double beta = 2.5; //the weight in the probability formula
  double q0 = 0.85; //the probability to choose next node j
  double alpha = 0.2; //parameter of evaporation (global update)
  double rho = 0.2; //parameter of evaporation (local update)
  int iteration = 300;
  double time = 9999999999;
  int improve = 300;
}
