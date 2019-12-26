<p align="center"><img src="assets/both.png" alt="Color Studio" height="200px"></p>

# Color Studio

It is hard to choose colors. Most color pickers give you 16 million colors and ask you to pick one. So many options, in fact, that your creativity may get blocked. There is no intuitive way to know which colors will fit your needs. This gets even harder when you deal with multiple colors. Even harder when you want these colors to follow a design specification and form a coherent theme. This project aims to help solve these problems.

[<img src="https://play.google.com/intl/en_us/badges/images/generic/en-play-badge.png" alt="Get it on Google Play" height="80">](https://play.google.com/store/apps/details?id=com.bernaferrari.colorstudio)

| Main Screen | Components Screen |
|:-:|:-:|
| ![First](assets/main_purple.PNG?raw=true) | ![Sec](assets/preview_green.PNG?raw=true) |


## Material Design

### History
First and foremost, but not exclusively, this app follows Material Design, with a special emphasis in dark mode. While dark mode is trending nowadays, the idea came when writing [Change Detection](https://github.com/bernaferrari/ChangeDetection).
Back then it was hard to make a coherent dark theme. In [May 2019](https://github.com/material-components/material-components-android/releases/tag/1.1.0-alpha06), Material Design Components for Android started receiving dark mode support.
Material Dark Theme, however, [has a twist](https://material.io/design/color/dark-theme.html#properties): it applies a white overlay as a surface gets higher (more elevated). This is mandatory and instantly broke half my app. I started using more and more `elevation = 0`, but then it made the light theme worse. 
Choosing colors, which was already hard, became trial and error. I relied a lot on [Color Hexa](https://www.colorhexa.com/), but as my projects got more complex, it got insufficient and became a pain. Suddenly, I was already developing my own tool.  

### Overview

#### Color Scheme
This app allows you to play with 3 colors: Primary, Background and Surface. Background and Surface allows you to toggle "auto" mode (by default, when you open the app, it is on for the Background, to help with discoverability). In auto mode, Background follows the [Material Design recommendation](https://material.io/design/color/dark-theme.html#properties): 8% of Primary color + #121212.
Regarding Surface color, there is no official recommendation. Initially, the app made it the same as the Background color, but this didn't feel good. Inspired by [Moleskine Timepage](https://apps.apple.com/us/app/timepage/id989178902), Surface now gets the Background and adds 5% of lightness in [HSLuv](http://www.hsluv.org/) color space. If Background has 10% of lightness, Surface has 15%.

Everything was written with extensibility in mind. The colors are not hard-coded, and it is straight-forward to add more or modify them in the future. In a previous app version, Secondary color was also present, but was removed to make the app simpler.

<p align="center"><img src="assets/color_scheme.jpg?raw=true" alt="Color Scheme" height="350px"></p>

#### Contrast
Web Content Accessibility Guidelines (WCAG) recommends a contrast of:

- **3.0:1** minimum for texts larger than 18pt or icons (AA+).
- **4.5:1** minimum for texts smaller than 18pt (AA).
- **7.0:1** minimum when possible, if possible (AAA).

Material Design follows it and recommends a contrast ratio of 4.5:1 (AA) for body text at all elevations. This project shows all possible elevation variations with their respective contrast to Primary color.

If you want to know more about contrast, read [this](https://usecontrast.com/guide), [this](https://www.w3.org/TR/WCAG21/#contrast-minimum) or [this](https://www.carbondesignsystem.com/guidelines/accessibility/color/).

#### Color Blindness
> Don’t rely on color alone to convey meaning. This includes conveying information, indicating an action, prompting the user for a response, or distinguishing one visual element from another.
> 
> Source: [Carbon Design System](https://www.carbondesignsystem.com/guidelines/accessibility/color/)

> Because colorblindness takes different forms (including red-green, blue-yellow, and monochromatic), multiple visual cues help communicate important states. Elements such as strokes, indicators, patterns, texture, or text can describe actions and content.
> 
> Source: [Material Design System](https://material.io/design/usability/accessibility.html#color-contrast)

This project allows you to select between 8 different Color Blindness scenarios using the formulas from a Swift library named [Colorblinds](https://github.com/jdekock/Colorblinds).
It automatically updates the contrast ratio between colors, so that you can see simulate a color blind scenario.

#### Preview Page
Wouldn't be great to immediately test your colors against a template and simulate how a real app would look like with them? This is exactly what this page is about.
You can change the elevation from 0 to 24pt or color blindness value and immediately see how the layout adapts. There are many layouts inspired by real designs: Spotify, Facebook, Microsoft, Skyscanner, Kayak, Google's Clock app, Play Store, SDK Monitor and PocketCasts.
In iPad, web or a device with a large screen, this screen is shown in split-view with the Edit colors screen. This way, it gets even easier to update your design.

<p align="center"><img src="assets/preview_purple.PNG?raw=true" alt="Split-view in iPad" height="350px"></p>

#### Edit colors
This screen provides the following:
- A vertical color picker in HSLuv and HSV.
- Individual color blindness.
- Color library with colors from [Color Claim](https://www.vanschneider.com/colors) palette.
- Templates; colors from other apps that work great together.

At the bottom of the screen you can select the color you want to modify, and expand the contrast circles, so that you know how the contrast is changing.
When using a [HSLuv](https://github.com/bernaferrari/hsluv-dart) picker, only when changing the Lightness attribute that contrast value (against another color) changes. You can tweak the Hue and Saturation without affecting the contrast.
If you use HSV, it becomes a lot harder.

### HSV vs HSLuv
<p align="center"><img src="https://github.com/bernaferrari/hsluv-dart/raw/master/example/assets/hsluv_vs_hsv.jpg" alt="HSV vs HSLuv" height="350px"></p>
The image shows the difference between Hue values in HSV (or HSL, which has the same Hue values) and HSLuv. HSLuv only changes the apparent lightness when lightness changes.
If you change both Hue and Saturation values, when compared to another color, the resulting contrast value will not change.
You only need to update the Lightness value and nothing else to modify the contrast ratio.

This project lead to the creation of [HSLuv for Dart/Flutter](https://github.com/bernaferrari/hsluv-dart), a library anyone can use, and a sample, which is a subset of this project.

## Flutter

This project has been written in Flutter and has ~12000 lines of code. It is huge, specially since there is no back-end.
Overall, I am satisfied. Yes, Flutter has many, many bugs. Some features had to be changed or dropped, like a palette picker from a photo.
There are [bugs](https://github.com/flutter/flutter/issues/40613) and even mutating bugs in the image pipeline.
Animations are also a pain point, specially when compared with Swift UI. Sometimes a view scrolls one direction, but [can't scroll to the other](https://github.com/flutter/flutter/issues/10949) - and the fix is one commit away, but was unfortunately rejected for lack of test.
Finally, there are a lot of grey areas. In this project, a Column with SingleChildListView worked faster, smoother and better than a simple ListView.

Even with these and others (like the [inexplicable TextTheme](https://api.flutter.dev/flutter/material/TextTheme-class.html)), the framework has been getting a lot better. This project even [lead to a contribution](https://github.com/flutter/flutter/pull/40641), the addition of OnLongPress to Material buttons.
It is already possible to test this on the web, and the future looks great. It is great to write once and deploy to multiple devices, even if [some workarounds](https://github.com/flutter/flutter/issues/36822) are needed for now.

Recently, Dart received support for Extensions and soon will receive null safety. As it modernises itself, it is getting more and more pleasant.
There is no Dagger yet, but there is [Bloc](https://github.com/felangel/bloc), which looks like [MvRx](https://github.com/airbnb/MvRx).
The area I feel Flutter is in most need right now is tooling. IntelliJ support feels like Rust: works great until it doesn't. Refactorings are never perfect, sometimes you need to import a file by hand, sometimes the IDE randomly breaks and so on. Lint and auto-fix are years behind native Android.
I also miss a [KtLint](https://github.com/pinterest/ktlint) / [Detekt](https://github.com/arturbosch/detekt) for Flutter and might as well make one in the future. As it happened with Kotlin, as more companies start using Flutter, the ecosystem will inevitably get better.

### App architecture
This project has a fairly simple architecture, with 5 Blocs.

1. MdcSelectedBloc tracks current item selected and colors. Has a `Map<String, Color>`, where String might be Primary and Color is any color.
2. ContrastRatioBloc listen MdcSelectedBloc for changes and calculates the contrast value between Primary, Background and Surface. This may be computationally expensive operation.
3. MultipleContrastBloc similar to previous, but calculates all the contrasts relative to Primary color. Also, calculates the contrast for four Lightness variations per color.
4. ColorBlindBloc only tracks an int, which tells if any ColorBlindness was selected. MdcSelectedBloc listen to this.
5. SliderColorBloc tracks the Sliders in the color picker dialog. Every time they change, this bloc is called to make the RGB/HSLuv/HSV conversion.                                                   

There is no connection to the internet, besides [Google Fonts](https://github.com/material-foundation/google-fonts-flutter).
Many fonts are used in this app:
1. B612Mono as the main monospace font. Shows app in the vertical picker and search color buttons (with #).
2. OpenSans used in the main screen.
3. FiraSans used in the edit colors screen. 
3. Raleway, Lato, Heebo, Oswald, Muli, Oxygen, OxygenMono used in Preview screen, to give diversity to the layouts.

Even with all of these, app has ~3.55mb of data.

A big difficulty I had while making this project was separation of concerns. Since almost everything is UI, there comes a point where there is a GenericExpandableWidget (expands any child with animation), an ExpandableMyWidget (passing the correct parameters to GenericExpandableWidget), a HeaderWidget (expands/compacts but is always there) and an ExpandedWidget. All of these inside another Widget, because Primary, Background and Surface are 3 expandable items. When you expand one, the others compress, so it needs an additional controller.
That additional controller has to survive in memory, else when someone scrolls down and up, what was expanded gets compressed.
Naming Widgets and separating them became a problem, but that might happen in any language.

Blocs made life **a lot** easier. However, when should you listen to it and when should you just pass its values as parameter? That was also a challenge in some cases.
Listening directly helps in code sharing between app. For example, in development, the bottom bar at color editing screen listened directly. When I decided to move it around and test in other screens, it was ready. No outside parameter required.
At the other hand listening directly really hurts code sharing between multiple apps. Each app I have got different Blocs. At the end, I opted for listening at the root Widgets, and would only listen at the farthest widgets if multiple widgets had to be changed for no benefit at all.

### iOS
The app works perfectly in iPhone and iPad. I am, however, still reluctant if App Store is worth. Apple charges $100 a year and I'm not sure if there is enough demand to justify its presence there. If you are an iPhone/iPad user, feel free to open an issue, [email me](mailto:bernaferrari2@gmail.com) or [contribute with money](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=bernaferrari2%40gmail.com).

## Screenshots
| Main | Main Screen | Color Blindness | About |
|:-:|:-:|:-:|:-:|
| ![First](assets/play_store_00.jpg?raw=true) | ![Sec](assets/play_store_8.jpg?raw=true) | ![Third](assets/play_store_3.jpg?raw=true) | ![Fourth](assets/play_store_7.jpg?raw=true) |

## Reporting Issues

It is not easy to develop alone. I am a developer, not a designer. If you have any design suggestions, feature requests or would like to integrate your own color specs,
issues and pull requests are welcome.
You can report [here](https://github.com/bernaferrari/color-studio/issues).

## License

    Copyright 2020 Bernardo Ferrari

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.