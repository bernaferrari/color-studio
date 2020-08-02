import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../contrast/inter_color_with_contrast.dart';
import '../contrast/shuffle_color.dart';
import '../mdc/util/elevation_overlay.dart';
import '../util/color_util.dart';
import '../util/constants.dart';
import '../util/selected.dart';
import '../widgets/color_sliders/slider_that_works.dart';

class Components extends StatelessWidget {
  const Components(
      {this.primaryColor, this.surfaceColor, this.backgroundColor});

  final Color primaryColor;
  final Color surfaceColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final primaryContrastingColor = contrastingColor(primaryColor);
//    final surfaceContrastingColor = contrastingColor(surfaceColor);
//    final double itemWidth = MediaQuery.of(context).size.width / 2;
//    final bgFromPrimary = blendColorWithBackground(primaryColor);

    return Container(
      color: surfaceColor,
      child: Center(
        child: ListView(
          shrinkWrap: true,
          key: const PageStorageKey("mdc"),
          children: <Widget>[
            Padding(padding: EdgeInsets.all(4)),
            Text(
              "Material Components",
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            ComponentsSample(
              primaryColor: primaryColor,
              surfaceColor: surfaceColor,
              contrastColor: primaryContrastingColor,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
              child: Text(
                "surface/elevation",
                textAlign: TextAlign.center,
                style: GoogleFonts.b612Mono(),
              ),
            ),
            NavigationBarSample(
              primaryColor,
              compositeColors(
                Colors.white,
                surfaceColor,
                0.12,
              ),
            ),
            LayoutBuilder(builder: (context, builder) {
              final numOfItems = (builder.maxWidth / 80).floor();

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  children: <Widget>[
                    for (int i = 0; i < elevationEntriesList.length; i++)
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SizedBox(
                          width: builder.maxWidth / numOfItems - 12,
                          height: 56,
                          child: ElevatedCardSample(
                            elevationEntries[i],
                            primaryColor,
                            surfaceColor,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
//          Padding(
//            padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
//            sliver: SliverGrid(
//              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                mainAxisSpacing: 8.0,
//                crossAxisSpacing: 8.0,
//                crossAxisCount: (itemWidth > 300) ? 5 : 3,
//                childAspectRatio:
//                (itemWidth > 300) ? itemWidth / 300 : itemWidth / 120,
//              ),
//              delegate: SliverChildBuilderDelegate(
//                    (BuildContext context, int index) {
//                  return ElevatedCardSample(
//                    elevationEntries[index],
//                    primaryColor,
//                    surfaceColor,
//                  );
//                },
//                childCount: elevationEntriesList.length,
//              ),
//            ),
//          ),
//          const Padding(
//            padding: const EdgeInsets.only(top: 24.0),
//            child: Text(
//              "background",
//              textAlign: TextAlign.center,
//              style: TextStyle(fontFamily: "B612Mono"),
//            ),
//          ),
//          Padding(
//            padding: const EdgeInsets.all(16.0),
//            child: MaterialButton(
//              elevation: 0,
//              shape: RoundedRectangleBorder(
//                  side: BorderSide(color: Colors.white24),
//                  borderRadius: BorderRadius.circular(8)),
//              color: bgFromPrimary,
//              child: ListTile(
//                title: Text(
//                  "Recommended Background",
//                  style: TextStyle(color: Colors.white),
//                ),
//                subtitle: Text(
//                  "${bgFromPrimary.toHexStr()} = 8% of Primary + #121212",
//                  style: TextStyle(
//                      fontSize: 12, color: Colors.white.withOpacity(0.8)),
//                ),
//                trailing: Icon(FeatherIcons.chevronRight, color: Colors.white),
//              ),
//              onPressed: () {
//                colorSelected(context, bgFromPrimary);
//              },
//            ),
//          ),
//          const Padding(
//            padding: EdgeInsets.only(top: 8.0),
//            child: Text(
//              "out of creativity?",
//              textAlign: TextAlign.center,
//              style: TextStyle(fontFamily: "B612Mono"),
//            ),
//          ),
//          Padding(
//            padding: const EdgeInsets.all(16.0),
//            child: OutlineButton(
//              child: ListTile(
//                title: Text("Generate a Random Theme"),
//                trailing: Icon(FeatherIcons.chevronRight),
//              ),
//              onPressed: () async {
//                Color primary = Colors.black;
//                Color surface;
//
//                while (primary == Colors.black) {
//                  // generates a pseudo-random list
//                  List<String> randomList = getColorsListShuffled();
//                  surface = findDarkMatchingPair(randomList);
//                  primary = findMatchingPair(randomList, surface, 5.5);
//                }
//
////                BlocProvider.of<MdcSelectedBloc>(context).add(MDCUpdateAllEvent(
////                  primaryColor: primary,
////                  surfaceColor: surface,
////                  selectedTitle: kPrimary,
////                ));
//                colorSelected(context, primary);
//              },
//            ),
//          ),
//          Row(
//            children: <Widget>[
//              SizedBox(width: 16),
//              Expanded(
//                child: OutlineButton(
//                  padding: EdgeInsets.all(16),
//                  child: Text("Random Primary"),
//                  onPressed: () async {
//                    // generates a pseudo-random list
//                    final randomList = getColorsListShuffled();
//
//                    final surface = (BlocProvider.of<MdcSelectedBloc>(context)
//                            .state as MDCLoadedState)
//                        .rgbColorsWithBlindness[kSurface];
//                    final newPrimaryColor =
//                        findMatchingPair(randomList, surface, 4.5);
//
////                    BlocProvider.of<MdcSelectedBloc>(context)
////                        .add(MDCUpdateAllEvent(
////                      primaryColor: newPrimaryColor,
////                      surfaceColor: surface,
////                      selectedTitle: kPrimary,
////                    ));
//
//                    colorSelected(context, newPrimaryColor);
//                  },
//                ),
//              ),
//              SizedBox(width: 16),
//              Expanded(
//                child: OutlineButton(
//                  padding: EdgeInsets.all(16),
//                  child: Text("Random Surface"),
//                  onPressed: () async {
//                    // generates a pseudo-random list
//                    final randomList = getColorsListShuffled();
//
//                    final primary = (BlocProvider.of<MdcSelectedBloc>(context)
//                            .state as MDCLoadedState)
//                        .rgbColorsWithBlindness[kPrimary];
//
//                    final newSurfaceColor =
//                        findMatchingPair(randomList, primary, 4.5);
//
////                    BlocProvider.of<MdcSelectedBloc>(context)
////                        .add(MDCUpdateAllEvent(
////                      primaryColor: primary,
////                      surfaceColor: newSurfaceColor,
////                      selectedTitle: kSurface,
////                    ));
//                    colorSelected(context, newSurfaceColor);
//                  },
//                ),
//              ),
//              const SizedBox(width: 16),
//            ],
//          ),
            const Padding(padding: EdgeInsets.all(8)),
          ],
        ),
      ),
    );
  }

  List<String> getColorsListShuffled() {
    return [...colorClaim, ...materialColors]
      ..removeWhere((item) => item == "000000" || item == "FFFFFF")
      ..shuffle();
  }

  Color findMatchingPair(List<String> list, Color firstColor, double thresh) {
    for (int i = 0; i < list.length; i++) {
      final color = Color(int.parse("0xFF${list[i]}"));
      final contrast = calculateContrast(firstColor, color);
      if (contrast > thresh) {
        return color;
      }
    }
    // this ideally shouldn't ever happen
    return Colors.black;
  }

  Color findDarkMatchingPair(List<String> list) {
    for (int i = 0; i < list.length; i++) {
      final color = Color(int.parse("0xFF${list[i]}"));
      final contrast = calculateContrast(Colors.black, color);
      if (contrast < 4.0) {
        return color;
      }
    }
    // this ideally shouldn't ever happen
    return Colors.black;
  }
}

class ElevatedCardSample extends StatelessWidget {
  const ElevatedCardSample(this.entry, this.primary, this.color);

  final ElevationOverlay2 entry;
  final Color color;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final colorWithElevation = compositeColors(
      Colors.white, // onSurface
      color,
      entry.overlay,
    );

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(surface: color),
      ),
      child: RaisedButton(
        color: color,
        elevation: entry.elevation.toDouble(),
        onPressed: () {
          colorSelected(context, colorWithElevation);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "${entry.elevation.toInt()} pt",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: primary),
            ),
            SizedBox(height: 4),
            Text(
              "${colorWithElevation.toHexStr()}",
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: primary.withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationBarSample extends StatefulWidget {
  const NavigationBarSample(this.color, [this.bgColor]);

  final Color color;
  final Color bgColor;

  @override
  _NavigationBarSampleState createState() => _NavigationBarSampleState();
}

class _NavigationBarSampleState extends State<NavigationBarSample> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      removeBottom: true,
      context: context,
      child: BottomNavigationBar(
        selectedItemColor: widget.color,
        backgroundColor: widget.bgColor,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
        ),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FeatherIcons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FeatherIcons.archive),
            title: Text('Archive'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FeatherIcons.settings),
            title: Text('Settings'),
          ),
        ],
        onTap: (updatedIndex) {
          setState(() {
            _selectedIndex = updatedIndex;
          });
        },
        currentIndex: _selectedIndex,
      ),
    );
  }
}

