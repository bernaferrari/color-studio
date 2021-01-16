import 'dart:math' as math;

import 'package:colorstudio/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hsluv/hsluvcolor.dart';

import '../screen_single_color/templates/dynamic_templates_item.dart';
import '../screen_single_color/templates/templates_themes.dart';
import '../util/color_util.dart';
import '../util/constants.dart';

const darkTheme2 = [
  [
    Color(0xff1da1f3),
    Color(0xff16202a),
  ],
  [Color(0xff4286f5), Color(0xff1b1b1b)],
  [Color(0xff319de6), Color(0xff20222f)],
  [Color(0xff2a9a8c), Color(0xff001b12)],
  [Color(0xff00a273), Color(0xff202125)],
  // [Color(0xff5bda7f), Color(0xff202125)],
  [Color(0xff5bda7f), Color(0xff2a347b)],
  [Color(0xffeb4745), Color(0xff1a1b1d)],
  [Color(0xffff596a), Color(0xff081110)],
  [Color(0xfff2355b), Color(0xff000000)],
  [Color(0xffcc2948), Color(0xff202125)],
  [Color(0xffff0061), Color(0xff2a191d)],
  [Color(0xffff5f3e), Color(0xff191313)],
  [Color(0xffa381fa), Color(0xff261d2f)],
  [Color(0xffBA4DE4), Color(0xff191919)],
  [Color(0xff3c8eb3), Color(0xff090b20)],
  [Color(0xffffcf44), Color(0xff32333D)],
  [Color(0xffffd34b), Color(0xff132e7d)],
  [Color(0xffffffff), Color(0xff5c0f48)],
  [Color(0xffffffff), Color(0xff000000)],
  [Color(0xffffffff), Color(0xff87202d)],
  [Color(0xff55baba), Color(0xff1C2529)],
  [Color(0xff431404), Color(0xffbe4b19)],
  [Color(0xffd0f675), Color(0xff2a12f0)],
  [Color(0xffd7f880), Color(0xfff42da2)],
  // [Color(0xff9ffff1), Color(0xffcc007d)],
  [Color(0xffc9007c), Color(0xff8fe5d9)],
  [Color(0xffff3d38), Color(0xff191313)],
  [Color(0xfff654c0), Color(0xff280656)],
  [Color(0xfff49232), Color(0xffc9f9fc)],

];

const lightTheme = [
  TemplateStruct(
    title: "W&B",
    colors: [Color(0xff000000), Color(0xffffffff)],
    contrastingColors: [Colors.white, Colors.black],
  ),
  TemplateStruct(
    title: "Mingo",
    colors: [Color(0xff3e3e3e), Color(0xfff0f0f0)],
    contrastingColors: [Colors.white, Colors.black],
  ),
  TemplateStruct(
    title: "Basil",
    colors: [Color(0xff356859), Color(0xfffffbe6)],
    contrastingColors: [Colors.white, Colors.black],
  ),
  TemplateStruct(
    title: "Shrine",
    colors: [Color(0xff442c2e), Color(0xfffedbd0)],
    contrastingColors: [Colors.white, Colors.black],
  ),
  TemplateStruct(
    title: "Reply",
    colors: [Color(0xff496572), Color(0xffedf0f2)],
    contrastingColors: [Colors.white, Colors.black],
  ),
  TemplateStruct(
    title: "Crane",
    colors: [Color(0xffE31E24), Color(0xffF8F8F8)],
    contrastingColors: [Colors.white, Colors.black],
  ),
  TemplateStruct(
    title: "Fortnightly",
    colors: [Color(0xff6b38fb), Color(0xffffffff)],
    contrastingColors: [Colors.white, Colors.black],
  ),
  TemplateStruct(
    title: "Owl 1",
    colors: [Color(0xffffde03), Color(0xff0336ff)],
    contrastingColors: [Colors.black, Colors.white],
  ),
  TemplateStruct(
    title: "Owl 2",
    colors: [Color(0xff000000), Color(0xffff0266)],
    contrastingColors: [Colors.white, Colors.black],
  ),
  TemplateStruct(
    title: "SamClock",
    colors: [Color(0xff6063F0), Color(0xfffcfcfc)],
    contrastingColors: [Colors.white, Colors.black],
  ),
];

