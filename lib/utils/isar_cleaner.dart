import 'dart:async';
import 'package:discipulus/main.dart';
import 'package:isar/isar.dart';

extension RemovalExtension<T> on IsarCollection<T> {
  Future<void> removeChecker(
      {required Future<Iterable<int>> localUUIDs,
      required Future<Iterable<int>> newUUIDs,
      required Function(QueryBuilder<T, T, QFilterCondition> q, int uuid)
          findUUIDs,
      FutureOr<void> Function(List<T> deathRow)? beforeRemoval}) async {
    Iterable<int> localIDs, newIDs;
    List<Iterable<int>> data = await Future.wait([localUUIDs, newUUIDs]);
    localIDs = data.first;
    newIDs = data.last;

    // If there are id's in the localUUIDs list that are not in the new list
    // the event has probably been removed.
    List<int> removalMarkedIDs =
        localIDs.where((e) => !newIDs.contains(e)).toList();

    // Remove the id's marked for removal
    if (removalMarkedIDs.isNotEmpty) {
      QueryBuilder<T, T, QAfterFilterCondition> builder = filter().anyOf(
        removalMarkedIDs,
        (q, uuid) => findUUIDs.call(q, uuid),
      );
      List<T> deathRow = await builder.findAll();
      if (beforeRemoval != null) {
        await beforeRemoval(deathRow);
      }
      await isar.writeTxn(() async {
        await builder.deleteAll();
      });
    }
  }
}
