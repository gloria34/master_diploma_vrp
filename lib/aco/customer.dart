class Customer {
  List<int> pos = [];
  int demand = 0;
  int readyTime = 0;
  int dueTime = 0;
  int serviceTime = 0;
  Customer(int x, int y) {
    pos.add(x);
    pos.add(y);
  }
}
