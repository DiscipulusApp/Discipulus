// Dart
import 'dart:async';
import 'dart:io';
import 'dart:ui';

// API
import 'package:discipulus/api/models/activities.dart';
import 'package:discipulus/api/models/assignments.dart';
import 'package:discipulus/api/models/bronnen.dart';
import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/external_bron.dart';
import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/api/models/messages.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/api/models/studiewijzers.dart';
import 'package:discipulus/api/models/subjects.dart';

// Models
import 'package:discipulus/models/account.dart';
import 'package:discipulus/models/settings.dart';

// Cpre
import 'package:discipulus/core/handoff.dart';
import 'package:discipulus/core/notifications.dart';
import 'package:discipulus/core/routes.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Packages & plugins
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:animations/animations.dart';
import 'package:app_links/app_links.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter_apple_handoff/flutter_apple_handoff.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart';
import 'package:workmanager/workmanager.dart';
import 'package:home_widget/home_widget.dart';
import 'package:dnd_manager/dnd_manager.dart';

// Misc
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/screens/introduction/vertical_intro.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/layout.dart';

part 'core/background_tasks.dart';
part 'core/background_tasks_alarms.dart';
part 'core/background_tasks_calendar.dart';
part 'core/isar.dart';

List<FlutterErrorDetails> errors = [];
late final AppLinks appLinks;
late final RootIsolateToken rootIsolateToken;
Directory? storageDir;
late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main(args) async {
  if (runWebViewTitleBarWidget(args)) {
    return;
  }

  WidgetsFlutterBinding.ensureInitialized();

  appLinks = AppLinks();
  rootIsolateToken = RootIsolateToken.instance!;

  //Expand app behind navigation bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
  ));
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );

  await initIsar();

  initializeTimeZones();
  initializeDateFormatting("nl-NL");

  if (Platform.isIOS || Platform.isAndroid || Platform.isMacOS) {
    // Init background refresh for iOS and Android.
    if (!Platform.isMacOS) await BackgroundRefresh.init();

    // Init handoff and widgets for darwin
    if (Platform.isIOS || Platform.isMacOS) {
      FlutterAppleHandoff.onActivityChanged = onNewUserActivity;
      await HomeWidget.setAppGroupId(
          'group.DUGUWCFH8P.dev.harrydekat.discipulus');
      try {
        await HomeWidget.registerInteractivityCallback(homeWidgetCallback);
      } catch (e) {
        // Continue if the iOS version does not support widget interactivity yet
      }
    }
  }

  await NotificationController.init();

  if (Platform.isAndroid) await AndroidAlarmManager.initialize();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    errors.add(details);
  };

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => MainAppState();

  ///This is used to change settings that effect the theming of the app
  static MainAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MainAppState>()!;
}

class MainAppState extends State<MainApp> {
  Future<void> updateTheme() async {
    accentColor = await DynamicColorPlugin.getAccentColor();
    if (mounted) setState(() {});
  }

  Color? accentColor;

  @override
  void initState() {
    updateTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        //
        // God knows why, but the dynamic_color package has gone haywire in
        // the latest version of flutter (3.22), so for now a workaround has to
        // be used to get the correct coloring
        //

        List<Color> extractAdditionalColours(ColorScheme scheme) => [
              scheme.surface,
              scheme.surfaceDim,
              scheme.surfaceBright,
              scheme.surfaceContainerLowest,
              scheme.surfaceContainerLow,
              scheme.surfaceContainer,
              scheme.surfaceContainerHigh,
              scheme.surfaceContainerHighest,
            ];

        ColorScheme insertAdditionalColours(
                ColorScheme scheme, List<Color> additionalColours) =>
            scheme.copyWith(
              surface: additionalColours[0],
              surfaceDim: additionalColours[1],
              surfaceBright: additionalColours[2],
              surfaceContainerLowest: additionalColours[3],
              surfaceContainerLow: additionalColours[4],
              surfaceContainer: additionalColours[5],
              surfaceContainerHigh: additionalColours[6],
              surfaceContainerHighest: additionalColours[7],
            );

        (ColorScheme light, ColorScheme dark) generateDynamicColourSchemes(
            ColorScheme lightDynamic, ColorScheme darkDynamic) {
          var lightBase = ColorScheme.fromSeed(seedColor: lightDynamic.primary);
          var darkBase = ColorScheme.fromSeed(
              seedColor: darkDynamic.primary, brightness: Brightness.dark);

          var lightAdditionalColours = extractAdditionalColours(lightBase);
          var darkAdditionalColours = extractAdditionalColours(darkBase);

          var lightScheme =
              insertAdditionalColours(lightBase, lightAdditionalColours);
          var darkScheme =
              insertAdditionalColours(darkBase, darkAdditionalColours);

          return (lightScheme.harmonized(), darkScheme.harmonized());
        }

        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;
        if (lightDynamic != null &&
            darkDynamic != null &&
            (appSettings.useMaterialYou ?? true)) {
          //Using Material You colors set by Android S+ devices
          appSettings
            ..useMaterialYou = true
            ..save();
          (lightColorScheme, darkColorScheme) =
              generateDynamicColourSchemes(lightDynamic, darkDynamic);
        } else {
          Color seedColor =
              (appSettings.useMaterialYou ?? true) && accentColor != null
                  ? accentColor!
                  : Color(appSettings.activeMaterialYouColorInt);

          // Not using Material You colors set by Android S+ devices
          lightColorScheme = ColorScheme.fromSeed(
            seedColor: seedColor,
          ).harmonized();
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: seedColor,
            brightness: Brightness.dark,
          ).harmonized();
        }

