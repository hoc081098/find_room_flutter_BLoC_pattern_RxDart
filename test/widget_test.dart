import 'package:rxdart/rxdart.dart';

void main() {
  final stream$ = Observable.just(1);
  final mapped$ = stream$.map((i) => i == null ? null : i + 2);

  mapped$.map((i) => i).listen((v) => print('1 $v'));
  mapped$.map((i) => i).listen((v) => print('2 $v'));
}
