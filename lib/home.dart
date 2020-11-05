// import 'package:colorstudio/color_blindness/card.dart';
// import 'package:colorstudio/contrast_ratio/card.dart';
// import 'package:colorstudio/scheme/card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'contrast/contrast_screen.dart';
// import 'example/blocs/blocs.dart';
// import 'example/util/constants.dart';

// class Home extends StatelessWidget {
//   const Home();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<MdcSelectedBloc, MdcSelectedState>(
//         builder: (context, state) {
//       if (!(state is MDCLoadedState)) {
//         return SizedBox.shrink();
//       }

//       final currentState = state as MDCLoadedState;

//       final primary = currentState.rgbColorsWithBlindness[ColorType.Primary];
//       final secondary =
//           currentState.rgbColorsWithBlindness[ColorType.Secondary];
//       final background =
//           currentState.rgbColorsWithBlindness[ColorType.Background];
//       final surface = currentState.rgbColorsWithBlindness[ColorType.Surface];

//       final isLightSurface =
//           currentState.hsluvColors[ColorType.Surface].lightness >=
//               kLightnessThreshold;

//       final onSurface = isLightSurface ? Colors.black : Colors.white;

//       final colorScheme = isLightSurface
//           ? ColorScheme.light(
//               primary: primary,
//               secondary: secondary,
//               background: background,
//               surface: surface,
//               onSurface: onSurface,
//             )
//           : ColorScheme.dark(
//               primary: primary,
//               secondary: secondary,
//               background: background,
//               surface: surface,
//               onSurface: onSurface,
//             );

//       // this should be faster than rgbColors[kSurface].computeLuminance < kLumContrast
//       // final bool shouldDisplayElevation = !isLightSurface;
//       final bool shouldDisplayElevation = null;

//       final isiPad = MediaQuery.of(context).size.width > 600;

//       return Theme(
//         data: ThemeData.from(
//           // todo it would be nice if there were a ThemeData.join
//           // because you need to copyWith manually everything every time.
//           colorScheme: colorScheme,
//           textTheme: TextTheme(
//             bodyText2: GoogleFonts.lato(),
//             button: GoogleFonts.openSans(),
//             // headline6: GoogleFonts.openSans(
//             //   fontSize: 16,
//             //   fontWeight: FontWeight.w700,
//             // ),
//             headline6: GoogleFonts.openSans(
//               fontWeight: FontWeight.w700,
//             ),
//             caption: GoogleFonts.b612Mono(),
//           ),
//         ).copyWith(
//           // buttonTheme: ButtonThemeData(
//           //   shape: RoundedRectangleBorder(
//           //     borderRadius: BorderRadius.circular(16),
//           //   ),
//           // ),
//           // dividerColor: onSurface.withOpacity(0.30),
//           cardTheme: CardTheme(
//             clipBehavior: Clip.antiAlias,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//               side: BorderSide(
//                 color: colorScheme.onSurface.withOpacity(0.30),
//                 width: 1,
//               ),
//             ),
//             elevation: 0,
//             margin: EdgeInsets.symmetric(
//               horizontal: 16.0,
//               vertical: 8.0,
//             ),
//           ),
//         ),
//         child: Scaffold(
//           body: isiPad
//               ? NavigatorTwoPanels()
//               : ListView(
//                   children: <Widget>[
//                     schemeContrast(
//                       context,
//                       colorScheme,
//                       currentState,
//                       shouldDisplayElevation,
//                     ),
//                     ConstrainedBox(
//                       constraints: BoxConstraints(maxWidth: 400),
//                       child: ColorBlindnessCard(
//                         currentState.rgbColors,
//                         currentState.locked,
//                       ),
//                     ),
//                   ],
//                 ),
//         ),
//       );
//     });
//   }

//   Widget schemeContrast(
//     BuildContext context,
//     ColorScheme colorScheme,
//     MDCLoadedState currentState,
//     bool shouldDisplayElevation,
//   ) {
//     final isiPad = MediaQuery.of(context).size.width > 600;

