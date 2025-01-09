import 'package:discipulus/api/models/messages.dart';
import 'package:discipulus/api/models/permissions.dart';
import 'package:discipulus/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apple_spotlight/flutter_apple_spotlight.dart';
import 'package:isar/isar.dart';

extension ContactExtension on Contact {
  Ontvanger get toOntvanger =>
      Ontvanger(id: id, weergavenaam: roepnaam ?? voorletters);
}

extension MessageExtension on List<Bericht> {
  /// Magister gives us the messages in parts, but since we save all the messages
  /// in one heap, that gives us a problem. We can't check if a message has been
  /// removed, since a local copy can't be simply removed if it does not exist on
  /// Magisters servers.
  ///
  /// The only way, at least as far a I know, to check if messages have been
  /// deleted or moved without making a request for each message individually is
  /// to make use of the fact that the messages are always returned in order.
  /// We can check messages between two dates and compare that to locally saved
  /// messages between those two dates that have been saved locally.
  ///
  /// The problem with this method, is that we can never be sure if the start
  /// and ending message have been removed, so those can remain in a zombie state.
  Future<void> removeChecker({bool latestIsNow = false}) async {
    // This won't work, nor will it be necessary when there are no messsages
    if (isEmpty) return;

    // Daterange of the messages that have been provided
    DateTimeRange rangeOfMessages = DateTimeRange(
        start: last.verzondenOp,
        end: latestIsNow ? DateTime.now() : first.verzondenOp);

    // Get all uuid's from locally saved messages during that time
    List<int> locallySavedMessagesUUIDs = await first.map.value!.berichten
        .filter()
        .verzondenOpBetween(rangeOfMessages.start, rangeOfMessages.end)
        .uuidProperty()
        .findAll();

    // Get all uuid's from new messages
    List<int> newMessages = map((e) => e.uuid).toList();

    // Get all the uuid's that are not part of the incoming messages and
    // probably have been moved or deleted.
    List<int> removalMarkedUUIDs = locallySavedMessagesUUIDs
        .where((e) => !newMessages.contains(e))
        .toList();

    // We will only remove messages if the removalMarkedUUIDs contains anything
    if (removalMarkedUUIDs.isNotEmpty) {
      // Remove from spolight
      CoreSpotlight.instance.deleteAll(
          identifier: removalMarkedUUIDs.map((e) => "messsage_$e").toList());
      // Remove all the messages that are marked for removal
      isar.writeTxnSync(() async {
        isar.berichts
            .filter()
            .anyOf(removalMarkedUUIDs, (q, uuid) => q.uuidEqualTo(uuid))
            .deleteAllSync();
      });
    }
  }

  /// Move all the messages in a list to a folder.
  Future<void> moveToFolder(int folderId) async {
    // Check id the user has permission
    if (first.map.value!.profile.value!.account.value?.permissions
            .hasPermissions(
          PermissionType.berichten,
          statuses: [PermissionStatus.update],
        ) ??
        false) {
      List<Bericht> messages = where((e) => e.id != -1).toList();

      // Move messages in the API
      await first.map.value!.profile.value!.account.value!.api.messages
          .moveToFolder(messages, folderId: folderId);

      // Update the map on the object
      MessagesFolder? map = await first.map.value!.profile.value?.berichtMappen
          .filter()
          .idEqualTo(folderId)
          .findFirst();

      for (Bericht message in messages) {
        message.map.value = map;
      }

      // Update the database
      isar.writeTxnSync(() {
        isar.berichts.putAllSync(messages);
        map?.berichten.saveSync();
      });
    }
  }

  ///Move the message to the removed messages folder
  Future<void> removeMessages() async {
    // Check id the user has permission
    if (first.map.value!.profile.value!.account.value?.permissions
            .hasPermissions(
          PermissionType.berichten,
          statuses: [PermissionStatus.delete],
        ) ??
        false) {
      // Filter out messages that are from the concept folder, since these
      // cannot be moved.
      List<Bericht> messages = where((e) => e.id != -1).toList();

      // Only if every message is from the bin (which has id 3), will we remove
      // the messages permanently.
      bool permanentlyDelete = messages.every((e) => e.mapId == 3);

      if (permanentlyDelete) {
        await first.map.value!.profile.value!.account.value!.api.messages
            .remove(messages);

        // Update spotlight
        for (Bericht message in messages) {
          message.removeFromSpotlight();
        }

        // Remove messages from database.
        isar.writeTxnSync(() async {
          isar.berichts.filter().anyOf(
            [for (Bericht message in messages) message.uuid],
            (q, uuid) => q.uuidEqualTo(uuid),
          ).deleteFirstSync();
        });
      } else {
        // Move messages in the API. We cannot move concepts, but these are
        // removed my the moveToFolder function.
        messages.moveToFolder(3);
      }
    }
  }

  Future<void> markAsRead({required bool read}) async {
    if (first.map.value!.profile.value!.account.value?.permissions
            .hasPermissions(
          PermissionType.berichten,
          statuses: [PermissionStatus.update],
        ) ??
        false) {
      // Update the messages though the API
      await first.map.value!.profile.value!.account.value!.api.messages
          .markAsRead(this, read: read);

      // Save to the database
      isar.writeTxnSync(() {
        isar.berichts.putAllSync(
          map((e) => e..isGelezen = read).toList(),
        );
      });
    }
  }

  //       if (!id.isNegative) {
  //     if (!(map.value!.profile.value!.account.value?.permissions.hasPermissions(
  //             PermissionType.berichten,
  //             statuses: [PermissionStatus.update]) ??
  //         false)) {
  //       return;
  //     }

  //     await map.value!.profile.value!.account.value!.api.messages
  //         .moveToFolder([this], folderId: folderId);

  //     // await map.value!.profile.value!.account.value!.api.dio
  //     //     .patch("/berichten/berichten", data: {
  //     //   "berichten": [
  //     //     {
  //     //       "berichtId": id,
  //     //       "operations": [
  //     //         {"op": "replace", "path": "/MapId", "value": folderId}
  //     //       ]
  //     //     }
  //     //   ]
  //     // });
  //   }
  //   map.value = await map.value?.profile.value?.berichtMappen
  //       .filter()
  //       .idEqualTo(folderId)
  //       .findFirst();
  //   isar.writeTxnSync(() {
  //     isar.berichts.putSync(this);
  //     map.value?.berichten.saveSync();
  //   });
  // }
}
