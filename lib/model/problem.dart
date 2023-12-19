import 'package:master_diploma_vrp/model/point_variant.dart';

class Problem{
  List<PointVariant> customer = [];
	List<List<double>> dist = [];

	//constrain information
	int max_vehi_num = 999;
	int max_capacity = 200;

	//parameters used in ACO
	int ant_num = 40;
	double beta = 2.5; //the weight in the probability formula
	double q0 = 0.85; //the probability to choose next node j
	double alpha = 0.2; //parameter of evaporation (global update)
	double rho = 0.2; //parameter of evaporation (local update)
	
	//ending criteria
	int iteration = 300;
	double time = 9999999999;
	int improve = 300;

	//the number of iteration
	String ite_num = "300";

}