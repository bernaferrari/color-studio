import 'package:flutter/material.dart';

class ColorStudioApp2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ColorStudioApp2State();
}

class _ColorStudioApp2State extends State<ColorStudioApp2> {
  final ColorRouterDelegate _routerDelegate = ColorRouterDelegate();
  final ColorRouteInformationParser _routeInformationParser =
      ColorRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Color Studio',
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
      if (uri.pathSegments[0] == "multiColor")
        return ColorRoutePath.to(ScreenPanel.multiColor);
      if (uri.pathSegments[0] == "singleColor")
        return ColorRoutePath.to(ScreenPanel.singleColor);
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
      key: navigatorKey,
      pages: [
        MaterialPage<dynamic>(
          key: ValueKey("two panels"),
          child: Row(
            children: [
              Expanded(
                child: ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  child: Navigator(
                    pages: [
                      MaterialPage<dynamic>(
                        key: ValueKey("Scheme/Contrast/Blind"),
                        child: Scaffold(
                          body: Center(
                            child: ElevatedButton(
                              child: Text("Next Page 1"),
                              onPressed: _handleMultiColor,
                            ),
                          ),
                        ),
                      ),
                      if (selectedScreen == ScreenPanel.multiColor)
                        MaterialPage<dynamic>(
                          key: ValueKey("Multiple Color Compare"),
                          child: Scaffold(
                            appBar: AppBar(),
                            body: Center(
                              child: Text("Page 2"),
                            ),
                          ),
                        ),
                    ],
                    onPopPage: (route, dynamic result) {
                      print("POP1");
                      if (!route.didPop(result)) {
                        return false;
                      }

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
                      // BookDetailsPage(_handleSingleColor, key: "aaaa"),
                      MaterialPage<dynamic>(
                        key: ValueKey("Scheme/Contrast/Blind"),
                        child: Center(
                          child: ElevatedButton(
                            child: Text("Next Page 2"),
                            onPressed: _handleSingleColor,
                          ),
                        ),
                      ),
                      if (selectedScreen == ScreenPanel.singleColor)
                        // BookDetailsPage(() {}, key: "page 3"),
                      MaterialPage<dynamic>(
                        key: ValueKey("Multiple Color Compare"),
                        child: Scaffold(
                          appBar: AppBar(),
                          body: Center(
                            child: Text("Page 3"),
                          ),
                        ),
                      ),
                    ],
                    onPopPage: (route, dynamic result) {
                      print("POP 2");
                      if (!route.didPop(result)) {
                        return false;
                      }

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
  }

  void _handleMultiColor() {
    selectedScreen = ScreenPanel.multiColor;
    notifyListeners();
  }

  void _handleSingleColor() {
    selectedScreen = ScreenPanel.singleColor;
    notifyListeners();
  }
}

enum ScreenPanel {
  home,
  singleColor,
  multiColor,
}

class BookDetailsPage extends Page<dynamic> {
  BookDetailsPage(this.onPressed, {String key}) : super(key: ValueKey(key));

  final Function onPressed;

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder<dynamic>(
      settings: this,
      transitionDuration: Duration(seconds: 1),
      pageBuilder: (context, animation, animation2) {
        print("animation is ${animation} ${animation2}");
        final tween = Tween(begin: Offset(0, 1.0), end: Offset.zero);
        final curveTween = CurveTween(curve: Curves.linear);
        return SlideTransition(
          position: animation.drive(curveTween).drive(tween),
          child: Scaffold(
            appBar: AppBar(),
            body: Center(
              child: ElevatedButton(
                child: Text("Next Page 2"),
                onPressed: onPressed,
              ),
            ),
          ),
        );
      },
    );
  }
}

class ColorRoutePath {
  ColorRoutePath.home() : panel = ScreenPanel.home;

  ColorRoutePath.settings() : panel = ScreenPanel.home;

  ColorRoutePath.to(this.panel);

  final ScreenPanel panel;

  bool get isHomePage => panel == ScreenPanel.home;

  bool get isMultiColorPage => panel == ScreenPanel.multiColor;

  bool get isSingleColorPage => panel == ScreenPanel.singleColor;
}
