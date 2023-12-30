enum Algorithm {
  antColonyOptimization(title: 'Ant Colony Optimization'),
  deterministicAnnealing(title: 'Deterministic Annealing');

  final String title;

  const Algorithm({required this.title});
}
