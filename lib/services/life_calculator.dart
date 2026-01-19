import '../models/life_model.dart';

class LifeCalculator {
  static LifeModel calculate({
    required DateTime dateOfBirth,
    required int lifespanYears,
    DateTime? today,
  }) {
    // TTL intentionally uses date-only math to avoid countdown behavior and
    // keep the experience calm and aligned with local time.
    final DateTime normalizedDob = _dateOnly(dateOfBirth);
    final DateTime normalizedToday = _dateOnly(today ?? DateTime.now());
    final DateTime preferredDeathDate = DateTime(
      normalizedDob.year + lifespanYears,
      normalizedDob.month,
      normalizedDob.day,
    );

    final int totalLifeDays = _daysBetween(normalizedDob, preferredDeathDate);
    final int daysLived = _daysBetween(normalizedDob, normalizedToday);
    final int rawRemaining = totalLifeDays - daysLived;
    final int remainingDays = rawRemaining < 0 ? 0 : rawRemaining;
    final double progress = totalLifeDays == 0
        ? 0
        : (daysLived / totalLifeDays).clamp(0.0, 1.0);

    return LifeModel(
      dateOfBirth: normalizedDob,
      lifespanYears: lifespanYears,
      totalLifeDays: totalLifeDays,
      daysLived: daysLived,
      remainingDays: remainingDays,
      progress: progress,
    );
  }

  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static int _daysBetween(DateTime start, DateTime end) {
    return end.difference(start).inDays;
  }
}
