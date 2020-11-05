const double kLumContrast = 0.34;

// 65 = 100 - 0.34 * 100
const double kLightnessThreshold = 66;
const double kVeryTransparent = 0.20;

const String kPrimary = "Primary";
const String kBackground = "Background";
const String kSecondary = "Secondary";
const String kSurface = "Surface";

enum ColorType {
  Primary,
  Secondary,
  Background,
  Surface,
  OnPrimary,
  OnSecondary,
  OnBackground,
  OnSurface,
}

const String kAALarge = "AA+ (3.0)";
const String kAA = "AA (4.5)";
const String kAAA = "AAA (7.0)";

const int maxContrastItemsLen = 24;

const double defaultRadius = 16.0;
