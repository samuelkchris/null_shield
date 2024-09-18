import 'dart:async';

/// A utility class for handling null safety and providing default values.
class NullSafetyUtils {
  static void Function(String) _logger = print;

  /// Set a custom logger function
  static void setLogger(void Function(String) logFunction) {
    _logger = logFunction;
  }

  /// Safely access a property or method of a potentially null object.
  static T safeGet<T, E>(E? object, T Function(E) getter, T defaultValue) {
    if (object == null) {
      _logger('safeGet: Object is null, returning default value');
      return defaultValue;
    }
    try {
      return getter(object);
    } catch (e, stackTrace) {
      _logger('Error in safeGet: $e\n$stackTrace');
      return defaultValue;
    }
  }

  /// Safely call a method on a potentially null object.
  static void safeCall<E>(E? object, void Function(E) method) {
    if (object == null) {
      _logger('safeCall: Object is null, skipping method call');
      return;
    }
    try {
      method(object);
    } catch (e, stackTrace) {
      _logger('Error in safeCall: $e\n$stackTrace');
    }
  }

  /// Automatically handle null safety when accessing a property or method.
  static R? autoSafeGet<R, E>(E? object, R Function(E) getter) {
    if (object == null) {
      _logger('autoSafeGet: Object is null, returning null');
      return null;
    }
    try {
      return getter(object);
    } catch (e, stackTrace) {
      _logger('Error in autoSafeGet: $e\n$stackTrace');
      return null;
    }
  }

  /// Safely execute a function that might throw an exception.
  static R? tryCatch<R>(R Function() function, {R? defaultValue}) {
    try {
      return function();
    } catch (e, stackTrace) {
      _logger('Error in tryCatch: $e\n$stackTrace');
      return defaultValue;
    }
  }

  /// Safely execute an async function that might throw an exception.
  static Future<R?> tryCatchAsync<R>(Future<R> Function() function, {R? defaultValue}) async {
    try {
      return await function();
    } catch (e, stackTrace) {
      _logger('Error in tryCatchAsync: $e\n$stackTrace');
      return defaultValue;
    }
  }

  /// Safely access a nested property of an object.
  static R? safeNested<R>(dynamic object, List<String> propertyPath) {
    dynamic current = object;
    for (final property in propertyPath) {
      if (current == null) return null;
      if (current is Map) {
        current = current[property];
      } else {
        try {
          current = current.$property;
        } catch (e) {
          _logger('Error in safeNested: Property $property not found');
          return null;
        }
      }
    }
    return current as R?;
  }

  /// Convert a nullable value to a non-nullable value with a default.
  static T nonNull<T>(T? value, T defaultValue) {
    return value ?? defaultValue;
  }

  /// Safely parse a string to an int.
  static int? safeParseInt(String? value) {
    if (value == null) return null;
    return int.tryParse(value);
  }

  /// Safely parse a string to a double.
  static double? safeParseDouble(String? value) {
    if (value == null) return null;
    return double.tryParse(value);
  }
  /// Safely access a list element
  static T? safeListAccess<T>(List<T>? list, int index) {
    if (list == null || index < 0 || index >= list.length) {
      return null;
    }
    return list[index];
  }

  /// Safely access a map value
  static V? safeMapAccess<K, V>(Map<K, V>? map, K key) {
    return map?[key];
  }

  /// Safely cast an object
  static T? safeCast<T>(dynamic value) {
    return value is T ? value : null;
  }

  /// Safely execute a callback if all conditions are met
  static void safeExecute(List<bool> conditions, Function callback) {
    if (conditions.every((condition) => condition)) {
      callback();
    }
  }

  /// Retry an operation with exponential backoff
  static Future<T?> retry<T>(
      Future<T> Function() operation, {
        int maxAttempts = 3,
        Duration initialDelay = const Duration(seconds: 1),
      }) async {
    int attempts = 0;
    Duration delay = initialDelay;

    while (attempts < maxAttempts) {
      try {
        return await operation();
      } catch (e) {
        attempts++;
        if (attempts >= maxAttempts) rethrow;
        await Future.delayed(delay);
        delay *= 2;
      }
    }
    return null;
  }

  /// Debounce a function
  static Function(T) debounce<T>(
      Function(T) function,
      Duration duration,
      ) {
    Timer? timer;
    return (T param) {
      if (timer != null) {
        timer!.cancel();
      }
      timer = Timer(duration, () => function(param));
    };
  }
}