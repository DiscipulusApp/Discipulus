import 'package:collection/collection.dart';
import 'package:discipulus/api/models/account.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:isar/isar.dart';
import 'package:discipulus/api/models/grades.dart';

class AccountMigration {
  /// Checks if there are any accounts that do not have a magisterUuid set.
  /// If so, it will try to fetch the uuid from the API and save it.
  static Future<void> checkAndMigrateAccounts() async {
    // Get all accounts
    List<DiscipulusAccount> accounts =
        await isar.discipulusAccounts.where().findAll();

    for (DiscipulusAccount account in accounts) {
      try {
        await account.profiles.load();
        bool accountNeedsSave = false;

        ApiAccount? apiAccount;

        // 1. Migrate magisterUuid if missing
        if (account.magisterUuid == null) {
          apiAccount = await account.api.account;
          account.magisterUuid = apiAccount.uuid;
          accountNeedsSave = true;
          print("Migrated UUID for account ${account.id}");
        }

        // 2. Migrate birthdate for profiles if missing
        for (Profile profile in account.profiles) {
          if (profile.birthdate == null) {
            apiAccount ??= await account.api.account;

            if (profile.id == apiAccount.persoon.id) {
              // Main profile
              profile.birthdate = apiAccount.persoon.geboortedatum;
            } else {
              // It's likely a child (for parent accounts)
              var children =
                  await account.api.person(apiAccount.persoon.id).children;
              var child = children.firstWhereOrNull((c) => c.id == profile.id);
              if (child != null) {
                profile.birthdate = child.geboortedatum;
              }
            }

            if (profile.birthdate != null) {
              isar.writeTxnSync(() => isar.profiles.putSync(profile));
              print("Migrated birthdate for profile ${profile.name}");
            }
          }
        }

        if (accountNeedsSave) {
          account.save();
        }
      } catch (e) {
        print("Failed to migrate account ${account.id}: $e");
      }
    }

    // Migrate pre-existing grades to revealed state to prevent a giant backlog on first launch after update.
    // On the first launch after the update, all existing grades in the database default to wasRevealed = false.
    // This means 100% of the grades are unrevealed (unrevealedCount == totalGrades).
    // Once any grade is revealed or newly synced, this condition becomes false and the migration never runs again.
    try {
      final unrevealedCount = await isar.grades.filter().wasRevealedEqualTo(false).count();
      final totalGrades = await isar.grades.count();
      if (totalGrades > 0 && unrevealedCount == totalGrades) {
        final allUnrevealed = await isar.grades.filter().wasRevealedEqualTo(false).findAll();
        await isar.writeTxn(() async {
          for (var grade in allUnrevealed) {
            grade.wasRevealed = true;
          }
          await isar.grades.putAll(allUnrevealed);
        });
        print("Migrated ${allUnrevealed.length} old grades to 'revealed' state.");
      }
    } catch (e) {
      print("Failed to migrate old grades wasRevealed state: $e");
    }
  }
}
