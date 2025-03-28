import 'package:flutter/material.dart';

const List<Color> userIndexedColors = [
  Colors.red,
  Colors.blue,
  Colors.purple,
  Colors.yellow,
];

class Nullable<T> {
  final T? value;
  Nullable(this.value);

  factory Nullable.none() => Nullable(null);
  factory Nullable.some(T value) => Nullable(value);

  bool get isNone => value == null;
  bool get isSome => value != null;
  // T? get value => value;
}
