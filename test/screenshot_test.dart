import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/api/models/subjects.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/screens/activities/activities.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day.dart';
import 'package:discipulus/screens/grades/grades_statistics.dart';
import 'package:discipulus/screens/grades/grades_subject.dart';
import 'package:discipulus/screens/grades/widgets/calculator/grade_to_average_card.dart';
import 'package:discipulus/screens/introduction/expressive_intro.dart';
import 'package:discipulus/screens/messages/messages.dart';
import 'package:discipulus/screens/studiewijzers/studiewijzers.dart';
import 'package:flutter/material.dart' hide ThemeData;
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_screenshot/golden_screenshot.dart';
import 'package:isar/isar.dart';
import 'screenshot_utils.dart';

//
// Dear future Harry, this is not a normal test. 
// Please update the screenshots using `flutter test --update-goldens`
//

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    ScreenshotDevice.screenshotsFolder = 'screenshots/';
    await initScreenshotTestEnv();
  });

  tearDownAll(() async {
    await cleanScreenshotTestEnv();
  });

  final testDevices = [
    (DiscipulusScreenshotDevices.iphone, 'iPhone'),
    (DiscipulusScreenshotDevices.ipad, 'iPad'),
    (DiscipulusScreenshotDevices.pixel3XL, 'Pixel 3 XL'),
  ];

  for (final (device, deviceLabel) in testDevices) {
    group('$deviceLabel Screenshots', () {
      setUp(() {
        if (device.platform == TargetPlatform.iOS) {
          AppPlatform.setMockPlatform(
            isIOS: true,
            isAndroid: false,
            isMacOS: false,
            isWindows: false,
            isLinux: false,
          );
        } else {
          AppPlatform.setMockPlatform(
            isIOS: false,
            isAndroid: true,
            isMacOS: false,
            isWindows: false,
            isLinux: false,
          );
        }
      });

      tearDown(() {
        AppPlatform.reset();
      });

      // 1. First Boot / Welcome Screen
      testGoldens('01_welcome_screen', (tester) async {
        final previousOnError = FlutterError.onError;
        FlutterError.onError = (FlutterErrorDetails details) {
          if (details.exceptionAsString().contains('overflowed')) {
            return;
          }
          previousOnError?.call(details);
        };
        try {
          await tester.pumpWidget(
            buildScreenshotApp(
              device: device,
              child: const ExpressiveIntroductionScreen(),
            ),
          );
          await tester.loadAssets();
          await tester.settleApp();
          await tester.expectDeviceScreenshot(device, '01_welcome_screen');
          await tester.cleanTearDown();
        } finally {
          FlutterError.onError = previousOnError;
        }
      });

      // 2. Calendar / Daily Schedule
      testGoldens('02_calendar', (tester) async {
        final schoolDay = DateTime(2026, 9, 15);

        await tester.pumpWidget(
          buildScreenshotApp(
            device: device,
            child: CalendarDayView(displayedDay: schoolDay),
          ),
        );
        await tester.loadAssets();
        await tester.settleApp();
        await tester.expectDeviceScreenshot(device, '02_calendar');
        await tester.cleanTearDown();
      });

      // 3. Grade Statistics Screen
      testGoldens('03_grades_stats', (tester) async {
        await tester.pumpWidget(
          buildScreenshotApp(
            device: device,
            child: const GradesStatisticsScreen(),
          ),
        );
        await tester.loadAssets();
        await tester.settleApp();
        await tester.expectDeviceScreenshot(device, '03_grades_stats');
        await tester.cleanTearDown();
      });

      // 4. Grade Calculator
      testGoldens('04_grade_calculator', (tester) async {
        final previousOnError = FlutterError.onError;
        FlutterError.onError = (FlutterErrorDetails details) {
          if (details.exceptionAsString().contains('overflowed')) {
            return;
          }
          previousOnError?.call(details);
        };
        try {
          final subject = isar.subjects
                  .filter()
                  .naamEqualTo('Natuurkunde')
                  .findFirstSync() ??
              isar.subjects
                  .filter()
                  .naamEqualTo('Wiskunde B')
                  .findFirstSync() ??
              isar.subjects.where().findFirstSync()!;

          await tester.pumpWidget(
            buildScreenshotApp(
              device: device,
              child: SubjectGradesScreen(subject: subject),
            ),
          );
          await tester.loadAssets();
          await tester.settleApp();

          // Find the GradeToAverageCalculatorCard
          final gradeCard = find.byType(GradeToAverageCalculatorCard);
          final gradeField = find.descendant(
            of: gradeCard,
            matching: find.byWidgetPredicate(
              (w) => w is TextField && w.decoration?.hintText == 'Cijfer',
            ),
          );
          final weightField = find.descendant(
            of: gradeCard,
            matching: find.byWidgetPredicate(
              (w) => w is TextField && w.decoration?.hintText == 'Weging',
            ),
          );

          if (gradeField.evaluate().isNotEmpty &&
              weightField.evaluate().isNotEmpty) {
            await tester.enterText(gradeField.first, '8.0');
            await tester.pump(const Duration(milliseconds: 100));
            await tester.enterText(weightField.first, '2');
            await tester.settleApp();
          } else {
            final textFields = find.byType(TextField);
            if (textFields.evaluate().length >= 2) {
              await tester.enterText(textFields.at(0), '8.0');
              await tester.enterText(textFields.at(1), '2');
              await tester.settleApp();
            }
          }

          await tester.expectDeviceScreenshot(device, '04_grade_calculator');
          await tester.cleanTearDown();
        } finally {
          FlutterError.onError = previousOnError;
        }
      });

      // 5. Studiewijzers
      testGoldens('05_studiewijzers', (tester) async {
        await tester.pumpWidget(
          buildScreenshotApp(
            device: device,
            child: const StudiewijzerListScreen(),
          ),
        );
        await tester.loadAssets();
        await tester.settleApp();
        await tester.expectDeviceScreenshot(device, '05_studiewijzers');
        await tester.cleanTearDown();
      });

      // 6. Activiteiten
      testGoldens('06_activiteiten', (tester) async {
        await tester.pumpWidget(
          buildScreenshotApp(
            device: device,
            child: const ActivitiesScreen(),
          ),
        );
        await tester.loadAssets();
        await tester.settleApp();
        await tester.expectDeviceScreenshot(device, '06_activiteiten');
        await tester.cleanTearDown();
      });

      // 7. Berichten (School Inbox)
      testGoldens('07_messages', (tester) async {
        await tester.pumpWidget(
          buildScreenshotApp(
            device: device,
            child: const MessagesListScreen(),
          ),
        );
        await tester.loadAssets();
        await tester.settleApp();
        await tester.expectDeviceScreenshot(device, '07_messages');
        await tester.cleanTearDown();
      });
    });
  }
}
