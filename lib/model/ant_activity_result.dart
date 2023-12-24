class AntActivityResult {
  //l - path
  //pr - modified pheromone matrix
  final List<List<int>> l;
  final List<List<double>> pr;
  final List<double> demand;
  final double length;

  AntActivityResult(
      {required this.l,
      required this.pr,
      required this.demand,
      required this.length});
}
