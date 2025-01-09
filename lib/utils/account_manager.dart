import 'package:discipulus/core/routes.dart';
import 'package:discipulus/widgets/global/layout.dart';
import 'package:isar/isar.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/models/settings.dart';

/// Gets the current active account
Profile get activeProfile {
  if (appSettings.activeProfileUuid != null) {
    Profile? profile =
        isar.profiles.getSync(appSettings.activeProfileUuid ?? 0) ??
            isar.profiles.filter().not().accountIsNull().findFirstSync();

    if (profile == null) {
      // Something has gone wrong, no account exists, but an activeProfileUuid
      // has been set. We will reset the activeProfileUuid, so the login prompt
      // will be displayed.
      appSettings
        ..activeProfileUuid = null
        ..save();
    }

    return profile!;
  } else {
    List<Profile>? profiles =
        isar.profiles.filter().not().accountIsNull().findAllSync();

    if (profiles.isNotEmpty) {
      // There are profiles, but no active profile has been set, so we will set
      // the first one as active.
      activeProfile = profiles.first;
    }

    // Return the first profile
    return profiles.first;
  }
}

/// Sets the new active account
set activeProfile(Profile profile) {
  if (appSettings.activeProfileUuid != profile.uuid) {
    // Set new uuid
    appSettings
      ..activeProfileUuid = profile.uuid
      ..save();

    // Update the drawer
    Layout.of(navKey.currentContext!)?.update(profile);
  }
}

/// Can be used to loop though the available profiles.
/// This will do nothing if there is only one profile.
Future<void> nextActiveProfile({int steps = 1}) async {
  List<int> currentProfileIndex = await isar.profiles
      .filter()
      .not()
      .accountIsNull()
      .sortById()
      .uuidProperty()
      .findAll();
  int currentIndex =
      currentProfileIndex.indexWhere((e) => e == activeProfile.uuid);
  int newAccountUUID = currentProfileIndex[((currentIndex + steps).isNegative
          ? (currentIndex + steps) * -1
          : (currentIndex + steps)) %
      currentProfileIndex.length];
  // Set new active profile
  activeProfile =
      (await isar.profiles.filter().uuidEqualTo(newAccountUUID).findFirst())!;
}
