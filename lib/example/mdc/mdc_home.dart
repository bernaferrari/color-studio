import 'package:colorstudio/example/blocs/blocs.dart';
import 'package:colorstudio/example/contrast/shuffle_color.dart';
import 'package:colorstudio/example/mdc/showcase.dart';
import 'package:colorstudio/example/screens/home.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:colorstudio/example/vertical_picker/app_bar_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hsluv/hsluvcolor.dart';

class MDCHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MdcSelectedBloc, MdcSelectedState>(
        builder: (context, state) {
      final currentState = (state as MDCLoadedState);

      final allItems = currentState.rgbColorsWithBlindness;

      final Color primaryColor = allItems[kPrimary];
      final Color surfaceColor = allItems[kSurface];
      final Color backgroundColor = allItems[kBackground];
      final HSLuvColor backgroundLuv = currentState.hsluvColors[kBackground];

      final Color onPrimary = primaryColor.computeLuminance() > kLumContrast
          ? Colors.black
          : Colors.white;

      final Color onSurface = surfaceColor.computeLuminance() > kLumContrast
          ? Colors.black
          : Colors.white;

      final isiPad = MediaQuery.of(context).size.shortestSide > 600;

      final scheme = backgroundLuv.lightness > 100 - kLumContrast * 100
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
        child: SafeArea(
          child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              title: Text("Components Preview"),
              actions: <Widget>[
                IconButton(
                  icon: Icon(FeatherIcons.sliders),
                  onPressed: () {
                    Navigator.pushNamed(context, "/colordetails");
                  },
                ),
                IconButton(
                  tooltip: "Random mole theme",
                  icon: Icon(FeatherIcons.penTool),
                  onPressed: () {
                    BlocProvider.of<MdcSelectedBloc>(context).add(
                      MDCUpdateAllEvent(colors: getRandomMoleTheme()),
                    );
                  },
                ),
                IconButton(
                  tooltip: "Random dark theme",
                  icon: Icon(FeatherIcons.moon),
                  onPressed: () {
                    BlocProvider.of<MdcSelectedBloc>(context).add(
                      MDCUpdateAllEvent(colors: getRandomMaterialDark()),
                    );
                  },
                ),
              ],
            ),
            body: isiPad
                ? Center(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Showcase(
                            primaryColor: primaryColor,
                            surfaceColor: surfaceColor,
                            backgroundColor: backgroundColor,
                          ),
                        ),
                        Expanded(
                          child: SingleColorHome(isSplitView: true),
                        ),
                      ],
                    ),
                  )
                : Showcase(
                    primaryColor: primaryColor,
                    surfaceColor: surfaceColor,
                    backgroundColor: backgroundColor,
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
          textStyle: const TextStyle(fontFamily: "B612Mono"),
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
