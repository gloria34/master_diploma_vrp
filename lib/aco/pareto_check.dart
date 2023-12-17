mixin ParetoCheck {
  static bool check(List<BuildTour> paretoSols, BuildTour solution) {
    for (int i = 0; i < paretoSols.length; i++) {
      if (solution.n >= paretoSols[i].n && solution.J >= paretoSols[i].J) {
        return false;
      }
    }
    return true;
  }

  static List<BuildTour> rmInd(
      List<BuildTour> paretoSols, BuildTour solution) {
    List<BuildTour> dominatedSolsInd = List<BuildTour>();
    for (int i = 0; i < paretoSols.length; i++) {
      if (solution.n <= paretoSols[i].n && solution.J <= paretoSols[i].J) {
        dominatedSolsInd.add(paretoSols[i]);
      }
    }
    return dominatedSolsInd;
  }
}
