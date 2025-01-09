import 'dart:io';
import 'package:discipulus/api/models/messages.dart';
import 'package:discipulus/api/models/studiewijzers.dart';
import 'package:discipulus/core/routes.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/screens/messages/message_details.dart';
import 'package:discipulus/screens/messages/messages.dart';
import 'package:discipulus/screens/studiewijzers/studiewijzer_details.dart';
import 'package:discipulus/screens/studiewijzers/studiewijzers.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/global/layout.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_apple_spotlight/flutter_apple_spotlight.dart';
import 'package:isar/isar.dart';

/// Adds spotlight integration for a class
mixin SpotlightSearchElementMixin {
  /// The item that will appear in spotlight search on iOS and macOS.
  /// If null, the item will not appear
  @ignore
  SpotlightSearchElement? get spotlightItem;

  Future<void> removeFromSpotlight() async {
    if (spotlightItem != null && (Platform.isMacOS || Platform.isIOS)) {
      await CoreSpotlight.instance
          .deleteAll(identifier: [spotlightItem!.uniqueIdentifier!]);
    }
  }

  /// Updates the current item in spotlight.
  Future<void> updateSpotlight() async {
    if (spotlightItem != null && (Platform.isMacOS || Platform.isIOS)) {
      removeFromSpotlight();
      await CoreSpotlight.instance.indexSearchableItems([spotlightItem!]);
    }
  }
}

/// The default Spotlight item
class SpotlightSearchElement extends CoreSpotlightItem {
  SpotlightSearchElement({
    required super.uniqueIdentifier,
    super.domainIdentifier = "dev.harrydekat.discipulus",
    required super.attributeSet,
    super.expirationDate,
    super.isUpdate,
  }) : super();
}

void initSpotlight() => (Platform.isMacOS || Platform.isIOS)
    ? CoreSpotlight.instance.init(
        callback: (item) async {
          switch (item.uniqueIdentifier.split("_").first) {
            case "studiewijzer":
              // Go to a certain studiewijzer
              int uuid = int.parse(item.uniqueIdentifier.split("_").last);
              Studiewijzer? studiewijzer = await isar.studiewijzers
                  .filter()
                  .uuidEqualTo(uuid)
                  .findFirst();
              if (studiewijzer != null &&
                  navKey.currentState?.currentRouteName !=
                      item.uniqueIdentifier) {
                activeProfile = studiewijzer.profile.value!;
                Layout.of(navKey.currentContext!)
                    ?.goToPage(const StudiewijzerListScreen());
                Layout.of(navKey.currentContext!)?.goToPage(
                  routeName: item.uniqueIdentifier,
                  StudieWijzerScreen(studiewijzer: studiewijzer),
                  makeFirst: false,
                );
              }
            case "message":
              // Go to a certain messsage
              int uuid = int.parse(item.uniqueIdentifier.split("_").last);
              Bericht? message =
                  await isar.berichts.filter().uuidEqualTo(uuid).findFirst();
              if (message != null &&
                  navKey.currentState?.currentRouteName !=
                      item.uniqueIdentifier) {
                activeProfile = message.map.value!.profile.value!;
                Layout.of(navKey.currentContext!)
                    ?.goToPage(const MessagesListScreen());
                Layout.of(navKey.currentContext!)?.goToPage(
                  routeName: item.uniqueIdentifier,
                  MessageScreen(message: message),
                  makeFirst: false,
                );
              }

              break;
            default:
          }
        },
      )
    : () {
        if (kDebugMode) print("Spotlight is not available on this platform!");
      };
