import 'package:meta/meta.dart';

@immutable
class Province {
  final String id;
  final String name;

  const Province({
    @required this.id,
    @required this.name,
  });

  @override
  String toString() => 'Province{id: $id, name: $name}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Province &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