class ComponentsSample extends StatefulWidget {
  const ComponentsSample(
      {this.primaryColor, this.contrastColor, this.surfaceColor});

  final Color primaryColor;
  final Color surfaceColor;
  final Color contrastColor;

  @override
  _ComponentsSampleState createState() => _ComponentsSampleState();
}

class _ComponentsSampleState extends State<ComponentsSample> {
  double _sliderValue = 0.5;
  bool isSwitchEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Slider2(
              value: _sliderValue,
              onChanged: (newRating) {
                setState(() => _sliderValue = newRating);
              },
            ),
            Switch(
              value: isSwitchEnabled,
              onChanged: (switchEnabled) {
                setState(() {
                  isSwitchEnabled = switchEnabled;
                });
              },
            ),
            Checkbox(
              checkColor: widget.contrastColor,
              value: isSwitchEnabled,
              onChanged: (switchEnabled) {
                setState(() {
                  isSwitchEnabled = switchEnabled;
                });
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        Row(
          children: <Widget>[
            const SizedBox(width: 16),
            Expanded(
              child: RaisedButton.icon(
                label: Text("Sun"),
                icon: Icon(FeatherIcons.sun, size: 16),
                color: widget.primaryColor,
                textColor: widget.surfaceColor,
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlineButton.icon(
                icon: Icon(
                  FeatherIcons.hexagon,
                  size: 16,
                ),
                label: Text("Hex", overflow: TextOverflow.ellipsis),
                textColor: widget.primaryColor,
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: RaisedButton.icon(
                label: Text("Moon"),
                icon: Icon(FeatherIcons.shuffle, size: 16),
                color: widget.primaryColor,
                textColor: contrastingColor(widget.primaryColor),
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ],
    );
  }
}

class SliderWithSelectorComponents extends StatefulWidget {
  const SliderWithSelectorComponents(this.rgb, this.hsv, this.hsl,
      {this.initiallyExpanded = true});

  final Widget rgb;
  final Widget hsv;
  final Widget hsl;
  final bool initiallyExpanded;

  @override
  _SliderWithSelectorComponentsState createState() =>
      _SliderWithSelectorComponentsState();
}

class _SliderWithSelectorComponentsState
    extends State<SliderWithSelectorComponents> {
  List<bool> isSelected = [true, false, false];
  bool _isExpanded;

  @override
  void initState() {
    _isExpanded = PageStorage.of(context)
            .readState(context, identifier: const ValueKey("expanded")) ??
        widget.initiallyExpanded;

    final List<bool> wasSelected = PageStorage.of(context)
        .readState(context, identifier: const ValueKey("PWSS"));

    if (wasSelected != null) {
      isSelected = wasSelected;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: ExpandedSection3(
        child: _isExpanded
            ? Stack(
                children: <Widget>[
                  Positioned.directional(
                    top: 0,
                    end: 0,
                    textDirection: TextDirection.ltr,
                    child: IconButton(
                      icon: Icon(FeatherIcons.chevronDown),
                      tooltip: "Minimize",
                      onPressed: () {
                        setState(() {
                          _isExpanded = false;
                          PageStorage.of(context).writeState(
                            context,
                            _isExpanded,
                            identifier: const ValueKey("expanded"),
                          );
                        });
                      },
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 818),
                    child: Column(
                      children: <Widget>[
                        ToggleButtons(
                          textStyle: GoogleFonts.b612Mono(),
                          children: const <Widget>[
                            Text("RGB"),
                            Text("HSV"),
                            Text("HSL"),
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
                              PageStorage.of(context).writeState(
                                  context, isSelected,
                                  identifier: const ValueKey("PWSS"));
                            });
                          },
                          isSelected: isSelected,
                        ),
                        Padding(
                          // this is the right padding, so text don't get glued to the border.
                          padding: const EdgeInsets.only(right: 8),
                          child: isSelected[0]
                              ? widget.rgb
                              : isSelected[1] ? widget.hsl : widget.hsv,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : SizedBox(
                width: 818,
                child: FlatButton.icon(
                  label: const Text("Expand"),
                  padding: EdgeInsets.zero,
                  icon: Icon(FeatherIcons.chevronUp),
                  onPressed: () {
                    setState(() {
                      _isExpanded = true;
                      PageStorage.of(context).writeState(
                        context,
                        _isExpanded,
                        identifier: const ValueKey("expanded"),
                      );
                    });
                  },
                ),
              ),
      ),
    );
  }
}

class ExpandedSection3 extends StatefulWidget {
  const ExpandedSection3({this.child});

  final Widget child;

  @override
  _ExpandedSection3State createState() => _ExpandedSection3State();
}

class _ExpandedSection3State extends State<ExpandedSection3>
    with SingleTickerProviderStateMixin {
  final GlobalKey _expandingBottomSheetKey =
      GlobalKey(debugLabel: 'Expanding bottom sheet');

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      key: _expandingBottomSheetKey,
      vsync: this,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
      alignment: FractionalOffset.topLeft,
      child: widget.child,
    );
  }
}

Color contrastingColor(Color color) {
  return (color.computeLuminance() > kLumContrast)
      ? Colors.black
      : Colors.white;
}
