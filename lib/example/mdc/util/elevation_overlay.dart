final elevationEntries = [
  ElevationOverlay(0, 0.00),
  ElevationOverlay(1, 0.05),
  ElevationOverlay(2, 0.07),
  ElevationOverlay(3, 0.08),
  ElevationOverlay(4, 0.09),
  ElevationOverlay(6, 0.11),
  ElevationOverlay(8, 0.12),
  ElevationOverlay(12, 0.14),
  ElevationOverlay(16, 0.15),
  ElevationOverlay(24, 0.16),
];

const List<int> elevationEntriesList = [0, 1, 2, 3, 4, 6, 8, 12, 16, 24];

class ElevationOverlay {
  ElevationOverlay(this.elevation, this.overlay);

  final int elevation;
  final double overlay;
}
