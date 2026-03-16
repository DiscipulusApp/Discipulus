import 'package:collection/collection.dart';
import 'package:discipulus/api/models/account.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:isar/isar.dart';

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
  }
}
