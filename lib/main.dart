import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:master_diploma_vrp/aco/aco.dart';
import 'package:master_diploma_vrp/model/edge.dart';
import 'package:master_diploma_vrp/model/point.dart';
import 'package:master_diploma_vrp/utils/coordinate_painter.dart';
import 'package:master_diploma_vrp/utils/parser.dart';

//problem details
const vahicleCapacity = 200.0;
const numberOfCustomers = 10;
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
   10      55.00      60.00      16.00      97.00     107.00      10.00""";

//ACO params
const numberOfAnts = numberOfCustomers - 1;
const evaporationRate = 0.1;
const pheromoneImportance = 1;
const heuristicImportance = 1;
const numberOfIterations = 100;
const initialPheromoneValue = 0.1;
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
                    "VEHICLE CAPACITY: $vahicleCapacity",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                for (Point point in _points) Text(point.toString()),
                _CoordinatePlane(
                  points: _points,
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
    _parsePoints();
    ACO(points: _points, edges: _edges).solve();
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

  const _CoordinatePlane({required this.points});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: Size(MediaQuery.of(context).size.width - 40, 600),
        painter: CoordinatePainter(points: points, zoomX: 12, zoomY: 7),
      ),
    );
  }
}
