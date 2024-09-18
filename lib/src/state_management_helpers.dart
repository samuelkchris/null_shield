import 'package:flutter/foundation.dart';

class NullSafeValueNotifier<T> extends ValueNotifier<T?> {
  NullSafeValueNotifier([T? value]) : super(value);

  void updateValue(T? newValue) {
    if (newValue != value) {
      value = newValue;
    }
  }

  T? getValueOrNull() => value;

  T getValueOrDefault(T defaultValue) => value ?? defaultValue;
}

mixin NullSafeChangeNotifier on ChangeNotifier {
  final Map<String, dynamic> _values = {};

  T? getValue<T>(String key) => _values[key] as T?;

  void setValue<T>(String key, T? value) {
    if (_values[key] != value) {
      _values[key] = value;
      notifyListeners();
    }
  }

  T getValueOrDefault<T>(String key, T defaultValue) {
    return _values[key] as T? ?? defaultValue;
  }
}