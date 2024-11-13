import '../models/counter.dart';
import '../models/counter_obox.dart';

extension CounterOboxToDomain on CounterObox {
  Counter convertToDomain() {
    Counter domain = Counter(
        id: id,
        currentValue: currentValue,
        initialValue: initialValue,
        name: name,
        sortOrder: sortOrder);

    return domain;
  }
}

extension CounterDomainToObox on Counter {
  CounterObox convertToObox() {
    CounterObox obox = CounterObox(
        id: id,
        currentValue: currentValue!,
        initialValue: initialValue!,
        name: name!,
        sortOrder: sortOrder!);

    return obox;
  }
}