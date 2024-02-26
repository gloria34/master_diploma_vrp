import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_diploma_vrp/model/algorithm.dart';
import 'package:master_diploma_vrp/model/customer_info.dart';
import 'package:master_diploma_vrp/model/problem.dart';
import 'package:master_diploma_vrp/model/problem_result.dart';
import 'package:master_diploma_vrp/ui/home/home_page_cubit.dart';
import 'package:master_diploma_vrp/ui/home/home_page_state.dart';
import 'package:master_diploma_vrp/util/coordinate_painter.dart';
import 'package:master_diploma_vrp/util/parser.dart';

import '../../main.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterLayoutMixin {
  HomePageCubit cubit = HomePageCubit();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageState>(
        bloc: cubit,
        builder: (context, state) => Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text('VRPTW solver'),
            ),
            body: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _ProblemParams(
                      onSolveTap: (problem) {
                        cubit.solveProblem(algorithm, problem);
                      },
                      onGetTenSolutionsTap: (problem) {
                        cubit.getTenSolutions(algorithm, problem);
                      },
                    ),
                    _CoordinatePlane(
                      points: state.points,
                      answer: state.solution,
                    ),
                    if (state.solution != null)
                      _AnswerInfo(
                        answer: state.solution!,
                        time: state.time,
                      ),
                    if (state.tenSolutions.isNotEmpty)
                      _SolutionLogs(
                        tenSolutions: state.tenSolutions,
                      ),
                    const SizedBox(
                      height: 80,
                    )
                  ],
                ),
              ),
            )));
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    _generateRandomColors();
    Problem load = Parser.parseVariant(initialProblem, numberOfCustomers);
    cubit.solveProblem(algorithm, load);
  }

  void _generateRandomColors() {
    for (int i = 0; i < 500; i++) {
      randomColors.add(Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
          .withOpacity(1.0));
    }
  }
}

class _ProblemParams extends StatefulWidget {
  final Function(Problem) onSolveTap;
  final Function(Problem) onGetTenSolutionsTap;

  const _ProblemParams(
      {required this.onSolveTap, required this.onGetTenSolutionsTap});

  @override
  State<StatefulWidget> createState() {
    return _ProblemParamsState();
  }
}

class _ProblemParamsState extends State<_ProblemParams> {
  //problem params
  final TextEditingController problemTextController =
      TextEditingController(text: initialProblem);
  final TextEditingController numberOfCustomersController =
      TextEditingController(text: numberOfCustomers.toString());
  final TextEditingController vehicleCapacityController =
      TextEditingController(text: vehicleCapacity.toString());
  //aco params
  final TextEditingController numberOfAntsController =
      TextEditingController(text: ants.toString());
  final TextEditingController numberOfIterationsController =
      TextEditingController(text: iterations.toString());
  final TextEditingController alphaController =
      TextEditingController(text: alpha.toString());
  final TextEditingController betaController =
      TextEditingController(text: beta.toString());
  final TextEditingController gammaController =
      TextEditingController(text: gamma.toString());
  final TextEditingController xiController =
      TextEditingController(text: xi.toString());
  final TextEditingController upsilonController =
      TextEditingController(text: upsilon.toString());
  final TextEditingController deltaController =
      TextEditingController(text: delta.toString());
//da params
  final TextEditingController initialDemonEnergyController =
      TextEditingController(text: initialDemonEnergy.toString());
  final TextEditingController demonEnergyAlphaController =
      TextEditingController(text: demonEnergyAlpha.toString());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            "Problem params",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Problem text'),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: problemTextController,
          ),
          _buildProblemFields(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Algorithm params",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 40,
            child: DropdownButton<Algorithm>(
              value: algorithm,
              elevation: 16,
              icon: const Icon(Icons.arrow_downward),
              underline: Container(
                height: 1,
                color: Colors.black,
              ),
              onChanged: (Algorithm? value) {
                setState(() {
                  algorithm = value!;
                });
              },
              items: Algorithm.values
                  .map<DropdownMenuItem<Algorithm>>((Algorithm value) {
                return DropdownMenuItem<Algorithm>(
                  value: value,
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width - 70,
                      child: Text(value.title)),
                );
              }).toList(),
            ),
          ),
          Builder(builder: (context) {
            switch (algorithm) {
              case Algorithm.antColonyOptimization:
                return _buildAcoFields();
              case Algorithm.deterministicAnnealing:
                return _buildDaFields();
            }
          }),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      Problem load = Parser.parseVariant(
                          problemTextController.text,
                          int.parse(numberOfCustomersController.text));
                      _setProblemParams();
                      widget.onSolveTap(load);
                    },
                    child: const Text("Solve")),
                TextButton(
                    onPressed: () {
                      Problem load = Parser.parseVariant(
                          problemTextController.text,
                          int.parse(numberOfCustomersController.text));
                      _setProblemParams();
                      widget.onGetTenSolutionsTap(load);
                    },
                    child: const Text("Get 10 solutions")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProblemFields() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(labelText: 'Number of customers'),
            keyboardType: TextInputType.number,
            controller: numberOfCustomersController,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(labelText: 'Vehicle capacity'),
            keyboardType: TextInputType.number,
            controller: vehicleCapacityController,
          ),
        ),
      ],
    );
  }

  Widget _buildAcoFields() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Number of ants'),
                keyboardType: TextInputType.number,
                controller: numberOfAntsController,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Number of iterations'),
                keyboardType: TextInputType.number,
                controller: numberOfIterationsController,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Xi'),
                keyboardType: TextInputType.number,
                controller: xiController,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Upsilon'),
                keyboardType: TextInputType.number,
                controller: upsilonController,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Delta'),
                keyboardType: TextInputType.number,
                controller: deltaController,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Alpha'),
                keyboardType: TextInputType.number,
                controller: alphaController,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Beta'),
                keyboardType: TextInputType.number,
                controller: betaController,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text("Include time windows probability"),
            Switch(
                value: includeTimeWindowsProbability,
                onChanged: (value) {
                  setState(() {
                    includeTimeWindowsProbability = value;
                  });
                }),
            const SizedBox(
              width: 10,
            ),
            Visibility(
              visible: includeTimeWindowsProbability,
              child: Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Gamma'),
                  keyboardType: TextInputType.number,
                  controller: gammaController,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDaFields() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(labelText: 'Alpha'),
            keyboardType: TextInputType.number,
            controller: demonEnergyAlphaController,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextFormField(
            decoration:
                const InputDecoration(labelText: 'Initial demon energy'),
            keyboardType: TextInputType.number,
            controller: initialDemonEnergyController,
          ),
        ),
      ],
    );
  }

  void _setProblemParams() {
    initialProblem = problemTextController.text;
    numberOfCustomers = int.parse(numberOfCustomersController.text);
    vehicleCapacity = int.parse(vehicleCapacityController.text);
    switch (algorithm) {
      case Algorithm.antColonyOptimization:
        setAcoParams();
        break;
      case Algorithm.deterministicAnnealing:
        setDaParams();
        break;
    }
  }

  void setAcoParams() {
    ants = int.parse(numberOfAntsController.text);
    beta = double.parse(betaController.text);
    upsilon = double.parse(upsilonController.text);
    alpha = double.parse(alphaController.text);
    xi = double.parse(xiController.text);
    iterations = int.parse(numberOfIterationsController.text);
    delta = double.parse(deltaController.text);
    gamma = double.parse(gammaController.text);
  }

  void setDaParams() {
    initialDemonEnergy = double.parse(initialDemonEnergyController.text);
    demonEnergyAlpha = double.parse(demonEnergyAlphaController.text);
  }
}

