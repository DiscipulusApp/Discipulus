import 'dart:io';

// Models
import 'package:discipulus/api/models/activities.dart';
import 'package:discipulus/api/models/assignments.dart';
import 'package:discipulus/api/models/bronnen.dart';
import 'package:discipulus/api/models/messages.dart';
import 'package:discipulus/api/models/studiewijzers.dart';
import 'package:discipulus/api/models/subjects.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/models/settings.dart';

// Core
import 'package:discipulus/core/routes.dart';
import 'package:discipulus/main.dart';
import 'package:isar/isar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/global/layout.dart';

// Screens
import 'package:discipulus/screens/activities/activities.dart';
import 'package:discipulus/screens/activities/activity_detail.dart';
import 'package:discipulus/screens/assignments/assignment_details.dart';
import 'package:discipulus/screens/assignments/assignments.dart';
import 'package:discipulus/screens/bronnen/bronnen_list.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day.dart';
import 'package:discipulus/screens/grades/grades.dart';
import 'package:discipulus/screens/grades/grades_subject.dart';
import 'package:discipulus/screens/messages/message_compose.dart';
import 'package:discipulus/screens/messages/message_details.dart';
import 'package:discipulus/screens/messages/messages.dart';
import 'package:discipulus/screens/studiewijzers/studiewijzer_details.dart';
import 'package:discipulus/screens/studiewijzers/studiewijzers.dart';

// Packages & Plugins
import 'package:flutter_apple_handoff/flutter_apple_handoff.dart';
import 'package:focus_on_it/focus_on_it.dart';

