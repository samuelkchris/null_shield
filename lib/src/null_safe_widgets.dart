import 'package:flutter/material.dart';

class NullSafeBuilder<T> extends StatelessWidget {
  final T? value;
  final Widget Function(BuildContext, T) builder;
  final Widget? fallback;

  const NullSafeBuilder({
    super.key,
    required this.value,
    required this.builder,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return value != null
        ? builder(context, value as T)
        : fallback ?? const SizedBox.shrink();
  }
}

class NullSafeFutureBuilder<T> extends StatelessWidget {
  final Future<T?> future;
  final Widget Function(BuildContext, T) builder;
  final Widget? loadingWidget;
  final Widget? fallback;

  const NullSafeFutureBuilder({
    super.key,
    required this.future,
    required this.builder,
    this.loadingWidget,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T?>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget ?? const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return fallback ?? Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data != null) {
          return builder(context, snapshot.data as T);
        } else {
          return fallback ?? const SizedBox.shrink();
        }
      },
    );
  }
}