class _CoordinatePlane extends StatefulWidget {
  final List<CustomerInfo> points;
  final ProblemResult? answer;

  const _CoordinatePlane({required this.points, required this.answer});

  @override
  State<StatefulWidget> createState() {
    return _CoordinatePlaneState();
  }
}

class _CoordinatePlaneState extends State<_CoordinatePlane> {
  bool _isLabelsVisible = false;
  final TextEditingController _zoomXController =
      TextEditingController(text: "12");
  final TextEditingController _zoomYController =
      TextEditingController(text: "7");
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width - 40, 600),
            painter: CoordinatePainter(
                points: widget.points,
                zoomX: _zoomXController.text.isNotEmpty
                    ? int.parse(_zoomXController.text)
                    : 12,
                zoomY: _zoomYController.text.isNotEmpty
                    ? int.parse(_zoomYController.text)
                    : 7,
                answer: widget.answer?.bestPath,
                isLabelsVisible: _isLabelsVisible),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Show labels"),
              Switch(
                  value: _isLabelsVisible,
                  onChanged: (value) {
                    setState(() {
                      _isLabelsVisible = value;
                    });
                  }),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Zoom X'),
                  keyboardType: TextInputType.number,
                  controller: _zoomXController,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Zoom Y'),
                  keyboardType: TextInputType.number,
                  controller: _zoomYController,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _AnswerInfo extends StatelessWidget {
  final ProblemResult answer;
  final int time;

  const _AnswerInfo({required this.answer, required this.time});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText("Number of vehicles = ${answer.bestPath.length}"),
        SelectableText("Distance = ${answer.bestLength}"),
        SelectableText("Time = $time"),
        SelectableText(
            '${answer.bestPath.length}\t${answer.bestLength}\t$time'),
      ],
    );
  }
}

class _SolutionLogs extends StatelessWidget {
  final List<ProblemResult> tenSolutions;

  const _SolutionLogs({required this.tenSolutions});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SelectableText(_getTenSolutionsString()),
        Text('Average time = ${_getAverageTimeString()}'),
        Text('Average length = ${_getAverageLengthString()}'),
        Text(
            'Average number of vehicles = ${_getAverageNumberOfVehiclesString()}'),
        SelectableText(
            '${_getAverageNumberOfVehiclesString()}\t${_getAverageLengthString()}\t${_getAverageTimeString()}'),
      ],
    );
  }

  String _getTenSolutionsString() {
    String result = "";
    for (final solution in tenSolutions) {
      result +=
          "${solution.bestLength}\t${solution.bestPath.length}\t${solution.time}\n";
    }
    return result;
  }

  String _getAverageTimeString() {
    int sum = 0;
    for (final solution in tenSolutions) {
      sum += solution.time;
    }
    return (sum / 10).toString();
  }

  String _getAverageLengthString() {
    double sum = 0;
    for (final solution in tenSolutions) {
      sum += solution.bestLength;
    }
    return (sum / 10).toString();
  }

  String _getAverageNumberOfVehiclesString() {
    int sum = 0;
    for (final solution in tenSolutions) {
      sum += solution.bestPath.length;
    }
    return (sum / 10).toString();
  }
}
