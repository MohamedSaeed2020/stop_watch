///This class represent the data source for our bloc
class Ticker {
  Stream<int> generateTicks({required int maxTime}) {
    return Stream.periodic(const Duration(seconds: 1), (int cycle) {
      return maxTime - cycle - 1;
    });
  }

//with take, stream does it's job only 'maxTime' tomes
}
