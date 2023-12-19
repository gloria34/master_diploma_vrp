import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:master_diploma_vrp/aco/aco.dart';
import 'package:master_diploma_vrp/aco/aco_variant.dart';
import 'package:master_diploma_vrp/model/answer.dart';
import 'package:master_diploma_vrp/model/best_route.dart';
import 'package:master_diploma_vrp/model/edge.dart';
import 'package:master_diploma_vrp/model/point.dart';
import 'package:master_diploma_vrp/model/problem.dart';
import 'package:master_diploma_vrp/utils/coordinate_painter.dart';
import 'package:master_diploma_vrp/utils/parser.dart';

//problem details
const vehicleCapacity = 200.0;
const numberOfCustomers = 101;
const data =
    """1      35.00      35.00       0.00       0.00     230.00       0.00
    2      41.00      49.00      10.00     161.00     171.00      10.00
    3      35.00      17.00       7.00      50.00      60.00      10.00
    4      55.00      45.00      13.00     116.00     126.00      10.00
    5      55.00      20.00      19.00     149.00     159.00      10.00
    6      15.00      30.00      26.00      34.00      44.00      10.00
    7      25.00      30.00       3.00      99.00     109.00      10.00
    8      20.00      50.00       5.00      81.00      91.00      10.00
    9      10.00      43.00       9.00      95.00     105.00      10.00
   10      55.00      60.00      16.00      97.00     107.00      10.00
   11      30.00      60.00      16.00     124.00     134.00      10.00
   12      20.00      65.00      12.00      67.00      77.00      10.00
   13      50.00      35.00      19.00      63.00      73.00      10.00
   14      30.00      25.00      23.00     159.00     169.00      10.00
   15      15.00      10.00      20.00      32.00      42.00      10.00
   16      30.00       5.00       8.00      61.00      71.00      10.00
   17      10.00      20.00      19.00      75.00      85.00      10.00
   18       5.00      30.00       2.00     157.00     167.00      10.00
   19      20.00      40.00      12.00      87.00      97.00      10.00
   20      15.00      60.00      17.00      76.00      86.00      10.00
   21      45.00      65.00       9.00     126.00     136.00      10.00
   22      45.00      20.00      11.00      62.00      72.00      10.00
   23      45.00      10.00      18.00      97.00     107.00      10.00
   24      55.00       5.00      29.00      68.00      78.00      10.00
   25      65.00      35.00       3.00     153.00     163.00      10.00
   26      65.00      20.00       6.00     172.00     182.00      10.00
   27      45.00      30.00      17.00     132.00     142.00      10.00
   28      35.00      40.00      16.00      37.00      47.00      10.00
   29      41.00      37.00      16.00      39.00      49.00      10.00
   30      64.00      42.00       9.00      63.00      73.00      10.00
   31      40.00      60.00      21.00      71.00      81.00      10.00
   32      31.00      52.00      27.00      50.00      60.00      10.00
   33      35.00      69.00      23.00     141.00     151.00      10.00
   34      53.00      52.00      11.00      37.00      47.00      10.00
   35      65.00      55.00      14.00     117.00     127.00      10.00
   36      63.00      65.00       8.00     143.00     153.00      10.00
   37       2.00      60.00       5.00      41.00      51.00      10.00
   38      20.00      20.00       8.00     134.00     144.00      10.00
   39       5.00       5.00      16.00      83.00      93.00      10.00
   40      60.00      12.00      31.00      44.00      54.00      10.00
   41      40.00      25.00       9.00      85.00      95.00      10.00
   42      42.00       7.00       5.00      97.00     107.00      10.00
   43      24.00      12.00       5.00      31.00      41.00      10.00
   44      23.00       3.00       7.00     132.00     142.00      10.00
   45      11.00      14.00      18.00      69.00      79.00      10.00
   46       6.00      38.00      16.00      32.00      42.00      10.00
   47       2.00      48.00       1.00     117.00     127.00      10.00
   48       8.00      56.00      27.00      51.00      61.00      10.00
   49      13.00      52.00      36.00     165.00     175.00      10.00
   50       6.00      68.00      30.00     108.00     118.00      10.00
   51      47.00      47.00      13.00     124.00     134.00      10.00
   52      49.00      58.00      10.00      88.00      98.00      10.00
   53      27.00      43.00       9.00      52.00      62.00      10.00
   54      37.00      31.00      14.00      95.00     105.00      10.00
   55      57.00      29.00      18.00     140.00     150.00      10.00
   56      63.00      23.00       2.00     136.00     146.00      10.00
   57      53.00      12.00       6.00     130.00     140.00      10.00
   58      32.00      12.00       7.00     101.00     111.00      10.00
   59      36.00      26.00      18.00     200.00     210.00      10.00
   60      21.00      24.00      28.00      18.00      28.00      10.00
   61      17.00      34.00       3.00     162.00     172.00      10.00
   62      12.00      24.00      13.00      76.00      86.00      10.00
   63      24.00      58.00      19.00      58.00      68.00      10.00
   64      27.00      69.00      10.00      34.00      44.00      10.00
   65      15.00      77.00       9.00      73.00      83.00      10.00
   66      62.00      77.00      20.00      51.00      61.00      10.00
   67      49.00      73.00      25.00     127.00     137.00      10.00
   68      67.00       5.00      25.00      83.00      93.00      10.00
   69      56.00      39.00      36.00     142.00     152.00      10.00
   70      37.00      47.00       6.00      50.00      60.00      10.00
   71      37.00      56.00       5.00     182.00     192.00      10.00
   72      57.00      68.00      15.00      77.00      87.00      10.00
   73      47.00      16.00      25.00      35.00      45.00      10.00
   74      44.00      17.00       9.00      78.00      88.00      10.00
   75      46.00      13.00       8.00     149.00     159.00      10.00
   76      49.00      11.00      18.00      69.00      79.00      10.00
   77      49.00      42.00      13.00      73.00      83.00      10.00
   78      53.00      43.00      14.00     179.00     189.00      10.00
   79      61.00      52.00       3.00      96.00     106.00      10.00
   80      57.00      48.00      23.00      92.00     102.00      10.00
   81      56.00      37.00       6.00     182.00     192.00      10.00
   82      55.00      54.00      26.00      94.00     104.00      10.00
   83      15.00      47.00      16.00      55.00      65.00      10.00
   84      14.00      37.00      11.00      44.00      54.00      10.00
   85      11.00      31.00       7.00     101.00     111.00      10.00
   86      16.00      22.00      41.00      91.00     101.00      10.00
   87       4.00      18.00      35.00      94.00     104.00      10.00
   88      28.00      18.00      26.00      93.00     103.00      10.00
   89      26.00      52.00       9.00      74.00      84.00      10.00
   90      26.00      35.00      15.00     176.00     186.00      10.00
   91      31.00      67.00       3.00      95.00     105.00      10.00
   92      15.00      19.00       1.00     160.00     170.00      10.00
   93      22.00      22.00       2.00      18.00      28.00      10.00
   94      18.00      24.00      22.00     188.00     198.00      10.00
   95      26.00      27.00      27.00     100.00     110.00      10.00
   96      25.00      24.00      20.00      39.00      49.00      10.00
   97      22.00      27.00      11.00     135.00     145.00      10.00
   98      25.00      21.00      12.00     133.00     143.00      10.00
   99      19.00      21.00      10.00      58.00      68.00      10.00
  100      20.00      26.00       9.00      83.00      93.00      10.00
  101      18.00      18.00      17.00     185.00     195.00      10.00""";

