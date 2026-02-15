/// Source of trusted time
enum TimeSource {
  ntp, // Synced with NTP server
  local, // Local device time (fallback)
  cached, // Cached from previous NTP sync
}

/// Result of trusted time query
class TrustedTimeResult {
  final DateTime time;
  final TimeSource source;
  final bool isManipulated;
  final int deviationSeconds;

  TrustedTimeResult({
    required this.time,
    required this.source,
    required this.isManipulated,
    required this.deviationSeconds,
  });

  // Getters for easy access
  int get hour => time.hour;
  int get minute => time.minute;
  int get second => time.second; // Added second

  @override
  String toString() {
    return 'TrustedTimeResult(time: $time, source: $source, '
        'manipulated: $isManipulated, deviation: ${deviationSeconds}s)';
  }
}
