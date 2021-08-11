![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white?longCache=true&style=flat-square) [![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white&longCache=true&style=flat-square)](https://flutter.dev/)
[![Awesome Flutter](https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square)](https://github.com/Solido/awesome-flutter) [![style: lint](https://img.shields.io/badge/style-lint-4BC0F5.svg?longCache=true&style=flat-square)](https://pub.dev/packages/lint) 

# Space Empires 🛸


![](https://user-images.githubusercontent.com/62766656/123627533-c11e8f00-d82f-11eb-87c3-4aef12d03b1c.png)

<a href="https://play.google.com/store/apps/details?id=com.satyamx64.space_empires">
<img src = "https://user-images.githubusercontent.com/62766656/123628002-47d36c00-d830-11eb-930f-877afaca2b54.png" width = "200">
</a>


### Introduction 🚀

> Space Empires
A 4X Space themed Strategy Game made with Flutter

Complete Rules and Instruction can be accessed from the game or [here](https://docs.google.com/document/d/1LX5RmtJPIekRA4S_pJsYIj4z-AL53fuXrVM-1CW9X1M/edit?usp=sharing)

Before we start, you can take a look at the app:

- [Demo Video](https://www.youtube.com/watch?v=5eod02si8Vo&ab_channel=satyamsharma)


### Attributions 🙏

All the assets used in this product belong to their rightful owners and were available for Non-Commercial Use

- [Link to the resources](https://docs.google.com/document/d/1t160rPKv3MEou_8PcyNJRNWqaIAATsgcdPjZVuQFy90/edit?usp=sharing)


### Usage 🎨

To clone and run this application, you'll need [git](https://git-scm.com) and [flutter](https://flutter.dev/docs/get-started/install) installed on your computer. From your command line:

```bash
# Clone this repository
$ git clone https://github.com/SatyamX64/space_empires

# Go into the repository
$ cd space_empires

# Install dependencies
$ flutter packages get

# Run the app
$ flutter run
```


## Features ⚡ 

- Cross Platform
    - Web (Tested)
    - Android (Tested)
    - Ios (Not Tested)
- Responsive (Works in both Orientations)
- Adaptive (Works Beautifully in almost all screen sizes)
- A basic custom Computer AI

## Current Progress ✔️

- All the Essential Screens/Views are done
- All the required actions for Player and Computer are defined and working
- All the Buildings/Stats/Upgrades/Ships have the desired effect
- The game follows all the defined rules
- Computer AI can take all the actions, just like a regular player
- Null-Safe and follows Lint Guidlines

## Things that need attention 🔧

- A better budget allocation strategy for computer AI
- The AI can be too aggressive sometimes
- A better chat and relations strategy for Computer AI
- A more balanced Stats allocation and reward system
- Audio Effects 
- Refactoring and Optimization
- Your health and happiness :)

Most of these can be fixed by just tweaking the constant values and numbers. (services>game.dart)
Associated TODO tags can be found over the Project, so feel free to play around with the values.
The Project will remain open-source and any contribution or feedback will be highly appreciated



### Packages 📦


These are the packages used in this Project



Package | Description
---|---
[after_layout](https://pub.dev/packages/after_layout) | Helps execute code after the first layout of a widget has been performed
[animated_text_kit](https://pub.dev/packages/animated_text_kit) | Provides Cool and Beautiful Text Animations
[carousel_slider](https://pub.dev/packages/carousel_slider) | For Slidable Cards
[flutter_animated_dialog](https://pub.dev/packages/flutter_animated_dialog) | For Animated Dialogs
[flutter_staggered_grid_view](https://pub.dev/packages/flutter_staggered_grid_view) | For Planets Alignment
[flutter_svg](https://pub.dev/packages/flutter_svg) | To render SVG
[provider](https://pub.flutter-io.cn/packages/provider) | Provider State Management
[lottie](https://pub.dev/packages/lottie) | For Lottie Animations
[sizer](https://pub.dev/packages/sizer) | Helps with Responsiveness
[rive](https://pub.dev/packages/rive) | For Rive Animations
[shared_preferences](https://pub.dev/packages/shared_preferences) | For Data Persistance
[lint](https://pub.flutter-io.cn/packages/lint) | Rules handler for Dart



### Directory Structure 🏢

The project directory structure is as follows:

```
├── android
├── asset
├── build
├── ios
├── lib
├── analysis_options.yaml
├── pubspec.lock
├── pubspec.yaml

```

![image](https://user-images.githubusercontent.com/62766656/123632625-c8489b80-d835-11eb-80e2-d19e17c15cec.png)




Directory | Description
---|---
models | Contains Model Class for Ships, Planets, Rulers
screens | Contains the UI class for all the Screens
services | Contains the Game Service, Player Service and all Core Logic
utility | Contains app-wide constants, common functions
widgets | Contains UI Blocks and Other Functional Elements

# Some shots from the Game (old)

![welcome_screen_landscape](https://user-images.githubusercontent.com/62766656/120899766-f11eac00-c64e-11eb-912b-f7983dfbf73d.jpg)

## Game Screen

<img src="https://user-images.githubusercontent.com/62766656/120899823-3a6efb80-c64f-11eb-9fa3-8425aafb51b0.jpg" width="270" height="600">   <img src="https://user-images.githubusercontent.com/62766656/120899922-b23d2600-c64f-11eb-9b6b-7a052cda5894.jpg" width="270" height="600">   <img src="https://user-images.githubusercontent.com/62766656/120899938-d0a32180-c64f-11eb-939f-adf76a5bb0f3.jpg" width="270" height="600">


## Control Panels

<img src="https://user-images.githubusercontent.com/62766656/120899975-03e5b080-c650-11eb-881c-6c54db23ea19.jpg" width="270" height="600">   <img src="https://user-images.githubusercontent.com/62766656/120899985-17911700-c650-11eb-9ef3-d99cb9cc3cec.jpg" width="270" height="600">   <img src="https://user-images.githubusercontent.com/62766656/120900002-2d9ed780-c650-11eb-801f-f56af6901911.jpg" width="270" height="600">


## Planet Info

![planet_stats_landscape](https://user-images.githubusercontent.com/62766656/120899479-90db3a80-c64d-11eb-9f1d-9272da8bd67b.jpg) ![planet_upgrades_landscape](https://user-images.githubusercontent.com/62766656/120899484-989adf00-c64d-11eb-9908-b05007a5b310.jpg) ![planet_defense_landscape](https://user-images.githubusercontent.com/62766656/120899489-a05a8380-c64d-11eb-9b49-d8e9336d6abc.jpg)












