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

bool isPrime(int n) {
  // hard code 1 to 20 prime
  if (n == 2 || n == 3 || n == 5 || n == 7 || n == 11 || n == 13 || n == 17 || n == 19) {
    return true;
  }
  return false;
}
