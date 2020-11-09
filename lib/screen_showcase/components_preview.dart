import 'package:colorstudio/screen_single_color/screen_single.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hive/hive.dart';

import '../blocs/blocs.dart';
import '../example/util/shuffle_color.dart';
import '../phospor_icons.dart';
import 'showcase.dart';

class ComponentsPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return BlocBuilder<MdcSelectedBloc, MdcSelectedState>(
    //     builder: (context, state) {
    //   final currentState = state as MDCLoadedState;

    // final colors = currentState.rgbColorsWithBlindness;
    // final HSLuvColor backgroundLuv = currentState.hsluvColors[kBackground];
    final isiPad = MediaQuery.of(context).size.shortestSide > 600;

    // final scheme = backgroundLuv.lightness >= kLightnessThreshold
    //     ? ColorScheme.light(
    //         primary: colors[kPrimary],
    //         secondary: colors[kSecondary] ?? colors[kPrimary],
    //         surface: colors[kSurface],
    //         background: colors[kBackground],
    //       )
    //     : ColorScheme.dark(
    //         primary: colors[kPrimary],
    //         secondary: colors[kSecondary] ?? colors[kPrimary],
    //         surface: colors[kSurface],
    //         background: colors[kBackground],
    //       );

    // final Color onBackground = scheme.onBackground;

    // data: ThemeData.from(colorScheme: scheme).copyWith(
    //           cardTheme: Theme.of(context).cardTheme,
    //           toggleableActiveColor: colors[kPrimary],
    //           toggleButtonsTheme: ToggleButtonsThemeData(color: scheme.onSurface),
    //           buttonTheme: Theme.of(context).buttonTheme.copyWith(
    //                 // this is needed for the outline color
    //                 colorScheme: scheme,
    //               ),
    //         ),
    return Scaffold(
      appBar: isiPad
          ? null
          : AppBar(
              title: Text("Components Preview"),
              actions: <Widget>[
                IconButton(
                  tooltip: "Edit colors",
                  icon: Icon(FeatherIcons.sliders),
                  onPressed: () {
                    Navigator.pushNamed(context, "/colordetails");
                  },
                ),
                IconButton(
                  tooltip: "Randomise colors",
                  icon: Center(
                    child: Icon(
                      Phospor.shuffle,
                    ),
                  ),
                  onPressed: () async {
                    final box = await Hive.openBox<dynamic>('settings');
                    final int pref = box.get('shuffle', defaultValue: 0);

                    // BlocProvider.of<MdcSelectedBloc>(context).add(
                    //   MDCUpdateAllEvent(colors: getRandomPreference(pref)),
                    // );
                  },
                )
              ],
            ),
      body: false
          ? Center(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Showcase(),
                  ),
                  Expanded(
                    child: ScreenSingle(),
                  ),
                ],
              ),
            )
          : BlocProvider(
              create: (context) => SliderColorBloc()
                ..add(
                  MoveColor(Theme.of(context).colorScheme.primary, true),
                ),
              child: Showcase(),
            ),
    );
    // });
  }
}
