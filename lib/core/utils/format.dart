/// Compact "time ago" (s / m / h / d).
String ago(DateTime d) {
  final s = DateTime.now().difference(d).inSeconds.clamp(0, 1 << 31);
  if (s < 60) return '${s}s';
  if (s < 3600) return '${s ~/ 60}m';
  if (s < 86400) return '${s ~/ 3600}h';
  return '${s ~/ 86400}d';
}
