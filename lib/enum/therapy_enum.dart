enum TherapyMode { everyday, daysofweek, intervalofdays }

extension TherapyType on TherapyMode {
  get label {
    switch (this) {
      case TherapyMode.everyday:
        return true;
      case TherapyMode.daysofweek:
        return true;
      case TherapyMode.intervalofdays:
        return true;
      default:
        return false;
    }
  }
}
