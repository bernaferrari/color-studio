import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/blocs.dart';
import 'blocs/colors_cubit.dart';
import 'example/screens/about.dart';
import 'example/screens/export_colors.dart';
import 'gradient.dart';
import 'home.dart';
import 'screen_colors_compare/colors_compare_screen.dart';
import 'screen_home/home_screen.dart';
import 'screen_showcase/components_preview.dart';
import 'screen_single_color/screen_single.dart';

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
      theme: Theme.of(context).copyWith(
        // this is needed so iPad and Web work the same way.
        visualDensity: VisualDensity(),
      ),
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
      if (uri.pathSegments[0] == "home2") {
        return ColorRoutePath.to(ScreenPanel.home2);
      }
      if (uri.pathSegments[0] == "colorExport") {
        return ColorRoutePath.to(ScreenPanel.colorExport);
      }
      if (uri.pathSegments[0] == "gradient") {
        return ColorRoutePath.to(ScreenPanel.gradient);
      }
    }

    return ColorRoutePath.home();
  }

  @override
  RouteInformation restoreRouteInformation(ColorRoutePath path) {
    print("restoreRouteInformation path is ${path.panel}");
    switch (path.panel) {
      case ScreenPanel.home:
        return RouteInformation(location: '/');
      case ScreenPanel.home2:
        return RouteInformation(location: '/home2');
      case ScreenPanel.gradient:
        return RouteInformation(location: '/gradient');
      case ScreenPanel.multiColor:
        return RouteInformation(location: '/multiColor');
      case ScreenPanel.settings:
        return RouteInformation(location: '/settings');
      case ScreenPanel.colorExport:
        return RouteInformation(location: '/colorExport');
      case ScreenPanel.singleColor:
        return RouteInformation(location: '/singleColor');
      case ScreenPanel.preview:
        // This should never exist.
        return RouteInformation(location: '/');
    }

    return null;
  }
}

class ColorRouterDelegate extends RouterDelegate<ColorRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<ColorRoutePath> {
  ColorRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  // Default
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
                        child: HomeScreen(
                          toMultiColor: _handleMultiColor,
                          toSingleColor: _handleSingleColor,
                          toSettings: _handleSettings,
                        ),
                      ),
                      if (selectedScreen == ScreenPanel.multiColor)
                        MaterialPage<dynamic>(
                          key: ValueKey("Multiple Color Compare"),
                          child: BlocProvider<MultipleContrastCompareCubit>(
                            create: (context) => MultipleContrastCompareCubit(
                              BlocProvider.of<ColorsCubit>(context),
                            ),
                            child: const ColorsCompareScreen(),
                          ),
                        ),
                      if (selectedScreen == ScreenPanel.singleColor)
                        MaterialPage<dynamic>(
                          key: ValueKey("Single Color"),
                          child: const ScreenSingle(),
                        ),
                      if (selectedScreen == ScreenPanel.settings)
                        MaterialPage<dynamic>(
                          key: ValueKey("About Screen"),
                          child: AboutScreen(
                            toExportPage: toExportPage,
                          ),
                        ),
                      if (selectedScreen == ScreenPanel.colorExport)
                        MaterialPage<dynamic>(
                          key: ValueKey("Color Export Screen"),
                          child: ExportColorsScreen(),
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
                      if (selectedScreen == ScreenPanel.colorExport) {
                        selectedScreen = ScreenPanel.settings;
                      } else {
                        selectedScreen = ScreenPanel.home;
                      }
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
                        key: ValueKey("ComponentsPreview"),
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
        if (selectedScreen == ScreenPanel.home2)
          MaterialPage<dynamic>(
            key: ValueKey("two panels2"),
            child: Home2(),
          ),
        if (selectedScreen == ScreenPanel.gradient)
          MaterialPage<dynamic>(
            key: ValueKey("gradient"),
            child: GradientScreen(),
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

  void toExportPage() {
    selectedScreen = ScreenPanel.colorExport;
    notifyListeners();
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
  home2,
  gradient,
  singleColor,
  colorExport,
  multiColor,
  settings,
  preview,
}

class ColorRoutePath {
  ColorRoutePath.home() : panel = ScreenPanel.home;

  ColorRoutePath.home2() : panel = ScreenPanel.home2;

  ColorRoutePath.settings() : panel = ScreenPanel.home;

  ColorRoutePath.to(this.panel);

  final ScreenPanel panel;

  bool get isHomePage => panel == ScreenPanel.home;

  bool get isHomePage2 => panel == ScreenPanel.home2;

  bool get isGradient => panel == ScreenPanel.gradient;

  bool get isMultiColorPage => panel == ScreenPanel.multiColor;

  bool get isColorExport => panel == ScreenPanel.colorExport;

  bool get isSingleColorPage => panel == ScreenPanel.singleColor;

  bool get isSettingsPage => panel == ScreenPanel.settings;

  bool get isPreviewPage => panel == ScreenPanel.preview;
}
