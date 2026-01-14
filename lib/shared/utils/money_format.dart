String formatClp(int amount) {
  final negative = amount < 0;
  final n = amount.abs().toString();
  final buf = StringBuffer();
  for (int i = 0; i < n.length; i++) {
    final idxFromEnd = n.length - i;
    buf.write(n[i]);
    if (idxFromEnd > 1 && idxFromEnd % 3 == 1) {
      buf.write('.');
    }
  }
  final s = buf.toString();
  return negative ? '-$s' : s;
}