//ACO params
const numberOfAnts = numberOfCustomers - 1;
const evaporationRate = 0.5;
const pheromoneImportance = 1;
const heuristicImportance = 1;
const timeWindowsImportance = 1;
const numberOfIterations = 100;
const initialPheromoneValue = 0.1;
const trailDepositCoefficient = 500;
late Point depot;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VRPTW',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with AfterLayoutMixin {
  List<Point> _points = [];
  final Map<Point, List<Edge>> _edges = {};
  Answer? _answer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('VRPTW'),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "VEHICLE CAPACITY: $vehicleCapacity",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                for (Point point in _points) Text(point.toString()),
                _CoordinatePlane(
                  points: _points,
                  answer: _answer,
                ),
                if (_answer != null)
                  _AnswerInfo(
                    answer: _answer!,
                  ),
                const SizedBox(
                  height: 80,
                )
              ],
            ),
          ),
        ));
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    // _parsePoints();
    // setState(() {
    //   _answer = ACO(points: _points, edges: _edges).solve();
    // });
    //load problem and parameters
		Problem load = Parser.parseVariant(data, numberOfCustomers);
		
		//time start
		int start = DateTime.now().millisecondsSinceEpoch;
		
		//apply ACO
		ACOVariant solutions = ACOVariant();
		solutions = ACOVariant.ant_main(load,start);
		
		//time end
		int end = DateTime.now().millisecondsSinceEpoch;
		int e_s = end - start;
  }

  void _parsePoints() {
    setState(() {
      _points = Parser.parse(data, numberOfCustomers);
      _edges.clear();
      for (Point point1 in _points) {
        _edges[point1] = [];
        for (Point point2 in _points) {
          if (point1 != point2) {
            _edges[point1]!.add(Edge(
                pheromone: initialPheromoneValue,
                startLocation: point1,
                endLocation: point2));
          }
        }
      }
      depot = _points.first;
    });
  }
}

class _CoordinatePlane extends StatelessWidget {
  final List<Point> points;
  final Answer? answer;

  const _CoordinatePlane({required this.points, required this.answer});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: Size(MediaQuery.of(context).size.width - 40, 600),
        painter: CoordinatePainter(
            points: points, zoomX: 12, zoomY: 7, answer: answer),
      ),
    );
  }
}

class _AnswerInfo extends StatelessWidget {
  final Answer answer;

  const _AnswerInfo({required this.answer});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Number of vehicles = ${answer.bestRoutes.length}"),
        Text("Distance = ${_calculateAnswerDistance()}"),
        for (final route in answer.bestRoutes) Text(route.toString())
      ],
    );
  }

  double _calculateAnswerDistance() {
    double distance = 0.0;
    for (BestRoute bestRoute in answer.bestRoutes) {
      distance += bestRoute.route.distance;
    }
    return distance;
  }
}
