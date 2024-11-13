import 'package:objectbox/objectbox.dart';

@Entity()
class CounterObox {
  static const String serverDbTable = "counter";

  CounterObox({
    this.id = 0,
    this.currentValue = 0,
    this.initialValue = 0,
    required this.name,
    this.sortOrder = 1,
  });

  @Id()
  int id = 0;

  int currentValue;

  int initialValue;

  String name;

  int sortOrder;
}