/// This is used to handle handoff between devices.
/// It contains the logic for switching to the correct screen when a handoff
/// is received.
Future<void> onNewUserActivity(NSUserActivity activity) async {
  // Try to switch to the same profile if present
  Profile? profile = await isar.profiles
      .filter()
      .uuidEqualTo(activity.userInfo?["profileUUID"] ?? -1)
      .findFirst();
  if (profile != null) {
    activeProfile = profile;
  }

  if (kDebugMode) {
    print(
        "Callback received: ${activity.title}${profile != null ? " on profile: ${profile.name}" : ""}");
  }

  // Switch to the correct screen
  switch (activity.activityType.split(".").last) {
    case "root-page":
      Destination? destination =
          destinations(activeProfile.account.value?.permissions ?? [])
              .expand((e) => e.destinations)
              .where((e) =>
                  "${e.view.runtimeType}" == activity.userInfo?["screenType"])
              .firstOrNull;

      if (destination?.view.runtimeType == CalendarDayView) {
        // Calendar should be launched
        Layout.of(navKey.currentContext!)?.goToPage(CalendarDayView(
          displayedDay: DateTime.tryParse(activity.userInfo?["date"]),
        ));
      } else if (destination != null) {
        Layout.of(navKey.currentContext!)?.goToPage(destination.view);
      }
      break;

    case "sub-page":
      switch (activity.userInfo?["screenType"]) {
        case "SubjectGradesScreen":
          // Specific subject
          Subject? subject = await isar.subjects
              .filter()
              .uuidEqualTo(activity.userInfo?["subject_uuid"])
              .findFirst();

          subject ??= await isar.subjects
              .filter()
              .idEqualTo(activity.userInfo?["subject_id"])
              .naamEqualTo(activity.userInfo?["subject_title"])
              .findFirst();

          if (subject != null) {
            profile?.activeSchoolyear = subject.schoolyear.value!;
            Layout.of(navKey.currentContext!)
                ?.goToPage(const GradesListScreen());
            Layout.of(navKey.currentContext!)?.goToPage(
              makeFirst: false,
              SubjectGradesScreen(
                subject: subject,
              ),
            );
          }
          break;
        case "MessageScreen":
          // Specific message
          Bericht? message = await isar.berichts
              .filter()
              .uuidEqualTo(activity.userInfo?["message_uuid"])
              .findFirst();

          message ??= await isar.berichts
              .filter()
              .idEqualTo(activity.userInfo?["message_id"])
              .onderwerpEqualTo(activity.userInfo?["message_title"])
              .findFirst();

          if (message != null) {
            Layout.of(navKey.currentContext!)
                ?.goToPage(const MessagesListScreen());
            Layout.of(navKey.currentContext!)?.goToPage(
              makeFirst: false,
              MessageScreen(message: message),
            );
          }
          break;
        case "StudieWijzerScreen":
          // Specific studiewijzer
          Studiewijzer? studiewijzer = await isar.studiewijzers
              .filter()
              .uuidEqualTo(activity.userInfo?["studiewijzer_uuid"])
              .findFirst();

          studiewijzer ??= await isar.studiewijzers
              .filter()
              .idEqualTo(activity.userInfo?["studiewijzer_id"])
              .rawTitelEqualTo(activity.userInfo?["studiewijzer_title"])
              .findFirst();

          if (studiewijzer != null) {
            Layout.of(navKey.currentContext!)
                ?.goToPage(const StudiewijzerListScreen());
            Layout.of(navKey.currentContext!)?.goToPage(
              makeFirst: false,
              StudieWijzerScreen(
                studiewijzer: studiewijzer,
              ),
            );
          }
          break;
        case "AssignmentDetailsScreen":
          // Specific assignment
          Assignment? assignment = await isar.assignments
              .filter()
              .uuidEqualTo(activity.userInfo?["assignment_uuid"])
              .findFirst();

          assignment ??= await isar.assignments
              .filter()
              .idEqualTo(activity.userInfo?["assignment_id"])
              .titelEqualTo(activity.userInfo?["assignment_title"])
              .findFirst();

          if (assignment != null) {
            Layout.of(navKey.currentContext!)
                ?.goToPage(const AssignmentListScreen());
            Layout.of(navKey.currentContext!)?.goToPage(
              makeFirst: false,
              AssignmentDetailsScreen(
                assignment: assignment,
              ),
            );
          }
          break;
        case "ActivityDetailScreen":
          // Specific activity
          Activity? mActivity = await isar.activitys
              .filter()
              .uuidEqualTo(activity.userInfo?["activity_uuid"])
              .findFirst();

          mActivity ??= await isar.activitys
              .filter()
              .idEqualTo(activity.userInfo?["activity_id"])
              .titelEqualTo(activity.userInfo?["activity_title"])
              .findFirst();

          if (mActivity != null) {
            Layout.of(navKey.currentContext!)
                ?.goToPage(const ActivitiesScreen());
            Layout.of(navKey.currentContext!)?.goToPage(
              makeFirst: false,
              ActivityDetailScreen(
                activity: mActivity,
              ),
            );
          }
          break;
        case "Bron":
          // Specific activity
          Bron? bron = await isar.brons
              .filter()
              .uuidEqualTo(activity.userInfo?["bron_UUID"])
              .findFirst();

          bron ??= await isar.brons
              .filter()
              .linksElement(
                  (q) => q.hrefEqualTo(activity.userInfo?["bron_href"]))
              .findFirst();

          if (bron != null) {
            Layout.of(navKey.currentContext!)?.goToPage(BronnenListScreen(
              forceShowedBron: bron..updateLastUsed(),
            ));

            if (bron.rawSavedPath == null) {
              await bron.download();
            }

            await bron.openFile();
          } else if (profile != null) {
            //
            //  TODO: Download bron that has not been indexed yet.
            //        This does not work yet, since some links in bronnen
            //        like the ones in projects just link to the actual file
            //        and not the bron. This means that the class `Bron` cannot
            //        be constructed. This does not have to matter, as we can
            //        just open the file directly without indexing it, but that
            //        would be rather odd, as you can only open the file once
            //        if that were the case. The entire indexing and saving the
            //        bron on the local file system would be pointless. Perhaps
            //        a snackbar could be displayed with the information that it
            //        has not been index yet.
            //

            // We do not know what the bron is, but it does seem to be
            // accessible by the current profile, so we can just downloaded it.
            // dynamic data = (await profile.account.value?.api.dio.get(
            //         options: Options(
            //           maxRedirects: 0,
            //         ),
            //         activity.userInfo?["bron_href"]
            //             .replaceAll("/api/", "")
            //             .replaceAll("/download", "")))
            //     ?.data;

            // Bron? bron = data != null && data ? Bron.fromMap(data) : null;

            // if (bron != null) {
            //   // The bron was fetched successfully! Saving...
            //   isar.writeTxnSync(() {
            //     isar.brons.putSync(bron
            //       ..profile.value = profile
            //       ..updateLastUsed());
            //   });
            //   Layout.of(navKey.currentContext!)
            //       ?.goToPage(const BronnenListScreen());
            //   await bron.download();
            //   if (!appSettings.openAfterDownload) {
            //     // We want to override the open after download setting here
            //     await bron.openFile();
            //   }
            // }
          }
          break;
        default:
          print(
              "subpage are not supported yet, but the page what was launched was called: ${activity.title}");
      }

    case "bottom-sheet":
      await showComposeMessageSheet(navKey.currentContext!);
      break;
    default:
  }
}

