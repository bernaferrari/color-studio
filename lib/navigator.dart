import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'blocs/blocs.dart';
import 'colors_compare/colors_compare_screen.dart';
import 'example/mdc/components_preview.dart';
import 'screen_home/color_blindness/card.dart';
import 'screen_home/contrast_ratio/card.dart';
import 'screen_home/scheme/card.dart';

class ColorStudioApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ColorStudioAppState();
}

class _ColorStudioAppState extends State<ColorStudioApp> {
  final ColorRouterDelegate _routerDelegate = ColorRouterDelegate();
  final ColorRouteInformationParser _routeInformationParser =
      ColorRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Color Studio',
      theme: Theme.of(context),
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }
}

class ColorRouteInformationParser
    extends RouteInformationParser<ColorRoutePath> {
  @override
  Future<ColorRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);

    if (uri.pathSegments.length == 1) {
      if (uri.pathSegments[0] == "settings") return ColorRoutePath.settings();
      if (uri.pathSegments[0] == "multiColor") {
        return ColorRoutePath.to(ScreenPanel.multiColor);
      }
      if (uri.pathSegments[0] == "singleColor") {
        return ColorRoutePath.to(ScreenPanel.singleColor);
      }
      if (uri.pathSegments[0] == "preview") {
        return ColorRoutePath.to(ScreenPanel.preview);
      }
    }

    return ColorRoutePath.home();
  }

  @override
  RouteInformation restoreRouteInformation(ColorRoutePath path) {
    print("restoreRouteInformation path is ${path.panel}");
    if (path.isHomePage) {
      return RouteInformation(location: '/');
    }
    if (path.isMultiColorPage) {
      return RouteInformation(location: '/multiColor');
    }
    if (path.isSettingsPage) {
      return RouteInformation(location: '/multiColor');
    }
    if (path.isSingleColorPage) {
      return RouteInformation(location: '/singleColor');
    }
    return null;
  }
}

class ColorRouterDelegate extends RouterDelegate<ColorRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<ColorRoutePath> {
  ColorRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  ScreenPanel selectedScreen = ScreenPanel.home;