const claimTheme = [
  TemplateStruct(
    title: "16",
    colors: [Color(0xffFFFFFF), Color(0xff0E38B1)],
    contrastingColors: [Colors.black, Colors.white],
  ),
  TemplateStruct(
    title: "27",
    colors: [Color(0xffD31B33), Color(0xffFDF06F)],
    contrastingColors: [Colors.white, Colors.black],
  ),
  TemplateStruct(
    title: "31",
    colors: [Color(0xffEA1821), Color(0xff1B1D1C)],
    contrastingColors: [Colors.white, Colors.white],
  ),
  TemplateStruct(
    title: "33",
    colors: [Color(0xff1FC8A9), Color(0xffFFEFE5)],
    contrastingColors: [Colors.white, Colors.black],
  ),
  TemplateStruct(
    title: "35",
    colors: [Color(0xff28292B), Color(0xff77EEDF)],
    contrastingColors: [Colors.white, Colors.black],
  ),
  TemplateStruct(
    title: "37",
    colors: [Color(0xff28292B), Color(0xffEED974)],
    contrastingColors: [Colors.white, Colors.black],
  ),
  TemplateStruct(
    title: "52",
    colors: [Color(0xffEDC3C7), Color(0xff00B28B)],
    contrastingColors: [Colors.black, Colors.white],
  ),
  TemplateStruct(
    title: "59",
    colors: [Color(0xff481C19), Color(0xffEF303B)],
    contrastingColors: [Colors.white, Colors.black],
  ),
  TemplateStruct(
    title: "62",
    colors: [Color(0xff1539CF), Color(0xffF1D3D3)],
    contrastingColors: [Colors.white, Colors.black],
  ),
  TemplateStruct(
    title: "71",
    colors: [Color(0xff7A30CF), Color(0xff75FFC0)],
    contrastingColors: [Colors.white, Colors.black],
  ),
  TemplateStruct(
    title: "72",
    colors: [Color(0xff0C00FF), Color(0xffFB9B2A)],
    contrastingColors: [Colors.white, Colors.black],
  ),
  TemplateStruct(
    title: "75",
    colors: [Color(0xff1FDE91), Color(0xff083EA7)],
    contrastingColors: [Colors.black, Colors.white],
  ),
  TemplateStruct(
    title: "79",
    colors: [Color(0xffD17C78), Color(0xff121738)],
    contrastingColors: [Colors.white, Colors.white],
  ),
  TemplateStruct(
    title: "81",
    colors: [Color(0xff042D5B), Color(0xffFC3C2D)],
    contrastingColors: [Colors.white, Colors.black],
  ),
  TemplateStruct(
    title: "83",
    colors: [Color(0xff9B8FFF), Color(0xff54120A)],
    contrastingColors: [Colors.black, Colors.white],
  ),
  TemplateStruct(
    title: "89",
    colors: [Color(0xff0606FF), Color(0xffCDFF06)],
    contrastingColors: [Colors.white, Colors.black],
  ),
  TemplateStruct(
    title: "97",
    colors: [Color(0xff5C22FF), Color(0xff00FDFF)],
    contrastingColors: [Colors.white, Colors.black],
  ),
  TemplateStruct(
    title: "107",
    colors: [Color(0xff8ADB16), Color(0xff618133)],
    contrastingColors: [Colors.black, Colors.white],
  ),
  TemplateStruct(
    title: "111",
    colors: [Color(0xffF9FF0D), Color(0xff00458A)],
    contrastingColors: [Colors.black, Colors.white],
  ),
  TemplateStruct(
    title: "112",
    colors: [Color(0xff000000), Color(0xff34FF6D)],
    contrastingColors: [Colors.white, Colors.black],
  ),
  TemplateStruct(
    title: "114",
    colors: [Color(0xffECE2BF), Color(0xffA31B00)],
    contrastingColors: [Colors.black, Colors.white],
  ),
  TemplateStruct(
    title: "116",
    colors: [Color(0xff01346D), Color(0xff79DDF2)],
    contrastingColors: [Colors.white, Colors.black],
  ),
  TemplateStruct(
    title: "118",
    colors: [Color(0xffCB68FF), Color(0xff003CFE)],
    contrastingColors: [Colors.black, Colors.white],
  ),
];