/// Makes sure that when a widget is focused handoff will be broadcast and
/// then, when the widget is no longer in focus, removes the broadcast.
///
/// This Widget does not do anything when handoff is not supported
class HandoffFocus extends StatelessWidget {
  const HandoffFocus(
      {super.key,
      required this.child,
      required this.activity,
      this.onForegroundGained});

  final Widget child;
  final NSUserActivity? activity;
  final Function()? onForegroundGained;

  @override
  Widget build(BuildContext context) {
    if (activity != null && (Platform.isIOS || Platform.isMacOS)) {
      return FocusOnIt(
        onForegroundGained: onForegroundGained,
        onFocus: () async {
          NSUserActivity? current =
              await FlutterAppleHandoff.getCurrentActivity;

          // We will only update the activity if it is different
          if (current?.userInfo?["screenType"] !=
                  activity?.userInfo?["screenType"] ||
              activity?.userInfo?.values.join() !=
                  current?.userInfo?.values.join()) {
            HandoffActivity.currentActivity = activity;
            await FlutterAppleHandoff.updateActivity(activity);
          }
        },
        onUnfocus: () async {
          HandoffActivity.currentActivity = null;
          // We do not want to immediately update the activity to nil, since
          // that will result in a sort of blinking on other devices using
          // handoff.
          await Future.delayed(
            const Duration(milliseconds: 500),
            () async {
              // After having waited for a bit, we will check if the activity
              // is still set to null, meaning that there has been no other view
              // that has updated the activity.
              if (HandoffActivity.currentActivity == null &&
                  await FlutterAppleHandoff.getCurrentActivity != null) {
                await FlutterAppleHandoff.updateActivity(null);
              }
            },
          );
        },
        child: child,
      );
    }

    // Handoff is not supported.
    return child;
  }
}

enum NSUserActivityTypes { rootPage, subPage, bottomSheet }

/// This class is used to construct a NSUserActivity object.
/// It contains the logic for creating a handoff activity.
class HandoffActivity extends NSUserActivity {
  HandoffActivity({
    required super.activityType,
    super.title,
    super.userInfo,
    super.isEligibleForHandoff,
  });

  static NSUserActivity? currentActivity;

  factory HandoffActivity.construct({
    NSUserActivityTypes type = NSUserActivityTypes.rootPage,
    required String title,
    int? profileUUID,
    required Type screenType,
    Map<String, dynamic>? extraInfo,
  }) {
    return HandoffActivity(
        activityType: "dev.harrydekat.discipulus.${(() {
          switch (type) {
            case NSUserActivityTypes.subPage:
              return "sub-page";
            case NSUserActivityTypes.bottomSheet:
              return "bottom-sheet";
            default:
              return "root-page";
          }
        })()}",
        isEligibleForHandoff: appSettings.useHandoff,
        title: title,
        userInfo: {
          "profileUUID": profileUUID ?? activeProfile.uuid,
          "screenType": "$screenType",
          ...?extraInfo
        });
  }
}
