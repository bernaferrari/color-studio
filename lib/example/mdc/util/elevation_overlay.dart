final elevationEntries = [
  ElevationOverlay2(0, 0.00),
  ElevationOverlay2(1, 0.05),
  ElevationOverlay2(2, 0.07),
  ElevationOverlay2(3, 0.08),
  ElevationOverlay2(4, 0.09),
  ElevationOverlay2(6, 0.11),
  ElevationOverlay2(8, 0.12),
  ElevationOverlay2(12, 0.14),
  ElevationOverlay2(16, 0.15),
  ElevationOverlay2(24, 0.16),
];

const List<int> elevationEntriesList = [0, 1, 2, 3, 4, 6, 8, 12, 16, 24];

class ElevationOverlay2 {
  ElevationOverlay2(this.elevation, this.overlay);

  final int elevation;
  final double overlay;
}