  @override
  ColorRoutePath get currentConfiguration {
    return ColorRoutePath.to(selectedScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: [
        MaterialPage<dynamic>(
          key: ValueKey("two panels"),
          child: Row(
            children: [
              Expanded(
                child: ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  child: Navigator(
                    key: navigatorKey,
                    pages: [
                      MaterialPage<dynamic>(
                        key: ValueKey("Scheme/Contrast/Blind"),
                        child: HomeScreen(_handleMultiColor),
                      ),
                      if (selectedScreen == ScreenPanel.multiColor)
                        MaterialPage<dynamic>(
                          key: ValueKey("Multiple Color Compare"),
                          child: BlocProvider<MultipleContrastCompareCubit>(
                            create: (context) => MultipleContrastCompareCubit(
                              BlocProvider.of<MdcSelectedBloc>(context),
                            ),
                            child: const ColorsCompareScreen(),
                          ),
                        ),
                    ],
                    onPopPage: (route, dynamic result) {
                      print("POP1 ");
                      if (!route.didPop(result)) {
                        return false;
                      }

                      // Update the list of pages by setting _selectedBook to null
                      // _selectedBook = null;
                      // show404 = false;
                      selectedScreen = ScreenPanel.home;
                      notifyListeners();

                      return true;
                    },
                  ),
                ),
              ),
              Expanded(
                child: ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  child: Navigator(
                    pages: [
                      MaterialPage<dynamic>(
                        key: ValueKey("Scheme/Contrast/Blind2"),
                        child: ComponentsPreview(),
                      ),
                    ],
                    onPopPage: (route, dynamic result) {
                      print("Pop3 ");
                      if (!route.didPop(result)) {
                        return false;
                      }

                      // Update the list of pages by setting _selectedBook to null
                      // _selectedBook = null;
                      // show404 = false;
                      selectedScreen = ScreenPanel.home;
                      notifyListeners();

                      return true;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      onPopPage: (route, dynamic result) {
        print("POP2 ");

        if (!route.didPop(result)) {
          return false;
        }

        // Update the list of pages by setting _selectedBook to null
        // _selectedBook = null;
        // show404 = false;
        selectedScreen = ScreenPanel.home;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(ColorRoutePath path) async {
    print("setNewRoutePath is ${path.panel}");
    selectedScreen = path.panel;
    return;
    // if (path.isUnknown) {
    //   _selectedBook = null;
    //   show404 = true;
    //   return;
    // }
    //
    // if (path.isDetailsPage) {
    //   if (path.id < 0 || path.id > books.length - 1) {
    //     show404 = true;
    //     return;
    //   }
    //
    //   _selectedBook = books[path.id];
    // } else {
    //   _selectedBook = null;
    // }
    //
    // show404 = false;
  }

  void _handleMultiColor() {
    selectedScreen = ScreenPanel.multiColor;
    notifyListeners();
  }

  void _handleSingleColor() {
    selectedScreen = ScreenPanel.singleColor;
    notifyListeners();
  }

  void _handleSettings() {
    selectedScreen = ScreenPanel.settings;
    notifyListeners();
  }

  void _handlePreview() {
    selectedScreen = ScreenPanel.preview;
    notifyListeners();
  }
}

enum ScreenPanel {
  home,
  singleColor,
  multiColor,
  settings,
  preview,
}

class ColorRoutePath {
  ColorRoutePath.home() : panel = ScreenPanel.home;

  ColorRoutePath.settings() : panel = ScreenPanel.home;

  ColorRoutePath.to(this.panel);

  final ScreenPanel panel;

  bool get isHomePage => panel == ScreenPanel.home;

  bool get isMultiColorPage => panel == ScreenPanel.multiColor;

  bool get isSingleColorPage => panel == ScreenPanel.singleColor;

  bool get isSettingsPage => panel == ScreenPanel.settings;

  bool get isPreviewPage => panel == ScreenPanel.preview;
}

class HomeScreen extends StatelessWidget {
  const HomeScreen(this._handleMultiColor);

  final VoidCallback _handleMultiColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<MdcSelectedBloc, MdcSelectedState>(
                builder: (context, state) {
              if (state is MDCInitialState) {
                return SizedBox.shrink();
              }

              final currentState = state as MDCLoadedState;

              return Column(
                children: [
                  schemeContrast(
                    context,
                    Theme.of(context).colorScheme,
                    currentState,
                    null,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 600),
                    child: ColorBlindnessCard(
                      currentState.rgbColors,
                      currentState.locked,
                    ),
                  )
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget schemeContrast(
    BuildContext context,
    ColorScheme colorScheme,
    MDCLoadedState currentState,
    bool shouldDisplayElevation,
  ) {
    final bool isiPad = MediaQuery.of(context).size.width > 600;

    return Column(
      children: <Widget>[
        SizedBox(height: 4),
        Row(
          children: <Widget>[
            if (isiPad) SizedBox(width: 24) else SizedBox(width: 16),
            if (!isiPad) ...[
              Expanded(
                child: RaisedButton.icon(
                  label: Text("Modify"),
                  icon: Icon(FeatherIcons.sliders, size: 16),
                  textColor: colorScheme.onSurface,
                  color: colorScheme.surface,
                  onPressed: () {
                    Navigator.pushNamed(context, "/colordetails");
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: colorScheme.onSurface.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
            // Expanded(
            //   child: RaisedButton.icon(
            //     label: Text("Preview"),
            //     icon: Icon(FeatherIcons.layout, size: 16),
            //     textColor: colorScheme.onSurface,
            //     color: colorScheme.surface,
            //     onPressed: () {
            //       Navigator.pushNamed(context, "/componentspreview");
            //     },
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(16),
            //       side: BorderSide(
            //         color: colorScheme.onSurface.withOpacity(0.30),
            //       ),
            //     ),
            //   ),
            // ),
            if (isiPad) const SizedBox(width: 8) else const SizedBox(width: 16),
          ],
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: ColorSchemeCard(
            rgbColors: currentState.rgbColors,
            rgbColorsWithBlindness: currentState.rgbColorsWithBlindness,
            hsluvColors: currentState.hsluvColors,
            locked: currentState.locked,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.compare_arrows,
                    size: 36,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Compare\nColors",
                    // textAlign: TextAlign.center,
                  ),
                ],
              ),
              onPressed: _handleMultiColor,
            ),
            SizedBox(width: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  Icon(Icons.settings),
                  Text("Settings"),
                ],
              ),
              onPressed: () {},
            ),
            SizedBox(width: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  )),
              child: Column(
                children: [
                  Icon(Icons.settings),
                  Text("Settings"),
                ],
              ),
              onPressed: () {},
            ),
          ],
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: ContrastRatioCard(
            currentState.rgbColorsWithBlindness,
            _handleMultiColor,
          ),
        ),
      ],
    );
  }
}
