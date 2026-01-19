class LifeModel {
  LifeModel({
    required this.dateOfBirth,
    required this.lifespanYears,
    required this.totalLifeDays,
    required this.daysLived,
    required this.remainingDays,
    required this.progress,
  });

  final DateTime dateOfBirth;
  final int lifespanYears;
  final int totalLifeDays;
  final int daysLived;
  final int remainingDays;
  final double progress;
}
