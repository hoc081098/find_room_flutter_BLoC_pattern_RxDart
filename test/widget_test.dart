
void main() {
  final stream$ = Stream.value(1);
  final mapped$ = stream$.map((i) => i == null ? null : i + 2);

  mapped$.map((i) => i).listen((v) => print('1 $v'));
  mapped$.map((i) => i).listen((v) => print('2 $v'));
}