HSLuvColor addLuv(
    {HSLuvColor luv, int hue = 0, int saturation = 0, int lightness = 0}) {
  return HSLuvColor.fromHSL(
    math.max(0, (luv.hue + hue).abs() % 360),
    math.max(0, math.min(luv.saturation + saturation, 100)),
    math.max(0, math.min(luv.lightness + lightness, 100)),
  );
}

Color luvSetHue(
    {HSLuvColor luv,
    double hue = 0,
    double saturation = 0,
    double lightness = 0}) {
  return HSLuvColor.fromHSL(
    math.max(0, (luv.hue + hue).abs() % 360),
    saturation,
    lightness,
  ).toColor();
}

class NewScreen extends StatelessWidget {
  const NewScreen({
    this.rgbColors,
    this.rgbColorsWithBlindness,
    this.hsluvColors,
    this.locked,
    Key key,
  }) : super(key: key);

  final Map<ColorType, Color> rgbColors;
  final Map<ColorType, Color> rgbColorsWithBlindness;
  final Map<ColorType, HSLuvColor> hsluvColors;
  final Map<ColorType, bool> locked;

  @override
  Widget build(BuildContext context) {
    final cupertinoiOS = [
      Color(0xff0087FA),
      Color(0xff27D265),
      Color(0xff535EE1),
      Color(0xffFF9C2E),
      Color(0xffFF295F),
      Color(0xffBE5AEC),
      Color(0xffFF3B3D),
      Color(0xff54D4FD),
      Color(0xffFFD53D)
    ];

    final cupertinoiOSAccessible = [
      Color(0xff1E9EFA),
      Color(0xff26DC69),
      Color(0xff747CF9),
      Color(0xffFFB14F),
      Color(0xffFF5F81),
      Color(0xffD98FFA),
      Color(0xffFF6463),
      Color(0xff63D9FD),
      Color(0xffFDD145)
    ];

    final materialA400 = [
      Color(0xffFF1744),
      Color(0xffF50057),
      Color(0xffD500F9),
      Color(0xff651FFF),
      Color(0xff3D5AFE),
      Color(0xff2979FF),
      Color(0xff00B0FF),
      Color(0xff00E5FF),
      Color(0xff1DE9B6),
      Color(0xff00E676),
      Color(0xff76FF03),
      Color(0xffC6FF00),
      Color(0xffFFEA00),
      Color(0xffFFC400),
      Color(0xffFF9100),
      Color(0xffFF3D00),
    ];

    final alternateBlue = [
      // Apple
      Color(0xff1E9EFA),
      Color(0xff0091FA),

      // Material A200
      Color(0xff536DFE),
      Color(0xff448AFF),
      Color(0xff40C4FF),

      // Material A400
      Color(0xff3D5AFE),
      Color(0xff2979FF),
      Color(0xff00B0FF),
    ];

    final hsluv = HSLuvColor.fromColor(rgbColors[ColorType.Primary]);

    final grayColors = [
      [
        // Apple
        Color(0xff000000),
        Color(0xff2C2C2E),
      ],
      [
        // Material Dark bg + 1pt of elevation
        Color(0xff121212),
        Color(0xff1E1E1E),
      ],
      [
        // Mac Finder
        Color(0xff212422),
        Color(0xff2A2D2B),
      ],
      [
        // Microsoft ToDo
        Color(0xff080808),
        Color(0xff212121),
      ],
    ];

    final background = blendColorWithBackground(Color(0xff0087FA));

    final combinationsDynamic = [
      // [
      //   background,
      //   addLuv(luv: HSLuvColor.fromColor(background), lightness: 5).toColor(),
      // ],
      [
        luvSetHue(luv: hsluv, hue: -38, saturation: 100, lightness: 7),
        luvSetHue(luv: hsluv, hue: -38, saturation: 55, lightness: 12),
      ],
      // [
      //   luvSetHue(luv: hsluv, hue: 35, saturation: 50, lightness: 3),
      //   luvSetHue(luv: hsluv, hue: 30, saturation: 40, lightness: 8),
      // ],
      [
        HSLColor.fromAHSL(1, (hsluv.hue + 35) % 360, 0.8, 0.05).toColor(),
        HSLColor.fromAHSL(1, (hsluv.hue + 30) % 360, 0.4, 0.10).toColor(),
      ],
      // [
      //   luvSetHue(luv: hsluv, hue: 10, saturation: 30, lightness: 5),
      //   luvSetHue(luv: hsluv, hue: 10, saturation: 50, lightness: 12),
      // ],
      [
        HSLColor.fromAHSL(1, math.max(hsluv.hue - 38, 0), 1.0, 0.08).toColor(),
        HSLColor.fromAHSL(1, math.max(hsluv.hue - 38, 0), 1.0, 0.15).toColor(),
      ],
      // [
      //   luvSetHue(luv: hsluv, hue: 180, saturation: 80, lightness: 4),
      //   luvSetHue(luv: hsluv, hue: 180, saturation: 20, lightness: 12),
      // ],
      // [
      //   HSLColor.fromAHSL(1, (hsluv.hue + 180) % 360, 1.0, 0.08).toColor(),
      //   HSLColor.fromAHSL(1, (hsluv.hue + 180) % 360, 0.50, 0.14).toColor(),
      // ],
    ];

    final combinationsClaim = [
      // Aurora LUV
      // [
      //   luvSetHue(luv: hsluv, hue: 40, saturation: 100, lightness: 7),
      //   luvSetHue(luv: hsluv, hue: 40, saturation: 100, lightness: 12),
      // ],
      // Aurora HSV
      [
        HSLColor.fromAHSL(1, (hsluv.hue + 40) % 360, 1.0, 0.07).toColor(),
        HSLColor.fromAHSL(1, (hsluv.hue + 40) % 360, 1.0, 0.12).toColor(),
      ],
      // 75 LUV
      [
        luvSetHue(luv: hsluv, hue: 108, saturation: 97, lightness: 30),
        luvSetHue(luv: hsluv, hue: 108, saturation: 80, lightness: 38),
      ],
      // 75 LUV radical
      [
        luvSetHue(luv: hsluv, hue: 8, saturation: 98, lightness: 30),
        luvSetHue(luv: hsluv, hue: 108, saturation: 97, lightness: 74),
      ],
      // 75 HSV radical
      [
        HSLColor.fromAHSL(1, (hsluv.hue + 52) % 360, 0.86, 0.32).toColor(),
        HSLColor.fromAHSL(1, (hsluv.hue + 12) % 360, 0.95, 0.65).toColor(),
      ],
      // 79 LUV
      [
        luvSetHue(luv: hsluv, hue: 10, saturation: 59, lightness: 9),
        luvSetHue(luv: hsluv, hue: 240, saturation: 100, lightness: 70),
      ],
      // 79 HSV.
      [
        HSLColor.fromAHSL(1, (hsluv.hue + 10) % 360, 0.59, 0.09).toColor(),
        HSLColor.fromAHSL(1, (hsluv.hue + 240) % 360, 0.80, 0.60).toColor(),
      ],
      // 81
      [
        luvSetHue(luv: hsluv, hue: 245, saturation: 60, lightness: 16),
        luvSetHue(luv: hsluv, hue: 255, saturation: 85, lightness: 40),
      ],
      // 81 HSL
      [
        HSLColor.fromAHSL(1, (hsluv.hue + 240) % 360, 1.0, 0.12).toColor(),
        HSLColor.fromAHSL(1, (hsluv.hue + 220) % 360, 0.85, 0.06).toColor(),
      ],
      // 114 LUV
      // [
      //   luvSetHue(luv: hsluv, hue: 140, saturation: 100, lightness: 4),
      //   luvSetHue(luv: hsluv, hue: 120, saturation: 30, lightness: 12),
      // ],
      // 114 HSV
      [
        HSLColor.fromAHSL(1, (hsluv.hue + 140) % 360, 1.0, 0.04).toColor(),
        HSLColor.fromAHSL(1, (hsluv.hue + 120) % 360, 0.30, 0.12).toColor(),
      ],
    ];

    final combinations = [
      ...grayColors,
      ...combinationsDynamic,
      ...combinationsClaim
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SwitchListTile(
                  tileColor: Theme.of(context).colorScheme.surface,
                  activeColor: Theme.of(context).colorScheme.primary,
                  value: true,
                  onChanged: (value) {},
                  title: Text("High Contrast"),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SwitchListTile(
                  tileColor: Theme.of(context).colorScheme.surface,
                  activeColor: Theme.of(context).colorScheme.primary,
                  value: true,
                  onChanged: (value) {},
                  title: Text("Dark Theme"),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        // Card(
        //   child: Padding(
        //     padding: const EdgeInsets.all(16.0),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.stretch,
        //       children: [
        //         Text(
        //           "Primary",
        //           textAlign: TextAlign.start,
        //           style: Theme.of(context).textTheme.headline6,
        //         ),
        //         SizedBox(height: 16),
        //         Wrap(
        //           spacing: 8,
        //           runSpacing: 8,
        //           alignment: WrapAlignment.center,
        //           children: [
        //             ...cupertinoiOS.map(
        //               (d) => ColorButton(
        //                 color: d,
        //                 selected: d == rgbColors[ColorType.Primary],
        //               ),
        //             ),
        //             RainbowButton(),
        //           ],
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        SizedBox(height: 16),
        SizedBox(
          height: 600,
          child: CustomScrollView(
            key: PageStorageKey("TemplatesScrollView"),
            primary: false,
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Dynamic Themes",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.40),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Text(
                        //   "Primary",
                        //   textAlign: TextAlign.start,
                        //   style: Theme.of(context).textTheme.headline6,
                        // ),
                        // SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            ...cupertinoiOS.map(
                              (d) => ColorButton(
                                color: d,
                                selected: d == rgbColors[ColorType.Primary],
                              ),
                            ),
                            RainbowButton(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPadding(padding: EdgeInsets.all(8)),
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: MediaQuery.of(context).size.width / 500,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (_, index) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: Theme.of(context).colorScheme.copyWith(
                              background: combinations[index][0],
                              surface: combinations[index][1],
                            ),
                      ),
                      child: DynamicTemplatePreview(
                        backgroundColor: combinations[index][0],
                        surfaceColor: combinations[index][1],
                        isDynamic: true,
                      ),
                    );
                  },
                  childCount: combinations.length,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Static Themes",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: MediaQuery.of(context).size.width / 500,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (_, index) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: Theme.of(context).colorScheme.copyWith(
                              primary: darkTheme2[index][0],
                              background: darkTheme2[index][1],
                              surface: Color.alphaBlend(
                                Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.10),
                                darkTheme2[index][1],
                              ),
                            ),
                      ),
                      child: DynamicTemplatePreview(
                        title: index.toString(),
                        backgroundColor: darkTheme2[index][1],
                        isDynamic: false,
                        surfaceColor: Color.alphaBlend(
                          Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.10),
                          darkTheme2[index][1],
                        ),
                      ),
                    );
                  },
                  childCount: darkTheme2.length,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ColorButton extends StatelessWidget {
  const ColorButton({
    Key key,
    this.color,
    this.selected,
  }) : super(key: key);

  final Color color;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          primary: color,
          side: BorderSide(
            color: Colors.white.withOpacity(0.20),
            width: 1,
          ),
        ),
        onPressed: () {
          context
              .read<ColorsCubit>()
              .updateRgbColor(rgbColor: color, selected: ColorType.Primary);
        },
        child: selected
            ? Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              )
            : null,
      ),
    );
  }
}

class RainbowButton extends StatelessWidget {
  const RainbowButton({
    Key key,
    this.selected,
  }) : super(key: key);

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.zero,
          side: BorderSide(
            color: Colors.white.withOpacity(0.20),
            width: 1,
          ),
        ),
        onPressed: () {},
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [
                  0.1,
                  0.3,
                  0.6,
                  0.9
                ],
                colors: [
                  Colors.yellow,
                  Colors.red,
                  Colors.indigo,
                  Colors.blue
                ]),
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class CustomSeparator extends StatelessWidget {
  const CustomSeparator({Key key, this.numberOfLines}) : super(key: key);

  final int numberOfLines;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (var i = 0; i < numberOfLines; i++)
          Container(
            height: 16,
            width: 1,
            color: Colors.white.withOpacity(0.30),
          ),
      ],
    );
  }
}
