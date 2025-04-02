import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: constant_identifier_names
const String VERSION = String.fromEnvironment('APP_VERSION', defaultValue: 'debug');

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

enum Season { spring, summer, autumn, winter }

extension SeasonExtension on Season {
  double get degree {
    switch (this) {
      case Season.spring:
        return 180;
      case Season.summer:
        return 270;
      case Season.autumn:
        return 0;
      case Season.winter:
        return 90;
    }
  }

  String get fmt {
    switch (this) {
      case Season.spring:
        return 'starmap_season_spring'.tr;
      case Season.summer:
        return 'starmap_season_summer'.tr;
      case Season.autumn:
        return 'starmap_season_autumn'.tr;
      case Season.winter:
        return 'starmap_season_winter'.tr;
    }
  }
}
