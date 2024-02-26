import 'package:flutter/material.dart';
import 'package:master_diploma_vrp/model/algorithm.dart';
import 'package:master_diploma_vrp/ui/home/home_page.dart';

Algorithm algorithm = Algorithm.antColonyOptimization;

//aco params
int ants = 30;
int iterations = 1000;
double alpha = 1;
double beta = 3;
double upsilon = 1600;
double xi = 0.1; //initial pheromone
double delta = 0.1; //pheromone evaporation
bool includeTimeWindowsProbability = true;
double gamma = 2; //time windows influence factor

//da params
double initialDemonEnergy = 10;
double demonEnergyAlpha = 0.995;

List<Color> randomColors = [];

//initial problem details
int vehicleCapacity = 200;
int numberOfCustomers = 26;
String initialProblem =
    """1      40.00      50.00       0.00       0.00    1236.00       0.00
    2      45.00      68.00      10.00     912.00     967.00      90.00
    3      45.00      70.00      30.00     825.00     870.00      90.00
    4      42.00      66.00      10.00      65.00     146.00      90.00
    5      42.00      68.00      10.00     727.00     782.00      90.00
    6      42.00      65.00      10.00      15.00      67.00      90.00
    7      40.00      69.00      20.00     621.00     702.00      90.00
    8      40.00      66.00      20.00     170.00     225.00      90.00
    9      38.00      68.00      20.00     255.00     324.00      90.00
   10      38.00      70.00      10.00     534.00     605.00      90.00
   11      35.00      66.00      10.00     357.00     410.00      90.00
   12      35.00      69.00      10.00     448.00     505.00      90.00
   13      25.00      85.00      20.00     652.00     721.00      90.00
   14      22.00      75.00      30.00      30.00      92.00      90.00
   15      22.00      85.00      10.00     567.00     620.00      90.00
   16      20.00      80.00      40.00     384.00     429.00      90.00
   17      20.00      85.00      40.00     475.00     528.00      90.00
   18      18.00      75.00      20.00      99.00     148.00      90.00
   19      15.00      75.00      20.00     179.00     254.00      90.00
   20      15.00      80.00      10.00     278.00     345.00      90.00
   21      30.00      50.00      10.00      10.00      73.00      90.00
   22      30.00      52.00      20.00     914.00     965.00      90.00
   23      28.00      52.00      20.00     812.00     883.00      90.00
   24      28.00      55.00      10.00     732.00     777.00      90.00
   25      25.00      50.00      10.00      65.00     144.00      90.00
   26      25.00      52.00      40.00     169.00     224.00      90.00""";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VRPTW solver',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
