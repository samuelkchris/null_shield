import 'dart:async';
import 'package:flutter/foundation.dart';

import 'null_safety_utils.dart';

extension NullSafetyExtension on Exception {
  static R? handleNullError<R>(R? Function() function) {
    try {
      return function();
    } on NoSuchMethodError catch (e) {
      debugPrint('Caught NoSuchMethodError: ${e.toString()}');
      return null;
    } on TypeError catch (e) {
      if (e.toString().contains('null')) {
        debugPrint('Caught null-related TypeError: ${e.toString()}');
        return null;
      }
      rethrow;
    }
  }

  static Future<R?> handleNullErrorAsync<R>(Future<R?> Function() function) async {
    try {
      return await function();
    } on NoSuchMethodError catch (e) {
      debugPrint('Caught NoSuchMethodError: ${e.toString()}');
      return null;
    } on TypeError catch (e) {
      if (e.toString().contains('null')) {
        debugPrint('Caught null-related TypeError: ${e.toString()}');
        return null;
      }
      rethrow;
    }
  }
}

extension NullSafetyUtilsExtension on NullSafetyUtils {
  static R? autoSafeGet<R, E>(E? object, R Function(E) getter) {
    return NullSafetyExtension.handleNullError(() =>
    object == null ? null : getter(object)
    );
  }

  static Future<R?> autoSafeGetAsync<R, E>(E? object, Future<R> Function(E) getter) {
    return NullSafetyExtension.handleNullErrorAsync(() =>
    object == null ? Future<R?>.value(null) : getter(object)
    );
  }
}