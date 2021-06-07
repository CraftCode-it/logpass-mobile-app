extension TimerUtils on DateTime {
  String toCountdown() {
    final now = DateTime.now();
    final duration = difference(now);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds - (minutes * 60);
    final formattedMinutes = minutes.toString().padLeft(2, '0');
    final formattedSeconds = seconds.toString().padLeft(2, '0');
    return '$formattedMinutes:$formattedSeconds min.';
  }
}
