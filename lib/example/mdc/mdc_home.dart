import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:colorstudio/example/blocs/blocs.dart';
import 'package:colorstudio/example/contrast/inter_color_with_contrast.dart';
import 'package:colorstudio/example/mdc/util/color_blind_from_index.dart';
import 'package:colorstudio/example/mdc/showcase.dart';
import 'package:colorstudio/example/mdc/templates.dart';
import 'package:colorstudio/example/screens/single_color_blindness.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:colorstudio/example/util/selected.dart';

import '../../color_blindness/list.dart';
import 'components.dart';
import 'contrast_compare.dart';

class MDCHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MdcSelectedBloc, MdcSelectedState>(
        builder: (context, state) {
      final selected = (state as MDCLoadedState).selected;
      final pureColors = (state as MDCLoadedState).rgbColors;

      final allItems = (state as MDCLoadedState).rgbColorsWithBlindness;

      final Color primaryColor = allItems[kPrimary];
      final Color surfaceColor = allItems[kSurface];
      final Color backgroundColor =
          surfaceColor; //allItems["Background"].color;

      final contrast = calculateContrast(primaryColor, surfaceColor);

      final base = Theme.of(context);

      final scheme = surfaceColor.computeLuminance() > kLumContrast
          ? ColorScheme.light(
              surface: surfaceColor,
              primary: primaryColor,
              secondary: primaryColor,
            )
          : ColorScheme.dark(
              surface: surfaceColor,
              primary: primaryColor,
              secondary: primaryColor,
            );

      return Theme(
        data: ThemeData.from(colorScheme: scheme).copyWith(
//          colorScheme: base.colorScheme
//              .copyWith(surface: surfaceColor, primary: primaryColor),
          cardColor: surfaceColor,
          cardTheme: base.cardTheme,
          toggleableActiveColor: primaryColor,
          toggleButtonsTheme: ToggleButtonsThemeData(color: scheme.onSurface),
          buttonTheme: base.buttonTheme.copyWith(
            // this is needed for the outline color
            colorScheme: scheme,
          ),
        ),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: surfaceColor,
            appBar: AppBar(),
            body: DefaultTabController(
              length: 5,
              initialIndex: 1,
              child: Column(
                children: <Widget>[
                  TabBar(
                    isScrollable: true,
                    tabs: [
                      const Tab(icon: Text("MDC")),
                      Tab(icon: Icon(FeatherIcons.list)),
                      Tab(
                        icon: Icon(
                          contrast > 4.5
                              ? FeatherIcons.smile
                              : FeatherIcons.frown,
                          // face will only be happy when contrast satisfies AA.
                        ),
                      ),
                      Tab(icon: Icon(FeatherIcons.briefcase)),
                      Tab(icon: Icon(FeatherIcons.globe)),
                      // globe because of accessibility
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Components(
                          primaryColor: primaryColor,
                          surfaceColor: surfaceColor,
                          backgroundColor: backgroundColor,
                        ),
                        Showcase(
                          primaryColor: primaryColor,
                          surfaceColor: surfaceColor,
                          backgroundColor: backgroundColor,
                        ),
                        ContrastComparison(
                          primaryColor: primaryColor,
                          surfaceColor: surfaceColor,
                          backgroundColor: backgroundColor,
                        ),
                        ColorTemplates(
                          primaryColor: primaryColor,
                          surfaceColor: surfaceColor,
                          backgroundColor: backgroundColor,
                        ),
                        ColorBlindnessList(
                          // it should receive them pure, not the colorblind color.
//                          primaryColor: pureColors[kPrimary],
//                          surfaceColor: pureColors[kSurface],
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<ColorBlindBloc, int>(
                      builder: (BuildContext context, int state) {
//                    final ColorWithBlind blindSurface =
//                        getColorBlindFromIndex(surfaceColor, state);

                    final ColorWithBlind blindPrimary =
                        getColorBlindFromIndex(primaryColor, state);

                    return ExpandedSection3(
                      child: state == 0
                          ? const SizedBox.shrink()
                          : Row(
                              children: <Widget>[
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(
                                    FeatherIcons.xCircle,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    BlocProvider.of<ColorBlindBloc>(context)
                                        .add(0);
                                  },
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(blindPrimary.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .body2),
                                      Text(
                                        blindPrimary.affects,
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                    ],
                                  ),
                                ),
//                                SizedBox(
//                                  width: 36,
//                                  height: 36,
//                                  child: Material(
//                                    child: Icon(
//                                      FeatherIcons.target,
//                                      size: 16,
//                                      color: primaryColor,
//                                    ),
//                                    shape: CircleBorder(),
//                                    color: surfaceColor,
//                                  ),
//                                ),
                                SizedBox(
                                  width: 36,
                                  child: FlatButton(
                                    child: Icon(FeatherIcons.chevronLeft),
                                    onPressed: () {
                                      int newState = state - 1;
                                      if (newState <= 0) {
                                        newState = 8;
                                      }
                                      BlocProvider.of<ColorBlindBloc>(context)
                                          .add(newState);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 36,
                                  child: FlatButton(
                                    child: Icon(FeatherIcons.chevronRight),
                                    onPressed: () {
                                      int newState = state + 1;
                                      if (newState > 8) {
                                        newState = 1;
                                      }
                                      BlocProvider.of<ColorBlindBloc>(context)
                                          .add(newState);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                    );
                  }),
                  Container(
                    height: 56,
                    child: Center(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        children: <Widget>[
//                          IconButton(
//                            tooltip: "Shuffle Colors",
//                            icon: Icon(
//                              FeatherIcons.shuffle,
//                              size: 20,
//                            ),
//                            onPressed: () {},
//                          ),
                          for (var key in allItems.keys)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CheckedButton(
                                title: key,
                                color: allItems[key],
                                isSelected: key == selected,
                                onPressed: () {
                                  colorSelected(context, allItems[key]);
                                  BlocProvider.of<MdcSelectedBloc>(context)
                                      .add(MDCLoadEvent(
                                    currentColor: allItems[selected],
//                                    currentTitle: selected,
                                    selected: key,
                                  ));
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
