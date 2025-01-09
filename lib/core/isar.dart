part of '../main.dart';

late final Isar isar;

final List<CollectionSchema<dynamic>> schemas = [
  SettingsSchema,
  ProfileSchema,
  DiscipulusAccountSchema,
  CalendarEventSchema,
  AssignmentSchema,
  AssignmentVersionSchema,
  BronSchema,
  StudiewijzerSchema,
  StudiewijzerOnderdeelSchema,
  BerichtSchema,
  MessagesFolderSchema,
  SchoolyearSchema,
  GradeSchema,
  GradePeriodSchema,
  SubjectSchema,
  ActivitySchema,
  ActivityElementSchema,
  ExternalBronSourceSchema,
];

Future<void> initIsar([disableInspector = false]) async {
  // We do not want to initiate isar multiple times, so we will only initiate it
  // when the storage DIR is set to null.
  if (storageDir == null) {
    try {
      storageDir = await getApplicationSupportDirectory();
    } on Exception catch (_) {
      // Linux!
      storageDir = Directory.current;
    }

    if (kDebugMode) {
      print("Isar was initiated on path \"${storageDir?.path}\"");
    }

    isar = await Isar.open(
      schemas,
      directory: storageDir!.path,
      inspector: !disableInspector && kDebugMode,
    );
  }
}
