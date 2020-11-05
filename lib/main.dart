import 'package:bloc/bloc.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'example/blocs/blocs.dart';
import 'example/blocs/color_blind/color_blindness_cubit.dart';
import 'example/blocs/mdc_selected/mdc_selected_bloc.dart';
import 'example/contrast/shuffle_color.dart';
import 'navigator.dart';

Future<void> main() async {
  // this is needed so Hive can be initialised synchronously.
  // when the app runs, Hive should have a value already.
  // WidgetsFlutterBinding.ensureInitialized();
  // await openBox();
  Bloc.observer = SimpleBlocObserver();
  runApp(BoxedApp());
}

Future openBox() async {
  if (!kIsWeb) {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  return await Hive.openBox<dynamic>("settings");
}

class BoxedApp extends StatefulWidget {
  @override
  _BoxedAppState createState() => _BoxedAppState();
}

class _BoxedAppState extends State<BoxedApp> {
  ColorBlindnessCubit colorBlindBloc;
  MdcSelectedBloc _mdcSelectedBloc;

  @override
  void initState() {
    super.initState();
    colorBlindBloc = ColorBlindnessCubit();
    _mdcSelectedBloc = MdcSelectedBloc(colorBlindBloc)
      ..add(MDCInitEvent(getRandomMaterialDark()));
  }

  @override
  void dispose() {
    super.dispose();
    colorBlindBloc.close();
    _mdcSelectedBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MdcSelectedBloc>(
          create: (context) => _mdcSelectedBloc,
        ),
        BlocProvider<ContrastRatioCubit>(
          create: (context) => ContrastRatioCubit(_mdcSelectedBloc),
        ),
        BlocProvider<ColorBlindnessCubit>(
          create: (context) => colorBlindBloc,
        )
      ],
      child: BlocBuilder<MdcSelectedBloc, MdcSelectedState>(
          builder: (context, state) {
        if (state is MDCInitialState) {
          return SizedBox.shrink();
        }

        final currentState = state as MDCLoadedState;

        final primary =
            currentState.rgbColorsWithBlindness[ColorType.Primary];
        final secondary =
            currentState.rgbColorsWithBlindness[ColorType.Secondary];
        final background =
            currentState.rgbColorsWithBlindness[ColorType.Background];
        final surface =
            currentState.rgbColorsWithBlindness[ColorType.Surface];

        final isLightSurface =
            currentState.hsluvColors[ColorType.Surface].lightness >=
                kLightnessThreshold;

        final onSurface = isLightSurface ? Colors.black : Colors.white;

        final onBackground =
            currentState.hsluvColors[ColorType.Background].lightness <
                    kLightnessThreshold
                ? Colors.white
                : Colors.black;

        final colorScheme = isLightSurface
            ? ColorScheme.light(
                primary: primary,
                secondary: secondary,
                background: background,
                onBackground: onBackground,
                surface: surface,
                onSurface: onSurface,
              )
            : ColorScheme.dark(
                primary: primary,
                secondary: secondary,
                background: background,
                onBackground: onBackground,
                surface: surface,
                onSurface: onSurface,
              );

        return Theme(
          data: ThemeData.from(
            colorScheme: colorScheme,
            textTheme: TextTheme(
              headline6: GoogleFonts.openSans(fontWeight: FontWeight.w700),
              subtitle1: GoogleFonts.openSans(fontWeight: FontWeight.w700),
              subtitle2: GoogleFonts.openSans(fontWeight: FontWeight.w400),
              bodyText2: GoogleFonts.lato(),
              caption: GoogleFonts.b612Mono(),
            ),
          ).copyWith(
            cardTheme: CardTheme(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: colorScheme.onSurface.withOpacity(0.30),
                  width: 1,
                ),
              ),
              elevation: 0,
              margin: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
            ),
          ),
          child: ColorStudioApp(),
        );
      }),
      // MaterialApp(
      //   routes: {
      //     "/": (context) {
      //       return Home();
      //     },
      //     "/colordetails": (context) {
      //       updateStateIfNecessary();
      //       return SingleColorHome();
      //     },
      //     "/componentspreview": (context) {
      //       // necessary if it opens in split-view
      //       updateStateIfNecessary();
      //       return ComponentsPreview();
      //     },
      //     "/export": (context) => ExportColors(),
      //   },
      //   theme: ThemeData(
      //     typography: Typography.material2018().copyWith(
      //       black: Typography.dense2018,
      //       tall: Typography.tall2018,
      //       englishLike: Typography.englishLike2018,
      //     ),
      //     dialogTheme: DialogTheme(
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(defaultRadius),
      //       ),
      //     ),
      //     buttonTheme: ButtonThemeData(
      //       padding: EdgeInsets.zero,
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(defaultRadius / 2),
      //       ),
      //     ),
      //     cardTheme: CardTheme(
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(defaultRadius),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

// void updateStateIfNecessary() {
//   final currentState = _mdcSelectedBloc.state as MDCLoadedState;
//
//   if (currentState.locked[currentState.selected] == true) {
//     _mdcSelectedBloc.add(
//       MDCLoadEvent(
//         currentColor: currentState.rgbColors[kPrimary],
//         selected: kPrimary,
//       ),
//     );
//   }
// }
}
