// utils.dart

import 'dart:math';
import 'package:intl/intl.dart';

/// Generates a unique ID of specified length using random characters.
String generateUniqueId(int length) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random rnd = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
}

/// Returns the current date in 'yyyy-MM-dd' format.
String getFormattedDate() {
  DateTime now = DateTime.now();
  return DateFormat('yyyy-MM-dd').format(now);
}
