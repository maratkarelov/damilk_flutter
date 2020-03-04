class Dimen {
  static const ORIGINAL_PIXEL_RATIO = 400.0;
  static double pixelsScaleFactor = 1;
  static double fontScaleFactor = 1;

  static const SWDP_LESS_325_PIXEL_SCALE = 0.7;
  static const SWDP_325_PIXEL_SCALE = 0.8;
  static const SWDP_400_PIXEL_SCALE = 1.0;
  static const SWDP_600_PIXEL_SCALE = 1.5;

  static init(double devicePixelRatio) {
    double dp = devicePixelRatio * 160;

    if (dp >= 600) {
      pixelsScaleFactor = SWDP_600_PIXEL_SCALE;
      fontScaleFactor = SWDP_600_PIXEL_SCALE;
    } else if (dp >= 400) {
      pixelsScaleFactor = SWDP_400_PIXEL_SCALE;
      fontScaleFactor = SWDP_400_PIXEL_SCALE;
    } else if (dp >= 325) {
      pixelsScaleFactor = SWDP_325_PIXEL_SCALE;
      fontScaleFactor = SWDP_325_PIXEL_SCALE;
    } else {
      pixelsScaleFactor = SWDP_LESS_325_PIXEL_SCALE;
      fontScaleFactor = SWDP_LESS_325_PIXEL_SCALE;
    }
  }
}