//     return Column(
//       children: <Widget>[
//         SizedBox(height: 4),
//         Row(
//           children: <Widget>[
//             if (isiPad) SizedBox(width: 24) else SizedBox(width: 16),
//             if (!isiPad) ...[
//               Expanded(
//                 child: RaisedButton.icon(
//                   label: Text("Modify"),
//                   icon: Icon(FeatherIcons.sliders, size: 16),
//                   textColor: colorScheme.onSurface,
//                   color: colorScheme.surface,
//                   onPressed: () {
//                     Navigator.pushNamed(context, "/colordetails");
//                   },
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                     side: BorderSide(
//                       color: colorScheme.onSurface.withOpacity(0.3),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//             ],
//             Expanded(
//               child: ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                     side: BorderSide(
//                       color: colorScheme.onSurface.withOpacity(0.30),
//                     ),
//                   ),
//                 ),
//                 label: Text("Preview"),
//                 icon: Icon(FeatherIcons.layout, size: 16),
//                 onPressed: () {
//                   Navigator.pushNamed(context, "/componentspreview");
//                 },
//               ),
//             ),
//             if (isiPad) const SizedBox(width: 8) else const SizedBox(width: 16),
//           ],
//         ),
//         ColorSchemeCard(
//           rgbColors: currentState.rgbColors,
//           rgbColorsWithBlindness: currentState.rgbColorsWithBlindness,
//           hsluvColors: currentState.hsluvColors,
//           locked: currentState.locked,
//         ),
//         ContrastRatioCard(
//           currentState.rgbColorsWithBlindness,
//           shouldDisplayElevation,
//           currentState.locked,
//           () {},
//         ),
//       ],
//     );
//   }
// }

// class NavigatorTwoPanels extends StatefulWidget {
//   @override
//   _NavigatorTwoPanelsState createState() => _NavigatorTwoPanelsState();
// }

// class _NavigatorTwoPanelsState extends State<NavigatorTwoPanels> {
//   bool isMultiSelected = false;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: Navigator(
//             pages: [
//               MaterialPage<dynamic>(
//                 key: ValueKey("Scheme/Contrast/Blind"),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       BlocBuilder<MdcSelectedBloc, MdcSelectedState>(
//                           builder: (context, state) {
//                         final currentState = state as MDCLoadedState;

//                         if (!(state is MDCLoadedState)) {
//                           return SizedBox.shrink();
//                         }
//                         return Column(
//                           children: [
//                             schemeContrast(
//                               context,
//                               Theme.of(context).colorScheme,
//                               currentState,
//                               null,
//                             ),
//                             ConstrainedBox(
//                               constraints: BoxConstraints(maxWidth: 600),
//                               child: ColorBlindnessCard(
//                                 currentState.rgbColors,
//                                 currentState.locked,
//                               ),
//                             )
//                           ],
//                         );
//                       }),
//                     ],
//                   ),
//                 ),
//               ),
//               if (isMultiSelected)
//                 MaterialPage<dynamic>(
//                   key: ValueKey("Multiple Color Compare"),
//                   child: BlocProvider<MultipleContrastCompareCubit>(
//                     create: (context) => MultipleContrastCompareCubit(
//                       BlocProvider.of<MdcSelectedBloc>(context),
//                     ),
//                     child: const ContrastCompareScreen(),
//                   ),
//                 )
//             ],
//             onPopPage: (route, dynamic result) {
//               setState(() {
//                 isMultiSelected = false;
//               });
//               return route.didPop(result);
//             },
//           ),
//         ),
//         Expanded(
//           child: SizedBox(), //ComponentsPreview(),
//         ),
//       ],
//     );
//   }

//   Widget schemeContrast(
//     BuildContext context,
//     ColorScheme colorScheme,
//     MDCLoadedState currentState,
//     bool shouldDisplayElevation,
//   ) {
//     final isiPad = MediaQuery.of(context).size.width > 600;

//     return Column(
//       children: <Widget>[
//         SizedBox(height: 4),
//         Row(
//           children: <Widget>[
//             if (isiPad) SizedBox(width: 24) else SizedBox(width: 16),
//             if (!isiPad) ...[
//               Expanded(
//                 child: RaisedButton.icon(
//                   label: Text("Modify"),
//                   icon: Icon(FeatherIcons.sliders, size: 16),
//                   textColor: colorScheme.onSurface,
//                   color: colorScheme.surface,
//                   onPressed: () {
//                     Navigator.pushNamed(context, "/colordetails");
//                   },
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                     side: BorderSide(
//                       color: colorScheme.onSurface.withOpacity(0.3),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//             ],
//             // Expanded(
//             //   child: RaisedButton.icon(
//             //     label: Text("Preview"),
//             //     icon: Icon(FeatherIcons.layout, size: 16),
//             //     textColor: colorScheme.onSurface,
//             //     color: colorScheme.surface,
//             //     onPressed: () {
//             //       Navigator.pushNamed(context, "/componentspreview");
//             //     },
//             //     shape: RoundedRectangleBorder(
//             //       borderRadius: BorderRadius.circular(16),
//             //       side: BorderSide(
//             //         color: colorScheme.onSurface.withOpacity(0.30),
//             //       ),
//             //     ),
//             //   ),
//             // ),
//             if (isiPad) const SizedBox(width: 8) else const SizedBox(width: 16),
//           ],
//         ),
//         ConstrainedBox(
//           constraints: BoxConstraints(maxWidth: 600),
//           child: ColorSchemeCard(
//             rgbColors: currentState.rgbColors,
//             rgbColorsWithBlindness: currentState.rgbColorsWithBlindness,
//             hsluvColors: currentState.hsluvColors,
//             locked: currentState.locked,
//           ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.all(24),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   )),
//               child: Column(
//                 children: [
//                   Icon(Icons.compare_arrows),
//                   Text("Compare"),
//                 ],
//               ),
//               onPressed: () {},
//             ),
//             SizedBox(width: 16),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.all(24),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   Icon(Icons.settings),
//                   Text("Settings"),
//                 ],
//               ),
//               onPressed: () {},
//             ),
//             SizedBox(width: 16),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.all(24),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   )),
//               child: Column(
//                 children: [
//                   Icon(Icons.settings),
//                   Text("Settings"),
//                 ],
//               ),
//               onPressed: () {},
//             ),
//           ],
//         ),
//         ConstrainedBox(
//           constraints: BoxConstraints(maxWidth: 600),
//           child: ContrastRatioCard(
//             currentState.rgbColorsWithBlindness,
//             shouldDisplayElevation,
//             currentState.locked,
//             () {
//               setState(() {
//                 isMultiSelected = true;
//               });
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
