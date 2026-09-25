import 'package:flutter/foundation.dart';

/// A calendar date without a time, e.g. `2026-09-25`.
@immutable
class Day implements Comparable<Day> {
  const Day(this.year, this.month, this.day);

  factory Day.of(DateTime t) => Day(t.year, t.month, t.day);

  /// The device's local date.
  factory Day.today() => Day.of(DateTime.now());

  /// Parses `2026-09-25`, or returns null.
  static Day? tryParse(String? s) {
    final m = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(s ?? '');
    if (m == null) return null;
    final d = Day(int.parse(m[1]!), int.parse(m[2]!), int.parse(m[3]!));
    return Day.of(d.date) == d ? d : null; // rejects 2026-02-31
  }

  final int year;
  final int month;
  final int day;

  /// Midnight UTC, so adding days never trips over daylight saving.
  DateTime get date => DateTime.utc(year, month, day);

  Day addDays(int n) => Day.of(date.add(Duration(days: n)));

  /// First day of this month, moved by [n] months.
  Day addMonths(int n) => Day.of(DateTime.utc(year, month + n));

  int get daysInMonth => DateTime.utc(year, month + 1, 0).day;

  bool sameMonth(Day other) => other.year == year && other.month == month;

  bool operator <(Day other) => compareTo(other) < 0;
  bool operator >(Day other) => compareTo(other) > 0;
  bool operator <=(Day other) => compareTo(other) <= 0;

  @override
  int compareTo(Day other) => (year * 10000 + month * 100 + day) - (other.year * 10000 + other.month * 100 + other.day);

  @override
  bool operator ==(Object other) => other is Day && other.year == year && other.month == month && other.day == day;

  @override
  int get hashCode => year * 10000 + month * 100 + day;

  @override
  String toString() => '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
}
