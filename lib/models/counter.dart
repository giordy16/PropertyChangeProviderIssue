
import 'package:equatable/equatable.dart';
import 'domain_base_class.dart';

class Counter extends DomainBaseClass with EquatableMixin {
  Counter({
    this.id = 0,
    auditing,
    currentValue = 0,
    initialValue = 0,
    name,
    sortOrder = 1,
  }) {
    _currentValue = currentValue;

    _initialValue = initialValue;

    _name = name;

    _sortOrder = sortOrder;
  }

  int id = 0;

  int? _currentValue = 0;

  set currentValue(int? value) {
    if (value != null) {
      _currentValue = value;
      notifyListeners("currentValue");
    }
  }

  int? get currentValue => _currentValue;

  int? _initialValue = 0;

  set initialValue(int? value) {
    if (value != null) {
      _initialValue = value;
      notifyListeners("initialValue");
    }
  }

  int? get initialValue => _initialValue;

  String? _name;

  set name(String? value) {
    if (value != null) {
      _name = value;
      notifyListeners("name");
    }
  }

  String? get name => _name;

  int? _sortOrder = 1;

  set sortOrder(int? value) {
    if (value != null) {
      _sortOrder = value;
      notifyListeners("sortOrder");
    }
  }

  int? get sortOrder => _sortOrder;

  static var propertyNames = (
    currentValue: 'currentValue',
    initialValue: 'initialValue',
    name: 'name',
    sortOrder: 'sortOrder',
  );

  static const className = 'Counter';
  static const dbTableName = 'counter';

  @override
  List<Object?> get props => [
        id,
        currentValue,
        initialValue,
        name,
        sortOrder,
      ];
}
