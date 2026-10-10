import 'dart:io';
import 'package:discipulus/api/dummy_magister_api_dart.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_screenshot/golden_screenshot.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:isar/isar.dart';
import 'dart:async';
import 'package:irondash_message_channel/irondash_message_channel.dart';
import 'package:super_native_extensions/src/native/context.dart';
import 'package:discipulus/api/models/activities.dart';
import 'package:discipulus/api/models/studiewijzers.dart';


//
//  Most if not all of this was AI written, as mocking these
//  platform channels is hell and I do not think that anyone
//  will ever use this except for me lol. 
//

class PermissiveMockContext extends MockMessageChannelContext {
  @override
  FutureOr<dynamic> _sendMessage(String channel, dynamic message) {
    return ['ok', null];
  }
}

Directory? _testStorageDir;

/// Initializes the test environment with an in-memory/temp Isar instance
/// and seeds it with the lively Dutch dummy account.
Future<void> initScreenshotTestEnv() async {
  final mockContext = MockMessageChannelContext();
  for (final channel in [
    'MenuManager',
    'DropManager',
    'DragManager',
    'DataReaderManager',
    'ClipboardReader',
    'ClipboardWriter',
    'HotKeyManager',
    'KeyboardLayoutManager',
  ]) {
    mockContext.registerMockChannelHandler(
      channel,
      (msg) async => ['ok', null],
    );
  }
  setContextOverride(mockContext);
  await Isar.initializeIsarCore(download: true);
  initializeDateFormatting("nl-NL");

  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  // Mock path provider
  messenger.setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/path_provider'),
    (MethodCall methodCall) async {
      return _testStorageDir?.path ?? Directory.systemTemp.path;
    },
  );

  // Mock package info
  messenger.setMockMethodCallHandler(
    const MethodChannel('dev.fluttercommunity.plus/package_info'),
    (MethodCall methodCall) async {
      return {
        'appName': 'Discipulus',
        'packageName': 'dev.harrydekat.discipulus',
        'version': '0.2.8',
        'buildNumber': '34',
      };
    },
  );

  // Mock device info
  messenger.setMockMethodCallHandler(
    const MethodChannel('dev.fluttercommunity.plus/device_info'),
    (MethodCall methodCall) async {
      return {
        'computerName': 'Mac',
        'hostName': 'Mac',
        'arch': 'arm64',
        'model': 'Mac',
        'modelName': 'MacBook Pro',
        'kernelVersion': 'Darwin',
        'osRelease': '24.0.0',
        'majorVersion': 15,
        'minorVersion': 0,
        'patchVersion': 0,
        'activeCPUs': 8,
        'memorySize': 16000000000,
        'cpuFrequency': 3000000000,
        'systemGUID': 'GUID',
      };
    },
  );

  // Mock connectivity
  messenger.setMockMethodCallHandler(
    const MethodChannel('dev.fluttercommunity.plus/connectivity'),
    (MethodCall methodCall) async {
      return ['wifi'];
    },
  );

  messenger.setMockMethodCallHandler(
    const MethodChannel('dev.fluttercommunity.plus/connectivity_status'),
    (MethodCall methodCall) async {
      return null;
    },
  );

  // Mock apple spotlight
  messenger.setMockMethodCallHandler(
    const MethodChannel('flutter_apple_spotlight'),
    (MethodCall methodCall) async {
      return null;
    },
  );

  // Mock home widget
  messenger.setMockMethodCallHandler(
    const MethodChannel('home_widget'),
    (MethodCall methodCall) async {
      return null;
    },
  );

  // Mock watch connectivity
  messenger.setMockMethodCallHandler(
    const MethodChannel('watch_connectivity'),
    (MethodCall methodCall) async {
      return null;
    },
  );

  // Mock apple handoff
  messenger.setMockMethodCallHandler(
    const MethodChannel('flutter_apple_handoff'),
    (MethodCall methodCall) async {
      return null;
    },
  );

  // Mock irondash engine context
  messenger.setMockMethodCallHandler(
    const MethodChannel('dev.irondash.engine_context'),
    (MethodCall methodCall) async {
      return 0;
    },
  );

  _testStorageDir =
      Directory.systemTemp.createTempSync('discipulus_screenshots_');
  storageDir = _testStorageDir;

  isar = await Isar.open(
    schemas,
    directory: _testStorageDir!.path,
    inspector: false,
  );

  // Initialize app settings
  appSettings
    ..activeMaterialYouColorInt = const Color(0xFF2B5EA7).toARGB32()
    ..useMaterialYou = false
    ..themeVariant = ThemeVariant.tonalSpot
    ..save();

  // Create and fill dummy account
  final dummyAccount = DiscipulusAccount(
    tokenSet: null,
    endPoint: Uri.base.toString(),
    id: 0,
    permissions: (await DummyMagister().account)
        .groep
        .expand((g) => g.privileges)
        .toList(),
  );

  await dummyAccount.fill();

  // Set active profile and pre-populate all domains for offline speed
  final profile = isar.profiles.filter().not().accountIsNull().findFirstSync();
  if (profile != null) {
    activeProfile = profile;
    appSettings.activeProfileUuid = profile.uuid;
    appSettings.save();

    // Populate activities, studiewijzers, messages and calendar into Isar
    final acts =
        await profile.account.value!.api.person(profile.id).activiteiten;
    for (final act in acts) {
      act.profile.value = profile;
    }
    isar.writeTxnSync(() {
      isar.activitys.putAllSync(acts);
      profile.activities.addAll(acts);
      profile.activities.saveSync();
    });
    await profile.fetchStudiewijzers();
    final swList = await isar.studiewijzers.where().findAll();
    for (final sw in swList) {
      await sw.fill();
    }
    final folders = await profile.getBerichtMappen;
    isar.writeTxnSync(() => profile.berichtMappen.saveSync());
    for (final folder in folders) {
      await folder.getMessages();
    }
    final now = DateTime.now();
    await profile.getEvents(DateTimeRange(
      start: now.subtract(const Duration(days: 7)),
      end: now.add(const Duration(days: 14)),
    ));
    final fixedSchoolDay = DateTime(2026, 9, 15);
    final weekStart = fixedSchoolDay.subtract(Duration(days: fixedSchoolDay.weekday - 1));
    await profile.getEvents(DateTimeRange(
      start: weekStart.subtract(const Duration(days: 7)),
      end: weekStart.add(const Duration(days: 14)),
    ));
  }
}

