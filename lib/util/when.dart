// thanks to Remi Rousselet for the implementation.

T when<T>(Map<bool Function(), T Function()> conditions,
    {T Function()? orElse}) {
  for (final dynamic entry in conditions.entries) {
    if (entry.key()) {
      return entry.value();
    }
  }
  return orElse!();
}
