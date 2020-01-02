import 'package:colorstudio/example/blocs/blocs.dart';
import 'package:colorstudio/example/contrast/shuffle_color.dart';
import 'package:colorstudio/example/mdc/showcase.dart';
import 'package:colorstudio/example/screens/home.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hsluv/hsluvcolor.dart';

class ComponentsPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MdcSelectedBloc, MdcSelectedState>(
        builder: (context, state) {
      final currentState = state as MDCLoadedState;

      final allItems = currentState.rgbColorsWithBlindness;

      final Color primaryColor = allItems[kPrimary];
      final Color surfaceColor = allItems[kSurface];
      final Color backgroundColor = allItems[kBackground];
      final HSLuvColor backgroundLuv = currentState.hsluvColors[kBackground];

      final Color onPrimary =
          currentState.hsluvColors[kPrimary].lightness >= kLightnessThreshold
              ? Colors.black
              : Colors.white;

      final Color onSurface =
          currentState.hsluvColors[kSurface].lightness >= kLightnessThreshold
              ? Colors.black
              : Colors.white;

      final isiPad = MediaQuery.of(context).size.shortestSide > 600;

      final scheme = backgroundLuv.lightness >= kLightnessThreshold
          ? ColorScheme.light(
              primary: primaryColor,
              secondary: primaryColor,
              onPrimary: onPrimary,
              onSurface: onSurface,
              surface: surfaceColor,
              background: backgroundColor,
            )
          : ColorScheme.dark(
              primary: primaryColor,
              secondary: primaryColor,
              onPrimary: onPrimary,
              onSurface: onSurface,
              surface: surfaceColor,
              background: backgroundColor,
            );

      final Color onBackground = scheme.onBackground;

      return Theme(
        data: ThemeData.from(colorScheme: scheme).copyWith(
          cardTheme: Theme.of(context).cardTheme,
          toggleableActiveColor: primaryColor,
          toggleButtonsTheme: ToggleButtonsThemeData(color: scheme.onSurface),
          buttonTheme: Theme.of(context).buttonTheme.copyWith(
                // this is needed for the outline color
                colorScheme: scheme,
              ),
        ),
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
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
                icon: Icon(
                  FeatherIcons.shuffle,
                ),
                onPressed: () async {
                  final box = await Hive.openBox('settings');
                  final int pref = box.get('shuffle', defaultValue: 0);

                  BlocProvider.of<MdcSelectedBloc>(context).add(
                    MDCUpdateAllEvent(colors: getRandomPreference(pref)),
                  );
                },
              )
            ],
          ),
          body: isiPad
              ? Center(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Showcase(
                          primaryColor: primaryColor,
                          backgroundColor: backgroundColor,
                          surfaceColor: surfaceColor,
                          onBackgroundColor: onBackground,
                          onSurfaceColor: onSurface,
                          currentState: currentState,
                        ),
                      ),
                      Expanded(
                        child: SingleColorHome(isSplitView: true),
                      ),
                    ],
                  ),
                )
              : BlocProvider(
                  create: (context) => SliderColorBloc()
                    ..add(
                      MoveColor(primaryColor, true),
                    ),
                  child: Showcase(
                    primaryColor: primaryColor,
                    backgroundColor: backgroundColor,
                    surfaceColor: surfaceColor,
                    onBackgroundColor: onBackground,
                    onSurfaceColor: onSurface,
                    currentState: currentState,
                  ),
                ),
        ),
      );
    });
  }
}

class _SelectableMenu extends StatefulWidget {
  const _SelectableMenu({this.children});

  final List<Widget> children;

  @override
  __SelectableMenuState createState() => __SelectableMenuState();
}

class __SelectableMenuState extends State<_SelectableMenu> {
  List<bool> isSelected = [true, false, false, false];

  @override
  void initState() {
    final List<bool> wasSelected = PageStorage.of(context)
        .readState(context, identifier: const ValueKey("MDC Selected"));
    if (wasSelected != null) {
      isSelected = wasSelected;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ToggleButtons(
          textStyle: GoogleFonts.b612Mono(),
          children: <Widget>[
            const Text("MDC"),
            // material design components, in the absence of a decent icon.
            Icon(FeatherIcons.list),
            // list of different UIs.
            Icon(FeatherIcons.smile),
            // a good contrast might not make people smile, but a bad contrast will certainly make them cry.
            Icon(FeatherIcons.briefcase),
            // get inspired by someone who already did the job for you
          ],
          onPressed: (int index) {
            setState(() {
              for (int buttonIndex = 0;
                  buttonIndex < isSelected.length;
                  buttonIndex++) {
                if (buttonIndex == index) {
                  isSelected[buttonIndex] = true;
                } else {
                  isSelected[buttonIndex] = false;
                }
              }
              PageStorage.of(context).writeState(context, isSelected,
                  identifier: const ValueKey("MDC Selected"));
            });
          },
          isSelected: isSelected,
        ),
        Expanded(
          child: widget.children[isSelected.indexOf(true)],
        ),
      ],
    );
  }
}