/// Cleans up temporary resources
Future<void> cleanScreenshotTestEnv() async {
  try {
    if (isar.isOpen) {
      await isar.close().timeout(const Duration(seconds: 2));
    }
  } catch (_) {}
  try {
    if (_testStorageDir != null && _testStorageDir!.existsSync()) {
      _testStorageDir!.deleteSync(recursive: true);
    }
  } catch (_) {}
}

/// Custom device definitions for Discipulus screenshots
class DiscipulusScreenshotDevices {
  static final ScreenshotDevice iphone = GoldenScreenshotDevices.iphone.device;
  static final ScreenshotDevice ipad = GoldenScreenshotDevices.ipad.device;

  static const ScreenshotDevice pixel3XL = ScreenshotDevice(
    platform: TargetPlatform.android,
    resolution: Size(1440, 2960),
    pixelRatio: 3.5,
    goldenSubFolder: 'pixel3xlScreenshots/',
    frameBuilder: ScreenshotFrame.androidPhone,
  );
}

/// Wraps the widget under test with Discipulus ThemeData and ScreenshotApp
Widget buildScreenshotApp({
  required Widget child,
  required ScreenshotDevice device,
  bool darkMode = false,
  Color seedColor = const Color(0xFF2B5EA7),
}) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: darkMode ? Brightness.dark : Brightness.light,
    dynamicSchemeVariant: DynamicSchemeVariant.tonalSpot,
  );

  return ScreenshotApp(
    device: device,
    builder: (context, frameChild) {
      return ColoredBox(
        color: colorScheme.surface,
        child: frameChild ?? const SizedBox.expand(),
      );
    },
    home: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: darkMode ? Brightness.dark : Brightness.light,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.surface,
        snackBarTheme:
            const SnackBarThemeData(behavior: SnackBarBehavior.floating),
        cardTheme: const CardThemeData(shadowColor: Colors.transparent),
        platform: device.platform,
      ),
      locale: const Locale('nl', 'NL'),
      home: ColoredBox(
        color: colorScheme.surface,
        child: Material(
          color: colorScheme.surface,
          child: child,
        ),
      ),
    ),
  );
}

extension ScreenshotTesterExt on WidgetTester {
  /// Pumps multiple frames advancing both fake time and real async loop
  /// so that timers (e.g. CalendarDayView's 250ms, ScaffoldSkeleton's 500ms),
  /// background Isar worker isolates, and network/dummy futures can complete.
  /// Then waits until all spinners (CircularProgressIndicator, LinearProgressIndicator)
  /// have completely disappeared and fade transitions have settled before taking the screenshot.
  Future<void> settleApp({
    Duration minWait = const Duration(seconds: 3),
    Duration timeout = const Duration(seconds: 10),
    Duration step = const Duration(milliseconds: 50),
    int postSpinnerFrames = 8,
  }) async {
    // 1. Advance both fakeAsync clock and real async loop in increments of [step]
    // until at least [minWait] has elapsed in fake time AND real time.
    // This guarantees that initial delayed timers (like ScaffoldSkeleton's 500ms
    // and CalendarDayView's 250ms) fire, starting their async fetches.
    final int initialSteps = (minWait.inMilliseconds / step.inMilliseconds).ceil();
    for (int i = 0; i < initialSteps; i++) {
      await runAsync(() async {
        await Future.delayed(step);
      });
      await pump(step);
    }

    // 2. Poll while any spinners (CircularProgressIndicator or LinearProgressIndicator)
    // are present, advancing both real time and fake time so background futures finish.
    final stopwatch = Stopwatch()..start();
    while (stopwatch.elapsed < timeout) {
      final spinners = find.byType(CircularProgressIndicator);
      final linearBars = find.byType(LinearProgressIndicator);
      if (spinners.evaluate().isEmpty && linearBars.evaluate().isEmpty) {
        break;
      }
      await runAsync(() async {
        await Future.delayed(const Duration(milliseconds: 60));
      });
      await pump(const Duration(milliseconds: 60));
    }

    // 3. Settle animations (such as AnimatedSwitcher/FadeTransition 150ms fade-outs)
    for (int i = 0; i < postSpinnerFrames; i++) {
      await runAsync(() async {
        await Future.delayed(const Duration(milliseconds: 50));
      });
      await pump(const Duration(milliseconds: 50));
    }
  }

  /// Convenience wrapper for expectScreenshot that ensures the screen is settled
  Future<void> expectDeviceScreenshot(
    ScreenshotDevice device,
    String goldenFileName,
  ) async {
    await settleApp(minWait: const Duration(seconds: 3));
    await expectScreenshot(device, goldenFileName);
  }

  /// Cleanly disposes widget tree and flushes any trailing microtask/timers (e.g. HandoffFocus 500ms delay)
  Future<void> cleanTearDown() async {
    await pumpWidget(const SizedBox());
    await runAsync(() async {
      await Future.delayed(const Duration(milliseconds: 150));
    });
    await pump(const Duration(milliseconds: 600));
  }
}
