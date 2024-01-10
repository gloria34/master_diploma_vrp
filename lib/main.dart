import 'package:flutter/material.dart';
import 'package:master_diploma_vrp/model/algorithm.dart';
import 'package:master_diploma_vrp/ui/home/home_page.dart';

Algorithm algorithm = Algorithm.antColonyOptimization;

//aco params
int ants = 101;
int iterations = 1000;
double alpha = 2;
double beta = 3;
double upsilon = 1600;
double xi = 0.1; //initial pheromone
double delta = 0.1; //pheromone evaporation
bool includeTimeWindowsProbability = true;
double gamma = 2; //time windows influence factor

//da params
double initialDemonEnergy = 200;
double demonEnergyAlpha = 0.995;

List<Color> randomColors = [];

//initial problem details
int vehicleCapacity = 200;
int numberOfCustomers = 101;
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
   26      25.00      52.00      40.00     169.00     224.00      90.00
   27      25.00      55.00      10.00     622.00     701.00      90.00
   28      23.00      52.00      10.00     261.00     316.00      90.00
   29      23.00      55.00      20.00     546.00     593.00      90.00
   30      20.00      50.00      10.00     358.00     405.00      90.00
   31      20.00      55.00      10.00     449.00     504.00      90.00
   32      10.00      35.00      20.00     200.00     237.00      90.00
   33      10.00      40.00      30.00      31.00     100.00      90.00
   34       8.00      40.00      40.00      87.00     158.00      90.00
   35       8.00      45.00      20.00     751.00     816.00      90.00
   36       5.00      35.00      10.00     283.00     344.00      90.00
   37       5.00      45.00      10.00     665.00     716.00      90.00
   38       2.00      40.00      20.00     383.00     434.00      90.00
   39       0.00      40.00      30.00     479.00     522.00      90.00
   40       0.00      45.00      20.00     567.00     624.00      90.00
   41      35.00      30.00      10.00     264.00     321.00      90.00
   42      35.00      32.00      10.00     166.00     235.00      90.00
   43      33.00      32.00      20.00      68.00     149.00      90.00
   44      33.00      35.00      10.00      16.00      80.00      90.00
   45      32.00      30.00      10.00     359.00     412.00      90.00
   46      30.00      30.00      10.00     541.00     600.00      90.00
   47      30.00      32.00      30.00     448.00     509.00      90.00
   48      30.00      35.00      10.00    1054.00    1127.00      90.00
   49      28.00      30.00      10.00     632.00     693.00      90.00
   50      28.00      35.00      10.00    1001.00    1066.00      90.00
   51      26.00      32.00      10.00     815.00     880.00      90.00
   52      25.00      30.00      10.00     725.00     786.00      90.00
   53      25.00      35.00      10.00     912.00     969.00      90.00
   54      44.00       5.00      20.00     286.00     347.00      90.00
   55      42.00      10.00      40.00     186.00     257.00      90.00
   56      42.00      15.00      10.00      95.00     158.00      90.00
   57      40.00       5.00      30.00     385.00     436.00      90.00
   58      40.00      15.00      40.00      35.00      87.00      90.00
   59      38.00       5.00      30.00     471.00     534.00      90.00
   60      38.00      15.00      10.00     651.00     740.00      90.00
   61      35.00       5.00      20.00     562.00     629.00      90.00
   62      50.00      30.00      10.00     531.00     610.00      90.00
   63      50.00      35.00      20.00     262.00     317.00      90.00
   64      50.00      40.00      50.00     171.00     218.00      90.00
   65      48.00      30.00      10.00     632.00     693.00      90.00
   66      48.00      40.00      10.00      76.00     129.00      90.00
   67      47.00      35.00      10.00     826.00     875.00      90.00
   68      47.00      40.00      10.00      12.00      77.00      90.00
   69      45.00      30.00      10.00     734.00     777.00      90.00
   70      45.00      35.00      10.00     916.00     969.00      90.00
   71      95.00      30.00      30.00     387.00     456.00      90.00
   72      95.00      35.00      20.00     293.00     360.00      90.00
   73      53.00      30.00      10.00     450.00     505.00      90.00
   74      92.00      30.00      10.00     478.00     551.00      90.00
   75      53.00      35.00      50.00     353.00     412.00      90.00
   76      45.00      65.00      20.00     997.00    1068.00      90.00
   77      90.00      35.00      10.00     203.00     260.00      90.00
   78      88.00      30.00      10.00     574.00     643.00      90.00
   79      88.00      35.00      20.00     109.00     170.00      90.00
   80      87.00      30.00      10.00     668.00     731.00      90.00
   81      85.00      25.00      10.00     769.00     820.00      90.00
   82      85.00      35.00      30.00      47.00     124.00      90.00
   83      75.00      55.00      20.00     369.00     420.00      90.00
   84      72.00      55.00      10.00     265.00     338.00      90.00
   85      70.00      58.00      20.00     458.00     523.00      90.00
   86      68.00      60.00      30.00     555.00     612.00      90.00
   87      66.00      55.00      10.00     173.00     238.00      90.00
   88      65.00      55.00      20.00      85.00     144.00      90.00
   89      65.00      60.00      30.00     645.00     708.00      90.00
   90      63.00      58.00      10.00     737.00     802.00      90.00
   91      60.00      55.00      10.00      20.00      84.00      90.00
   92      60.00      60.00      10.00     836.00     889.00      90.00
   93      67.00      85.00      20.00     368.00     441.00      90.00
   94      65.00      85.00      40.00     475.00     518.00      90.00
   95      65.00      82.00      10.00     285.00     336.00      90.00
   96      62.00      80.00      30.00     196.00     239.00      90.00
   97      60.00      80.00      10.00      95.00     156.00      90.00
   98      60.00      85.00      30.00     561.00     622.00      90.00
   99      58.00      75.00      20.00      30.00      84.00      90.00
  100      55.00      80.00      10.00     743.00     820.00      90.00
  101      55.00      85.00      20.00     647.00     726.00      90.00""";

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