        //Theme settings
        ThemeData getTheme({bool useDarkMode = false}) {
          ColorScheme colorScheme =
              useDarkMode ? darkColorScheme : lightColorScheme;

          // Refresh the color scheme for the widgets
          refreshWidgetColorscheme(
            lightColorScheme: lightColorScheme,
            darkColorScheme: darkColorScheme,
          );

          return ThemeData(
            // Desktops should always follow [TargetPlatform.android]
            platform: TargetPlatform.android,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            brightness: useDarkMode ? Brightness.dark : Brightness.light,
            colorScheme: colorScheme,
            useMaterial3: true,
            splashFactory: InkSparkle.splashFactory,
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: SharedAxisPageTransitionsBuilder(
                  transitionType: SharedAxisTransitionType.scaled,
                )
              },
            ),
            snackBarTheme:
                const SnackBarThemeData(behavior: SnackBarBehavior.floating),
            tooltipTheme: TooltipThemeData(
              waitDuration: const Duration(milliseconds: 500),
              textStyle: TextStyle(color: colorScheme.onSurface),
              decoration: BoxDecoration(
                border: Border.fromBorderSide(
                  BorderSide(color: colorScheme.outline, width: 1),
                ),
                color: colorScheme.surface,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
            ),
            expansionTileTheme: ExpansionTileThemeData(
              expansionAnimationStyle: CustomAnimatedSize.style(),
            ),
            cardTheme: const CardTheme(shadowColor: Colors.transparent),
            chipTheme: const ChipThemeData(),
            searchViewTheme: SearchViewThemeData(
              backgroundColor: colorScheme.surface.applySurfaceTint(
                tint: colorScheme.surfaceTint,
                elevation: 1,
              ),
            ),
            dialogBackgroundColor: colorScheme.surface.applySurfaceTint(
              tint: colorScheme.surfaceTint,
              elevation: 1,
            ),
            badgeTheme: BadgeThemeData(
              textColor: colorScheme.onPrimaryContainer,
              backgroundColor: colorScheme.primaryContainer,
            ),
          );
        }

        return MaterialApp(
          theme: getTheme(),
          navigatorKey: navKey,
          locale: const Locale("nl-NL"),
          debugShowCheckedModeBanner: false,
          darkTheme: getTheme(useDarkMode: true),
          themeMode: appSettings.brightness == ThemeBrightness.system
              ? ThemeMode.system
              : appSettings.brightness == ThemeBrightness.dark
                  ? ThemeMode.dark
                  : ThemeMode.light,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              padding: MediaQuery.of(context).padding.copyWith(
                    top: MediaQuery.of(context).padding.top +
                        (Platform.isMacOS ? 28 : 0),
                  ),
            ),
            child: ScrollConfiguration(
              behavior: Platform.isIOS || Platform.isMacOS
                  ? const CupertinoScrollBehavior().copyWith(scrollbars: false)
                  : const MaterialScrollBehavior(),
              child: Layout(child: child!),
            ),
          ),
          home: (() {
            if (appSettings.activeProfileUuid == null &&
                isar.profiles.countSync() == 0) {
              // No profile was found, so we will show the introduction screen
              return const VerticalIntroductionScreen();
            } else {
              // An account was found, so we will show the starting view that the
              // user configured
              Destination selectedDesination =
                  destinations(activeProfile.account.value!.permissions)
                      .expand((e) => e.destinations)
                      .toList()[activeProfile.settings.startingPageIndex];

              // The [onPopToggleDrawer] is used to show the drawer when the back
              // button is pressed in Android.
              return onPopToggleDrawer(
                child: selectedDesination.view,
              );
            }
          })(),
        );
      },
    );
  }
}
