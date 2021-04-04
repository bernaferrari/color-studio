import 'package:flutter/material.dart';

class TemplateStruct {
  const TemplateStruct({
    required this.title,
    required this.colors,
    required this.contrastingColors,
  });

  final String title;

  final List<Color> colors;

  // the list of colors that contrat with [colors], either black or white,
  // to avoid calculating at runtime.
  final List<Color> contrastingColors;
}

const darkTheme = [
  TemplateStruct(
    title: "Birdy",
    colors: [Color(0xff1da1f3), Color(0xff16202a)],
    contrastingColors: [Colors.white, Colors.white],
  ),
  TemplateStruct(
    title: "Flamingo",
    colors: [Color(0xff4286f5), Color(0xff1b1b1b)],
    contrastingColors: [Colors.white, Colors.white],
  ),
  // from Sam Houston
  TemplateStruct(
    title: "Twilight",
    colors: [Color(0xff319de6), Color(0xff20222f)],
    contrastingColors: [Colors.white, Colors.white],
  ),
  // Facebook's Threads app
  TemplateStruct(
    title: "Midnight",
    colors: [Color(0xfff2355b), Color(0xff000000)],
    contrastingColors: [Colors.white, Colors.white],
  ),
  // Facebook's Threads app
  TemplateStruct(
    title: "Aurora",
    colors: [Color(0xff2a9a8c), Color(0xff001b12)],
    contrastingColors: [Colors.white, Colors.white],
  ),
  // Facebook's Threads app
  TemplateStruct(
    title: "P Store",
    colors: [Color(0xff00a273), Color(0xff202125)],
    contrastingColors: [Colors.white, Colors.white],
  ),
  // Google Play Store
  TemplateStruct(
    title: "P Games",
    colors: [Color(0xff5bda7f), Color(0xff202125)],
    contrastingColors: [Colors.black, Colors.white],
  ),
  // Google Play Store
  TemplateStruct(
    title: "P Movies",
    colors: [Color(0xffcc2948), Color(0xff202125)],
    contrastingColors: [Colors.white, Colors.white],
  ),
  TemplateStruct(
    title: "Podcast",
    colors: [Color(0xffeb4745), Color(0xff1a1b1d)],
    contrastingColors: [Colors.white, Colors.white],
  ),
  // I was listening to Wendover podcast and liked the colors in PocketCasts
  TemplateStruct(
    title: "Champagne",
    colors: [Color(0xffff596a), Color(0xff081110)],
    contrastingColors: [Colors.white, Colors.white],
  ),
  // I was listening to Andrea Bocelli's Champagne and liked the color from Spotify cover on Android notification
  TemplateStruct(
    title: "Naked",
    colors: [Color(0xffBA4DE4), Color(0xff191919)],
    contrastingColors: [Colors.white, Colors.white],
  ),
  TemplateStruct(
    title: "SamAssist",
    colors: [Color(0xff3c8eb3), Color(0xff090b20)],
    contrastingColors: [Colors.white, Colors.white],
  ),
  TemplateStruct(
    title: "Rally",
    colors: [Color(0xffffcf44), Color(0xff32333D)],
    contrastingColors: [Colors.black, Colors.white],
  ),
  TemplateStruct(
    title: "Crane",
    colors: [Color(0xffffffff), Color(0xff5c0f48)],
    contrastingColors: [Colors.black, Colors.white],
  ),
  TemplateStruct(
    title: "B&W",
    colors: [Color(0xffffffff), Color(0xff000000)],
    contrastingColors: [Colors.black, Colors.white],
  ),
  TemplateStruct(
    title: "Cupertino",
    colors: [
      Color(0xff3A82F7),
      Color(0xff000000),
      // Color(0xff1B1C1E),
    ],
    contrastingColors: [Colors.black, Colors.white],
  ),
  TemplateStruct(
    title: "MoleRed",
    colors: [
      Color(0xffffffff),
      Color(0xff87202d),
      // Color(0xff922333),
    ],
    contrastingColors: [Colors.black, Colors.white, Colors.white],
  ),
  TemplateStruct(
    title: "MoleGrey",
    colors: [
      Color(0xff55baba),
      Color(0xff1C2529),
      // Color(0xff243037),
    ],
    contrastingColors: [Colors.black, Colors.white],
  ),
  TemplateStruct(
    title: "Black Bird",
    colors: [Color(0xff1da1f3), Color(0xff0a0c0f)],
    contrastingColors: [Colors.black, Colors.white],
  ),
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

const templateThemes = [...darkTheme, ...lightTheme, ...claimTheme];
