import 'package:discipulus/api/models/account.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:isar/isar.dart';

class AccountMigration {
  /// Checks if there are any accounts that do not have a magisterUuid set.
  /// If so, it will try to fetch the uuid from the API and save it.
  static Future<void> checkAndMigrateAccounts() async {
    // Get all accounts that do not have a magisterUuid
    List<DiscipulusAccount> accounts =
        await isar.discipulusAccounts.filter().magisterUuidIsNull().findAll();

    for (DiscipulusAccount account in accounts) {
      try {
        // Fetch the account info from the API
        // This will implicitly use the tokenSet of the account
        ApiAccount apiAccount = await account.api.account;
        account.magisterUuid = apiAccount.uuid;
        account.save();
        print("Migrated account ${account.id}");
        // The fill method already saves the account, so we don't need to do that here
      } catch (e) {
        print("Failed to migrate account ${account.id}: $e");
      }
    }
  }
}
