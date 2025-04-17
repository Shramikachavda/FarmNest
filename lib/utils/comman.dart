import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension IterableExt on Iterable < Widget > {
  Iterable<Widget> separator (Widget element) sync * {
    final iterator = this.iterator;
    if (iterator.moveNext()) {
      yield iterator . current;
      while (iterator.moveNext()) {
        yield element;
        yield iterator . current;
      }
    }
  }
}

extension DateFormatting on DateTime {
  String format([String pattern = 'dd/MM/yyyy']) {
    return DateFormat(pattern).format(this);
  }
}


extension ListSeparation<T> on List<T> {
  /// Splits the list into two lists based on the condition
  /// Returns a Tuple (List<T>, List<T>) => (matches, nonMatches)
  (List<T>, List<T>) separateList(bool Function(T) condition) {
    final match = <T>[];
    final nonMatch = <T>[];

    for (final item in this) {
      if (condition(item)) {
        match.add(item);
      } else {
        nonMatch.add(item);
      }
    }

    return (match, nonMatch);
  }
}

extension DistinctByExtension<T> on Iterable<T> {
  Iterable<T> distinctBy<K>(K Function(T) keySelector) {
    final seenKeys = <K>{};
    return where((element) => seenKeys.add(keySelector(element)));
  }
}

