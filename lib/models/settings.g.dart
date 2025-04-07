// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSettingsCollection on Isar {
  IsarCollection<Settings> get settings => this.collection();
}

const SettingsSchema = CollectionSchema(
  name: r'Settings',
  id: -8656046621518759136,
  properties: {
    r'activeMaterialYouColorInt': PropertySchema(
      id: 0,
      name: r'activeMaterialYouColorInt',
      type: IsarType.long,
    ),
    r'activeProfileUuid': PropertySchema(
      id: 1,
      name: r'activeProfileUuid',
      type: IsarType.long,
    ),
    r'activeProfileUuidWidgets': PropertySchema(
      id: 2,
      name: r'activeProfileUuidWidgets',
      type: IsarType.long,
    ),
    r'alarms': PropertySchema(
      id: 3,
      name: r'alarms',
      type: IsarType.objectList,
      target: r'AndroidAlarm',
    ),
    r'autoRemoveDate': PropertySchema(
      id: 4,
      name: r'autoRemoveDate',
      type: IsarType.long,
    ),
    r'brightness': PropertySchema(
      id: 5,
      name: r'brightness',
      type: IsarType.byte,
      enumMap: _SettingsbrightnessEnumValueMap,
    ),
    r'coloredFinishedTests': PropertySchema(
      id: 6,
      name: r'coloredFinishedTests',
      type: IsarType.bool,
    ),
    r'coloredsufficientFromLine': PropertySchema(
      id: 7,
      name: r'coloredsufficientFromLine',
      type: IsarType.bool,
    ),
    r'combineDoublePeriods': PropertySchema(
      id: 8,
      name: r'combineDoublePeriods',
      type: IsarType.bool,
    ),
    r'curvedGraphs': PropertySchema(
      id: 9,
      name: r'curvedGraphs',
      type: IsarType.bool,
    ),
    r'dndTurnedOnTime': PropertySchema(
      id: 10,
      name: r'dndTurnedOnTime',
      type: IsarType.dateTime,
    ),
    r'drawerOnBack': PropertySchema(
      id: 11,
      name: r'drawerOnBack',
      type: IsarType.bool,
    ),
    r'drawerOpenOnRight': PropertySchema(
      id: 12,
      name: r'drawerOpenOnRight',
      type: IsarType.bool,
    ),
    r'enabledGradeBadgeTypes': PropertySchema(
      id: 13,
      name: r'enabledGradeBadgeTypes',
      type: IsarType.byteList,
      enumMap: _SettingsenabledGradeBadgeTypesEnumValueMap,
    ),
    r'geminiAPIKey': PropertySchema(
      id: 14,
      name: r'geminiAPIKey',
      type: IsarType.string,
    ),
    r'openAfterDownload': PropertySchema(
      id: 15,
      name: r'openAfterDownload',
      type: IsarType.bool,
    ),
    r'saveVirtualFiles': PropertySchema(
      id: 16,
      name: r'saveVirtualFiles',
      type: IsarType.bool,
    ),
    r'sendCrashInfo': PropertySchema(
      id: 17,
      name: r'sendCrashInfo',
      type: IsarType.bool,
    ),
    r'sharePersonalInformationWithGemini': PropertySchema(
      id: 18,
      name: r'sharePersonalInformationWithGemini',
      type: IsarType.bool,
    ),
    r'shortBronTitle': PropertySchema(
      id: 19,
      name: r'shortBronTitle',
      type: IsarType.bool,
    ),
    r'showAutoCancelledEvents': PropertySchema(
      id: 20,
      name: r'showAutoCancelledEvents',
      type: IsarType.bool,
    ),
    r'showBronExtension': PropertySchema(
      id: 21,
      name: r'showBronExtension',
      type: IsarType.bool,
    ),
    r'showCalcCardsInGlobalAverageList': PropertySchema(
      id: 22,
      name: r'showCalcCardsInGlobalAverageList',
      type: IsarType.bool,
    ),
    r'showEmptySpaceBetweenLessons': PropertySchema(
      id: 23,
      name: r'showEmptySpaceBetweenLessons',
      type: IsarType.bool,
    ),
    r'subjectSortType': PropertySchema(
      id: 24,
      name: r'subjectSortType',
      type: IsarType.byte,
      enumMap: _SettingssubjectSortTypeEnumValueMap,
    ),
    r'themeVariant': PropertySchema(
      id: 25,
      name: r'themeVariant',
      type: IsarType.byte,
      enumMap: _SettingsthemeVariantEnumValueMap,
    ),
    r'useHandoff': PropertySchema(
      id: 26,
      name: r'useHandoff',
      type: IsarType.bool,
    ),
    r'useMaterialYou': PropertySchema(
      id: 27,
      name: r'useMaterialYou',
      type: IsarType.bool,
    ),
    r'workWeek': PropertySchema(
      id: 28,
      name: r'workWeek',
      type: IsarType.bool,
    ),
    r'zoomLineGraph': PropertySchema(
      id: 29,
      name: r'zoomLineGraph',
      type: IsarType.bool,
    )
  },
  estimateSize: _settingsEstimateSize,
  serialize: _settingsSerialize,
  deserialize: _settingsDeserialize,
  deserializeProp: _settingsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'AndroidAlarm': AndroidAlarmSchema},
  getId: _settingsGetId,
  getLinks: _settingsGetLinks,
  attach: _settingsAttach,
  version: '3.1.0+1',
);

int _settingsEstimateSize(
  Settings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.alarms.length * 3;
  {
    final offsets = allOffsets[AndroidAlarm]!;
    for (var i = 0; i < object.alarms.length; i++) {
      final value = object.alarms[i];
      bytesCount += AndroidAlarmSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.enabledGradeBadgeTypes.length;
  {
    final value = object.geminiAPIKey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _settingsSerialize(
  Settings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.activeMaterialYouColorInt);
  writer.writeLong(offsets[1], object.activeProfileUuid);
  writer.writeLong(offsets[2], object.activeProfileUuidWidgets);
  writer.writeObjectList<AndroidAlarm>(
    offsets[3],
    allOffsets,
    AndroidAlarmSchema.serialize,
    object.alarms,
  );
  writer.writeLong(offsets[4], object.autoRemoveDate);
  writer.writeByte(offsets[5], object.brightness.index);
  writer.writeBool(offsets[6], object.coloredFinishedTests);
  writer.writeBool(offsets[7], object.coloredsufficientFromLine);
  writer.writeBool(offsets[8], object.combineDoublePeriods);
  writer.writeBool(offsets[9], object.curvedGraphs);
  writer.writeDateTime(offsets[10], object.dndTurnedOnTime);
  writer.writeBool(offsets[11], object.drawerOnBack);
  writer.writeBool(offsets[12], object.drawerOpenOnRight);
  writer.writeByteList(
      offsets[13], object.enabledGradeBadgeTypes.map((e) => e.index).toList());
  writer.writeString(offsets[14], object.geminiAPIKey);
  writer.writeBool(offsets[15], object.openAfterDownload);
  writer.writeBool(offsets[16], object.saveVirtualFiles);
  writer.writeBool(offsets[17], object.sendCrashInfo);
  writer.writeBool(offsets[18], object.sharePersonalInformationWithGemini);
  writer.writeBool(offsets[19], object.shortBronTitle);
  writer.writeBool(offsets[20], object.showAutoCancelledEvents);
  writer.writeBool(offsets[21], object.showBronExtension);
  writer.writeBool(offsets[22], object.showCalcCardsInGlobalAverageList);
  writer.writeBool(offsets[23], object.showEmptySpaceBetweenLessons);
  writer.writeByte(offsets[24], object.subjectSortType.index);
  writer.writeByte(offsets[25], object.themeVariant.index);
  writer.writeBool(offsets[26], object.useHandoff);
  writer.writeBool(offsets[27], object.useMaterialYou);
  writer.writeBool(offsets[28], object.workWeek);
  writer.writeBool(offsets[29], object.zoomLineGraph);
}

Settings _settingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Settings();
  object.activeMaterialYouColorInt = reader.readLong(offsets[0]);
  object.activeProfileUuid = reader.readLongOrNull(offsets[1]);
  object.activeProfileUuidWidgets = reader.readLongOrNull(offsets[2]);
  object.alarms = reader.readObjectList<AndroidAlarm>(
        offsets[3],
        AndroidAlarmSchema.deserialize,
        allOffsets,
        AndroidAlarm(),
      ) ??
      [];
  object.autoRemoveDate = reader.readLong(offsets[4]);
  object.brightness =
      _SettingsbrightnessValueEnumMap[reader.readByteOrNull(offsets[5])] ??
          ThemeBrightness.system;
  object.coloredFinishedTests = reader.readBool(offsets[6]);
  object.coloredsufficientFromLine = reader.readBool(offsets[7]);
  object.combineDoublePeriods = reader.readBool(offsets[8]);
  object.curvedGraphs = reader.readBool(offsets[9]);
  object.dndTurnedOnTime = reader.readDateTimeOrNull(offsets[10]);
  object.drawerOnBack = reader.readBool(offsets[11]);
  object.drawerOpenOnRight = reader.readBool(offsets[12]);
  object.enabledGradeBadgeTypes = reader
          .readByteList(offsets[13])
          ?.map((e) =>
              _SettingsenabledGradeBadgeTypesValueEnumMap[e] ??
              GradeBadgeTypes.weight)
          .toList() ??
      [];
  object.geminiAPIKey = reader.readStringOrNull(offsets[14]);
  object.id = id;
  object.openAfterDownload = reader.readBool(offsets[15]);
  object.saveVirtualFiles = reader.readBool(offsets[16]);
  object.sendCrashInfo = reader.readBool(offsets[17]);
  object.sharePersonalInformationWithGemini = reader.readBool(offsets[18]);
  object.shortBronTitle = reader.readBool(offsets[19]);
  object.showAutoCancelledEvents = reader.readBool(offsets[20]);
  object.showBronExtension = reader.readBool(offsets[21]);
  object.showCalcCardsInGlobalAverageList = reader.readBool(offsets[22]);
  object.showEmptySpaceBetweenLessons = reader.readBool(offsets[23]);
  object.subjectSortType = _SettingssubjectSortTypeValueEnumMap[
          reader.readByteOrNull(offsets[24])] ??
      SubjectSortType.alphabetical;
  object.themeVariant =
      _SettingsthemeVariantValueEnumMap[reader.readByteOrNull(offsets[25])] ??
          ThemeVariant.system;
  object.useHandoff = reader.readBool(offsets[26]);
  object.useMaterialYou = reader.readBoolOrNull(offsets[27]);
  object.workWeek = reader.readBool(offsets[28]);
  object.zoomLineGraph = reader.readBool(offsets[29]);
  return object;
}

P _settingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readObjectList<AndroidAlarm>(
            offset,
            AndroidAlarmSchema.deserialize,
            allOffsets,
            AndroidAlarm(),
          ) ??
          []) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (_SettingsbrightnessValueEnumMap[reader.readByteOrNull(offset)] ??
          ThemeBrightness.system) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader
              .readByteList(offset)
              ?.map((e) =>
                  _SettingsenabledGradeBadgeTypesValueEnumMap[e] ??
                  GradeBadgeTypes.weight)
              .toList() ??
          []) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readBool(offset)) as P;
    case 16:
      return (reader.readBool(offset)) as P;
    case 17:
      return (reader.readBool(offset)) as P;
    case 18:
      return (reader.readBool(offset)) as P;
    case 19:
      return (reader.readBool(offset)) as P;
    case 20:
      return (reader.readBool(offset)) as P;
    case 21:
      return (reader.readBool(offset)) as P;
    case 22:
      return (reader.readBool(offset)) as P;
    case 23:
      return (reader.readBool(offset)) as P;
    case 24:
      return (_SettingssubjectSortTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          SubjectSortType.alphabetical) as P;
    case 25:
      return (_SettingsthemeVariantValueEnumMap[
              reader.readByteOrNull(offset)] ??
          ThemeVariant.system) as P;
    case 26:
      return (reader.readBool(offset)) as P;
    case 27:
      return (reader.readBoolOrNull(offset)) as P;
    case 28:
      return (reader.readBool(offset)) as P;
    case 29:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _SettingsbrightnessEnumValueMap = {
  'system': 0,
  'dark': 1,
  'light': 2,
};
const _SettingsbrightnessValueEnumMap = {
  0: ThemeBrightness.system,
  1: ThemeBrightness.dark,
  2: ThemeBrightness.light,
};
const _SettingsenabledGradeBadgeTypesEnumValueMap = {
  'weight': 0,
  'date': 1,
  'pta': 2,
  'change': 3,
  'globalChange': 4,
};
const _SettingsenabledGradeBadgeTypesValueEnumMap = {
  0: GradeBadgeTypes.weight,
  1: GradeBadgeTypes.date,
  2: GradeBadgeTypes.pta,
  3: GradeBadgeTypes.change,
  4: GradeBadgeTypes.globalChange,
};
const _SettingssubjectSortTypeEnumValueMap = {
  'alphabetical': 0,
  'recentGrade': 1,
  'highestAverage': 2,
  'amountOfGrades': 3,
  'magister': 4,
  'none': 5,
};
const _SettingssubjectSortTypeValueEnumMap = {
  0: SubjectSortType.alphabetical,
  1: SubjectSortType.recentGrade,
  2: SubjectSortType.highestAverage,
  3: SubjectSortType.amountOfGrades,
  4: SubjectSortType.magister,
  5: SubjectSortType.none,
};
const _SettingsthemeVariantEnumValueMap = {
  'system': 0,
  'tonalSpot': 1,
  'fidelity': 2,
  'monochrome': 3,
  'neutral': 4,
  'vibrant': 5,
  'expressive': 6,
  'content': 7,
  'rainbow': 8,
  'fruitSalad': 9,
};
const _SettingsthemeVariantValueEnumMap = {
  0: ThemeVariant.system,
  1: ThemeVariant.tonalSpot,
  2: ThemeVariant.fidelity,
  3: ThemeVariant.monochrome,
  4: ThemeVariant.neutral,
  5: ThemeVariant.vibrant,
  6: ThemeVariant.expressive,
  7: ThemeVariant.content,
  8: ThemeVariant.rainbow,
  9: ThemeVariant.fruitSalad,
};

Id _settingsGetId(Settings object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _settingsGetLinks(Settings object) {
  return [];
}

void _settingsAttach(IsarCollection<dynamic> col, Id id, Settings object) {
  object.id = id;
}

extension SettingsQueryWhereSort on QueryBuilder<Settings, Settings, QWhere> {
  QueryBuilder<Settings, Settings, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SettingsQueryWhere on QueryBuilder<Settings, Settings, QWhereClause> {
  QueryBuilder<Settings, Settings, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Settings, Settings, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SettingsQueryFilter
    on QueryBuilder<Settings, Settings, QFilterCondition> {
  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      activeMaterialYouColorIntEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activeMaterialYouColorInt',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      activeMaterialYouColorIntGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activeMaterialYouColorInt',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      activeMaterialYouColorIntLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activeMaterialYouColorInt',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      activeMaterialYouColorIntBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activeMaterialYouColorInt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      activeProfileUuidIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activeProfileUuid',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      activeProfileUuidIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activeProfileUuid',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      activeProfileUuidEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activeProfileUuid',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      activeProfileUuidGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activeProfileUuid',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      activeProfileUuidLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activeProfileUuid',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      activeProfileUuidBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activeProfileUuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      activeProfileUuidWidgetsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activeProfileUuidWidgets',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      activeProfileUuidWidgetsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activeProfileUuidWidgets',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      activeProfileUuidWidgetsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activeProfileUuidWidgets',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      activeProfileUuidWidgetsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activeProfileUuidWidgets',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      activeProfileUuidWidgetsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activeProfileUuidWidgets',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      activeProfileUuidWidgetsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activeProfileUuidWidgets',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> alarmsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'alarms',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> alarmsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'alarms',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> alarmsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'alarms',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> alarmsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'alarms',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      alarmsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'alarms',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> alarmsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'alarms',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> autoRemoveDateEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'autoRemoveDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      autoRemoveDateGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'autoRemoveDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      autoRemoveDateLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'autoRemoveDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> autoRemoveDateBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'autoRemoveDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> brightnessEqualTo(
      ThemeBrightness value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'brightness',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> brightnessGreaterThan(
    ThemeBrightness value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'brightness',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> brightnessLessThan(
    ThemeBrightness value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'brightness',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> brightnessBetween(
    ThemeBrightness lower,
    ThemeBrightness upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'brightness',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      coloredFinishedTestsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coloredFinishedTests',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      coloredsufficientFromLineEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coloredsufficientFromLine',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      combineDoublePeriodsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'combineDoublePeriods',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> curvedGraphsEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'curvedGraphs',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      dndTurnedOnTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dndTurnedOnTime',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      dndTurnedOnTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dndTurnedOnTime',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      dndTurnedOnTimeEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dndTurnedOnTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      dndTurnedOnTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dndTurnedOnTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      dndTurnedOnTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dndTurnedOnTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      dndTurnedOnTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dndTurnedOnTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> drawerOnBackEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'drawerOnBack',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      drawerOpenOnRightEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'drawerOpenOnRight',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      enabledGradeBadgeTypesElementEqualTo(GradeBadgeTypes value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enabledGradeBadgeTypes',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      enabledGradeBadgeTypesElementGreaterThan(
    GradeBadgeTypes value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'enabledGradeBadgeTypes',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      enabledGradeBadgeTypesElementLessThan(
    GradeBadgeTypes value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'enabledGradeBadgeTypes',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      enabledGradeBadgeTypesElementBetween(
    GradeBadgeTypes lower,
    GradeBadgeTypes upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'enabledGradeBadgeTypes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      enabledGradeBadgeTypesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'enabledGradeBadgeTypes',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      enabledGradeBadgeTypesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'enabledGradeBadgeTypes',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      enabledGradeBadgeTypesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'enabledGradeBadgeTypes',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      enabledGradeBadgeTypesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'enabledGradeBadgeTypes',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      enabledGradeBadgeTypesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'enabledGradeBadgeTypes',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      enabledGradeBadgeTypesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'enabledGradeBadgeTypes',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> geminiAPIKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'geminiAPIKey',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      geminiAPIKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'geminiAPIKey',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> geminiAPIKeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'geminiAPIKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      geminiAPIKeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'geminiAPIKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> geminiAPIKeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'geminiAPIKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> geminiAPIKeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'geminiAPIKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      geminiAPIKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'geminiAPIKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> geminiAPIKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'geminiAPIKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> geminiAPIKeyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'geminiAPIKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> geminiAPIKeyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'geminiAPIKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      geminiAPIKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'geminiAPIKey',
        value: '',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      geminiAPIKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'geminiAPIKey',
        value: '',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      openAfterDownloadEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'openAfterDownload',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      saveVirtualFilesEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'saveVirtualFiles',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> sendCrashInfoEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sendCrashInfo',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      sharePersonalInformationWithGeminiEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sharePersonalInformationWithGemini',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> shortBronTitleEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shortBronTitle',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      showAutoCancelledEventsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showAutoCancelledEvents',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      showBronExtensionEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showBronExtension',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      showCalcCardsInGlobalAverageListEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showCalcCardsInGlobalAverageList',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      showEmptySpaceBetweenLessonsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showEmptySpaceBetweenLessons',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      subjectSortTypeEqualTo(SubjectSortType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subjectSortType',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      subjectSortTypeGreaterThan(
    SubjectSortType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subjectSortType',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      subjectSortTypeLessThan(
    SubjectSortType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subjectSortType',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      subjectSortTypeBetween(
    SubjectSortType lower,
    SubjectSortType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subjectSortType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> themeVariantEqualTo(
      ThemeVariant value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'themeVariant',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      themeVariantGreaterThan(
    ThemeVariant value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'themeVariant',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> themeVariantLessThan(
    ThemeVariant value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'themeVariant',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> themeVariantBetween(
    ThemeVariant lower,
    ThemeVariant upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'themeVariant',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> useHandoffEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'useHandoff',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      useMaterialYouIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'useMaterialYou',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      useMaterialYouIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'useMaterialYou',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> useMaterialYouEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'useMaterialYou',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> workWeekEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> zoomLineGraphEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'zoomLineGraph',
        value: value,
      ));
    });
  }
}

extension SettingsQueryObject
    on QueryBuilder<Settings, Settings, QFilterCondition> {
  QueryBuilder<Settings, Settings, QAfterFilterCondition> alarmsElement(
      FilterQuery<AndroidAlarm> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'alarms');
    });
  }
}

extension SettingsQueryLinks
    on QueryBuilder<Settings, Settings, QFilterCondition> {}

extension SettingsQuerySortBy on QueryBuilder<Settings, Settings, QSortBy> {
  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByActiveMaterialYouColorInt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeMaterialYouColorInt', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByActiveMaterialYouColorIntDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeMaterialYouColorInt', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByActiveProfileUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeProfileUuid', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByActiveProfileUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeProfileUuid', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByActiveProfileUuidWidgets() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeProfileUuidWidgets', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByActiveProfileUuidWidgetsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeProfileUuidWidgets', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAutoRemoveDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoRemoveDate', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAutoRemoveDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoRemoveDate', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByBrightness() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'brightness', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByBrightnessDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'brightness', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByColoredFinishedTests() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coloredFinishedTests', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByColoredFinishedTestsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coloredFinishedTests', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByColoredsufficientFromLine() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coloredsufficientFromLine', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByColoredsufficientFromLineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coloredsufficientFromLine', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByCombineDoublePeriods() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'combineDoublePeriods', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByCombineDoublePeriodsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'combineDoublePeriods', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByCurvedGraphs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'curvedGraphs', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByCurvedGraphsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'curvedGraphs', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDndTurnedOnTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dndTurnedOnTime', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDndTurnedOnTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dndTurnedOnTime', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDrawerOnBack() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'drawerOnBack', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDrawerOnBackDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'drawerOnBack', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDrawerOpenOnRight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'drawerOpenOnRight', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDrawerOpenOnRightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'drawerOpenOnRight', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByGeminiAPIKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geminiAPIKey', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByGeminiAPIKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geminiAPIKey', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByOpenAfterDownload() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openAfterDownload', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByOpenAfterDownloadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openAfterDownload', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortBySaveVirtualFiles() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saveVirtualFiles', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortBySaveVirtualFilesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saveVirtualFiles', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortBySendCrashInfo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sendCrashInfo', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortBySendCrashInfoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sendCrashInfo', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortBySharePersonalInformationWithGemini() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sharePersonalInformationWithGemini', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortBySharePersonalInformationWithGeminiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sharePersonalInformationWithGemini', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByShortBronTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shortBronTitle', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByShortBronTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shortBronTitle', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByShowAutoCancelledEvents() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showAutoCancelledEvents', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByShowAutoCancelledEventsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showAutoCancelledEvents', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByShowBronExtension() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showBronExtension', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByShowBronExtensionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showBronExtension', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByShowCalcCardsInGlobalAverageList() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showCalcCardsInGlobalAverageList', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByShowCalcCardsInGlobalAverageListDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showCalcCardsInGlobalAverageList', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByShowEmptySpaceBetweenLessons() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showEmptySpaceBetweenLessons', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByShowEmptySpaceBetweenLessonsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showEmptySpaceBetweenLessons', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortBySubjectSortType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subjectSortType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortBySubjectSortTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subjectSortType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByThemeVariant() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeVariant', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByThemeVariantDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeVariant', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByUseHandoff() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useHandoff', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByUseHandoffDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useHandoff', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByUseMaterialYou() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useMaterialYou', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByUseMaterialYouDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useMaterialYou', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByWorkWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workWeek', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByWorkWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workWeek', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByZoomLineGraph() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zoomLineGraph', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByZoomLineGraphDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zoomLineGraph', Sort.desc);
    });
  }
}

extension SettingsQuerySortThenBy
    on QueryBuilder<Settings, Settings, QSortThenBy> {
  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByActiveMaterialYouColorInt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeMaterialYouColorInt', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByActiveMaterialYouColorIntDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeMaterialYouColorInt', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByActiveProfileUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeProfileUuid', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByActiveProfileUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeProfileUuid', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByActiveProfileUuidWidgets() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeProfileUuidWidgets', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByActiveProfileUuidWidgetsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeProfileUuidWidgets', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAutoRemoveDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoRemoveDate', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAutoRemoveDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoRemoveDate', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByBrightness() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'brightness', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByBrightnessDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'brightness', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByColoredFinishedTests() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coloredFinishedTests', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByColoredFinishedTestsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coloredFinishedTests', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByColoredsufficientFromLine() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coloredsufficientFromLine', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByColoredsufficientFromLineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coloredsufficientFromLine', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByCombineDoublePeriods() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'combineDoublePeriods', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByCombineDoublePeriodsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'combineDoublePeriods', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByCurvedGraphs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'curvedGraphs', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByCurvedGraphsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'curvedGraphs', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDndTurnedOnTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dndTurnedOnTime', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDndTurnedOnTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dndTurnedOnTime', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDrawerOnBack() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'drawerOnBack', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDrawerOnBackDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'drawerOnBack', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDrawerOpenOnRight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'drawerOpenOnRight', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDrawerOpenOnRightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'drawerOpenOnRight', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByGeminiAPIKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geminiAPIKey', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByGeminiAPIKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geminiAPIKey', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByOpenAfterDownload() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openAfterDownload', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByOpenAfterDownloadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openAfterDownload', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenBySaveVirtualFiles() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saveVirtualFiles', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenBySaveVirtualFilesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saveVirtualFiles', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenBySendCrashInfo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sendCrashInfo', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenBySendCrashInfoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sendCrashInfo', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenBySharePersonalInformationWithGemini() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sharePersonalInformationWithGemini', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenBySharePersonalInformationWithGeminiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sharePersonalInformationWithGemini', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByShortBronTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shortBronTitle', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByShortBronTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shortBronTitle', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByShowAutoCancelledEvents() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showAutoCancelledEvents', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByShowAutoCancelledEventsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showAutoCancelledEvents', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByShowBronExtension() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showBronExtension', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByShowBronExtensionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showBronExtension', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByShowCalcCardsInGlobalAverageList() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showCalcCardsInGlobalAverageList', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByShowCalcCardsInGlobalAverageListDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showCalcCardsInGlobalAverageList', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByShowEmptySpaceBetweenLessons() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showEmptySpaceBetweenLessons', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByShowEmptySpaceBetweenLessonsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showEmptySpaceBetweenLessons', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenBySubjectSortType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subjectSortType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenBySubjectSortTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subjectSortType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByThemeVariant() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeVariant', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByThemeVariantDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeVariant', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByUseHandoff() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useHandoff', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByUseHandoffDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useHandoff', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByUseMaterialYou() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useMaterialYou', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByUseMaterialYouDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useMaterialYou', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByWorkWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workWeek', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByWorkWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workWeek', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByZoomLineGraph() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zoomLineGraph', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByZoomLineGraphDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zoomLineGraph', Sort.desc);
    });
  }
}

extension SettingsQueryWhereDistinct
    on QueryBuilder<Settings, Settings, QDistinct> {
  QueryBuilder<Settings, Settings, QDistinct>
      distinctByActiveMaterialYouColorInt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activeMaterialYouColorInt');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByActiveProfileUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activeProfileUuid');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
      distinctByActiveProfileUuidWidgets() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activeProfileUuidWidgets');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByAutoRemoveDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoRemoveDate');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByBrightness() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'brightness');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByColoredFinishedTests() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coloredFinishedTests');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
      distinctByColoredsufficientFromLine() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coloredsufficientFromLine');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByCombineDoublePeriods() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'combineDoublePeriods');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByCurvedGraphs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'curvedGraphs');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByDndTurnedOnTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dndTurnedOnTime');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByDrawerOnBack() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'drawerOnBack');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByDrawerOpenOnRight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'drawerOpenOnRight');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
      distinctByEnabledGradeBadgeTypes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enabledGradeBadgeTypes');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByGeminiAPIKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'geminiAPIKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByOpenAfterDownload() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'openAfterDownload');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctBySaveVirtualFiles() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'saveVirtualFiles');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctBySendCrashInfo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sendCrashInfo');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
      distinctBySharePersonalInformationWithGemini() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sharePersonalInformationWithGemini');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByShortBronTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shortBronTitle');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
      distinctByShowAutoCancelledEvents() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showAutoCancelledEvents');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByShowBronExtension() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showBronExtension');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
      distinctByShowCalcCardsInGlobalAverageList() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showCalcCardsInGlobalAverageList');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
      distinctByShowEmptySpaceBetweenLessons() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showEmptySpaceBetweenLessons');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctBySubjectSortType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subjectSortType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByThemeVariant() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'themeVariant');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByUseHandoff() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'useHandoff');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByUseMaterialYou() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'useMaterialYou');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByWorkWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workWeek');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByZoomLineGraph() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'zoomLineGraph');
    });
  }
}

extension SettingsQueryProperty
    on QueryBuilder<Settings, Settings, QQueryProperty> {
  QueryBuilder<Settings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Settings, int, QQueryOperations>
      activeMaterialYouColorIntProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activeMaterialYouColorInt');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations> activeProfileUuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activeProfileUuid');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
      activeProfileUuidWidgetsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activeProfileUuidWidgets');
    });
  }

  QueryBuilder<Settings, List<AndroidAlarm>, QQueryOperations>
      alarmsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'alarms');
    });
  }

  QueryBuilder<Settings, int, QQueryOperations> autoRemoveDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoRemoveDate');
    });
  }

  QueryBuilder<Settings, ThemeBrightness, QQueryOperations>
      brightnessProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'brightness');
    });
  }

  QueryBuilder<Settings, bool, QQueryOperations>
      coloredFinishedTestsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coloredFinishedTests');
    });
  }

  QueryBuilder<Settings, bool, QQueryOperations>
      coloredsufficientFromLineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coloredsufficientFromLine');
    });
  }

  QueryBuilder<Settings, bool, QQueryOperations>
      combineDoublePeriodsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'combineDoublePeriods');
    });
  }

  QueryBuilder<Settings, bool, QQueryOperations> curvedGraphsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'curvedGraphs');
    });
  }

  QueryBuilder<Settings, DateTime?, QQueryOperations>
      dndTurnedOnTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dndTurnedOnTime');
    });
  }

  QueryBuilder<Settings, bool, QQueryOperations> drawerOnBackProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'drawerOnBack');
    });
  }

  QueryBuilder<Settings, bool, QQueryOperations> drawerOpenOnRightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'drawerOpenOnRight');
    });
  }

  QueryBuilder<Settings, List<GradeBadgeTypes>, QQueryOperations>
      enabledGradeBadgeTypesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enabledGradeBadgeTypes');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations> geminiAPIKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'geminiAPIKey');
    });
  }

  QueryBuilder<Settings, bool, QQueryOperations> openAfterDownloadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'openAfterDownload');
    });
  }

  QueryBuilder<Settings, bool, QQueryOperations> saveVirtualFilesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'saveVirtualFiles');
    });
  }

  QueryBuilder<Settings, bool, QQueryOperations> sendCrashInfoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sendCrashInfo');
    });
  }

  QueryBuilder<Settings, bool, QQueryOperations>
      sharePersonalInformationWithGeminiProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sharePersonalInformationWithGemini');
    });
  }

  QueryBuilder<Settings, bool, QQueryOperations> shortBronTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shortBronTitle');
    });
  }

  QueryBuilder<Settings, bool, QQueryOperations>
      showAutoCancelledEventsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showAutoCancelledEvents');
    });
  }

  QueryBuilder<Settings, bool, QQueryOperations> showBronExtensionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showBronExtension');
    });
  }

  QueryBuilder<Settings, bool, QQueryOperations>
      showCalcCardsInGlobalAverageListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showCalcCardsInGlobalAverageList');
    });
  }

  QueryBuilder<Settings, bool, QQueryOperations>
      showEmptySpaceBetweenLessonsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showEmptySpaceBetweenLessons');
    });
  }

  QueryBuilder<Settings, SubjectSortType, QQueryOperations>
      subjectSortTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subjectSortType');
    });
  }

  QueryBuilder<Settings, ThemeVariant, QQueryOperations>
      themeVariantProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'themeVariant');
    });
  }

  QueryBuilder<Settings, bool, QQueryOperations> useHandoffProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'useHandoff');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> useMaterialYouProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'useMaterialYou');
    });
  }

  QueryBuilder<Settings, bool, QQueryOperations> workWeekProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workWeek');
    });
  }

  QueryBuilder<Settings, bool, QQueryOperations> zoomLineGraphProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'zoomLineGraph');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ProfileSettingsSchema = Schema(
  name: r'ProfileSettings',
  id: -1417985179991404223,
  properties: {
    r'autoInsertHeaderAndFooter': PropertySchema(
      id: 0,
      name: r'autoInsertHeaderAndFooter',
      type: IsarType.bool,
    ),
    r'eventsNotifications': PropertySchema(
      id: 1,
      name: r'eventsNotifications',
      type: IsarType.bool,
    ),
    r'favoritePeople': PropertySchema(
      id: 2,
      name: r'favoritePeople',
      type: IsarType.objectList,
      target: r'Contact',
    ),
    r'gradesNotfications': PropertySchema(
      id: 3,
      name: r'gradesNotfications',
      type: IsarType.bool,
    ),
    r'ignoredSuggestedStudiewijzerGroups': PropertySchema(
      id: 4,
      name: r'ignoredSuggestedStudiewijzerGroups',
      type: IsarType.longList,
    ),
    r'lastRefresh': PropertySchema(
      id: 5,
      name: r'lastRefresh',
      type: IsarType.dateTime,
    ),
    r'mailFooter': PropertySchema(
      id: 6,
      name: r'mailFooter',
      type: IsarType.string,
    ),
    r'mailHeader': PropertySchema(
      id: 7,
      name: r'mailHeader',
      type: IsarType.string,
    ),
    r'messagesNotifications': PropertySchema(
      id: 8,
      name: r'messagesNotifications',
      type: IsarType.bool,
    ),
    r'remindNotifications': PropertySchema(
      id: 9,
      name: r'remindNotifications',
      type: IsarType.bool,
    ),
    r'spoilerGradeNotfications': PropertySchema(
      id: 10,
      name: r'spoilerGradeNotfications',
      type: IsarType.bool,
    ),
    r'spotlightIndexAssignments': PropertySchema(
      id: 11,
      name: r'spotlightIndexAssignments',
      type: IsarType.bool,
    ),
    r'spotlightIndexMessages': PropertySchema(
      id: 12,
      name: r'spotlightIndexMessages',
      type: IsarType.bool,
    ),
    r'spotlightIndexStudiewijzers': PropertySchema(
      id: 13,
      name: r'spotlightIndexStudiewijzers',
      type: IsarType.bool,
    ),
    r'startingPageIndex': PropertySchema(
      id: 14,
      name: r'startingPageIndex',
      type: IsarType.long,
    ),
    r'sufficientFrom': PropertySchema(
      id: 15,
      name: r'sufficientFrom',
      type: IsarType.double,
    ),
    r'useAutoDND': PropertySchema(
      id: 16,
      name: r'useAutoDND',
      type: IsarType.bool,
    )
  },
  estimateSize: _profileSettingsEstimateSize,
  serialize: _profileSettingsSerialize,
  deserialize: _profileSettingsDeserialize,
  deserializeProp: _profileSettingsDeserializeProp,
);

int _profileSettingsEstimateSize(
  ProfileSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.favoritePeople.length * 3;
  {
    final offsets = allOffsets[Contact]!;
    for (var i = 0; i < object.favoritePeople.length; i++) {
      final value = object.favoritePeople[i];
      bytesCount += ContactSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.ignoredSuggestedStudiewijzerGroups.length * 8;
  {
    final value = object.mailFooter;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.mailHeader;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _profileSettingsSerialize(
  ProfileSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.autoInsertHeaderAndFooter);
  writer.writeBool(offsets[1], object.eventsNotifications);
  writer.writeObjectList<Contact>(
    offsets[2],
    allOffsets,
    ContactSchema.serialize,
    object.favoritePeople,
  );
  writer.writeBool(offsets[3], object.gradesNotfications);
  writer.writeLongList(offsets[4], object.ignoredSuggestedStudiewijzerGroups);
  writer.writeDateTime(offsets[5], object.lastRefresh);
  writer.writeString(offsets[6], object.mailFooter);
  writer.writeString(offsets[7], object.mailHeader);
  writer.writeBool(offsets[8], object.messagesNotifications);
  writer.writeBool(offsets[9], object.remindNotifications);
  writer.writeBool(offsets[10], object.spoilerGradeNotfications);
  writer.writeBool(offsets[11], object.spotlightIndexAssignments);
  writer.writeBool(offsets[12], object.spotlightIndexMessages);
  writer.writeBool(offsets[13], object.spotlightIndexStudiewijzers);
  writer.writeLong(offsets[14], object.startingPageIndex);
  writer.writeDouble(offsets[15], object.sufficientFrom);
  writer.writeBool(offsets[16], object.useAutoDND);
}

ProfileSettings _profileSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProfileSettings(
    lastRefresh: reader.readDateTimeOrNull(offsets[5]),
    mailFooter: reader.readStringOrNull(offsets[6]),
  );
  object.autoInsertHeaderAndFooter = reader.readBool(offsets[0]);
  object.eventsNotifications = reader.readBool(offsets[1]);
  object.favoritePeople = reader.readObjectList<Contact>(
        offsets[2],
        ContactSchema.deserialize,
        allOffsets,
        Contact(),
      ) ??
      [];
  object.gradesNotfications = reader.readBool(offsets[3]);
  object.ignoredSuggestedStudiewijzerGroups =
      reader.readLongList(offsets[4]) ?? [];
  object.mailHeader = reader.readStringOrNull(offsets[7]);
  object.messagesNotifications = reader.readBool(offsets[8]);
  object.remindNotifications = reader.readBool(offsets[9]);
  object.spoilerGradeNotfications = reader.readBool(offsets[10]);
  object.spotlightIndexAssignments = reader.readBool(offsets[11]);
  object.spotlightIndexMessages = reader.readBool(offsets[12]);
  object.spotlightIndexStudiewijzers = reader.readBool(offsets[13]);
  object.startingPageIndex = reader.readLong(offsets[14]);
  object.sufficientFrom = reader.readDouble(offsets[15]);
  object.useAutoDND = reader.readBool(offsets[16]);
  return object;
}

P _profileSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readObjectList<Contact>(
            offset,
            ContactSchema.deserialize,
            allOffsets,
            Contact(),
          ) ??
          []) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readLongList(offset) ?? []) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readBool(offset)) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    case 15:
      return (reader.readDouble(offset)) as P;
    case 16:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ProfileSettingsQueryFilter
    on QueryBuilder<ProfileSettings, ProfileSettings, QFilterCondition> {
  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      autoInsertHeaderAndFooterEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'autoInsertHeaderAndFooter',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      eventsNotificationsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventsNotifications',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      favoritePeopleLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'favoritePeople',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      favoritePeopleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'favoritePeople',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      favoritePeopleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'favoritePeople',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      favoritePeopleLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'favoritePeople',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      favoritePeopleLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'favoritePeople',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      favoritePeopleLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'favoritePeople',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      gradesNotficationsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gradesNotfications',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      ignoredSuggestedStudiewijzerGroupsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ignoredSuggestedStudiewijzerGroups',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      ignoredSuggestedStudiewijzerGroupsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ignoredSuggestedStudiewijzerGroups',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      ignoredSuggestedStudiewijzerGroupsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ignoredSuggestedStudiewijzerGroups',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      ignoredSuggestedStudiewijzerGroupsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ignoredSuggestedStudiewijzerGroups',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      ignoredSuggestedStudiewijzerGroupsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ignoredSuggestedStudiewijzerGroups',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      ignoredSuggestedStudiewijzerGroupsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ignoredSuggestedStudiewijzerGroups',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      ignoredSuggestedStudiewijzerGroupsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ignoredSuggestedStudiewijzerGroups',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      ignoredSuggestedStudiewijzerGroupsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ignoredSuggestedStudiewijzerGroups',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      ignoredSuggestedStudiewijzerGroupsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ignoredSuggestedStudiewijzerGroups',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      ignoredSuggestedStudiewijzerGroupsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ignoredSuggestedStudiewijzerGroups',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      lastRefreshIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastRefresh',
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      lastRefreshIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastRefresh',
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      lastRefreshEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastRefresh',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      lastRefreshGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastRefresh',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      lastRefreshLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastRefresh',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      lastRefreshBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastRefresh',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      mailFooterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mailFooter',
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      mailFooterIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mailFooter',
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      mailFooterEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mailFooter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      mailFooterGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mailFooter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      mailFooterLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mailFooter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      mailFooterBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mailFooter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      mailFooterStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mailFooter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      mailFooterEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mailFooter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      mailFooterContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mailFooter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      mailFooterMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mailFooter',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      mailFooterIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mailFooter',
        value: '',
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      mailFooterIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mailFooter',
        value: '',
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      mailHeaderIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mailHeader',
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      mailHeaderIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mailHeader',
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      mailHeaderEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mailHeader',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      mailHeaderGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mailHeader',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      mailHeaderLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mailHeader',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      mailHeaderBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mailHeader',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      mailHeaderStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mailHeader',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      mailHeaderEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mailHeader',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      mailHeaderContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mailHeader',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      mailHeaderMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mailHeader',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      mailHeaderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mailHeader',
        value: '',
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      mailHeaderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mailHeader',
        value: '',
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      messagesNotificationsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'messagesNotifications',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      remindNotificationsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remindNotifications',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      spoilerGradeNotficationsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'spoilerGradeNotfications',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      spotlightIndexAssignmentsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'spotlightIndexAssignments',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      spotlightIndexMessagesEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'spotlightIndexMessages',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      spotlightIndexStudiewijzersEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'spotlightIndexStudiewijzers',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      startingPageIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startingPageIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      startingPageIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startingPageIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      startingPageIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startingPageIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      startingPageIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startingPageIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      sufficientFromEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sufficientFrom',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      sufficientFromGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sufficientFrom',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      sufficientFromLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sufficientFrom',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      sufficientFromBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sufficientFrom',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      useAutoDNDEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'useAutoDND',
        value: value,
      ));
    });
  }
}

extension ProfileSettingsQueryObject
    on QueryBuilder<ProfileSettings, ProfileSettings, QFilterCondition> {
  QueryBuilder<ProfileSettings, ProfileSettings, QAfterFilterCondition>
      favoritePeopleElement(FilterQuery<Contact> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'favoritePeople');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const AndroidAlarmSchema = Schema(
  name: r'AndroidAlarm',
  id: 2742650790638012118,
  properties: {
    r'allowWhileIdle': PropertySchema(
      id: 0,
      name: r'allowWhileIdle',
      type: IsarType.bool,
    ),
    r'exact': PropertySchema(
      id: 1,
      name: r'exact',
      type: IsarType.bool,
    ),
    r'id': PropertySchema(
      id: 2,
      name: r'id',
      type: IsarType.long,
    ),
    r'rescheduleOnReboot': PropertySchema(
      id: 3,
      name: r'rescheduleOnReboot',
      type: IsarType.bool,
    ),
    r'time': PropertySchema(
      id: 4,
      name: r'time',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _androidAlarmEstimateSize,
  serialize: _androidAlarmSerialize,
  deserialize: _androidAlarmDeserialize,
  deserializeProp: _androidAlarmDeserializeProp,
);

int _androidAlarmEstimateSize(
  AndroidAlarm object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _androidAlarmSerialize(
  AndroidAlarm object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.allowWhileIdle);
  writer.writeBool(offsets[1], object.exact);
  writer.writeLong(offsets[2], object.id);
  writer.writeBool(offsets[3], object.rescheduleOnReboot);
  writer.writeDateTime(offsets[4], object.time);
}

AndroidAlarm _androidAlarmDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AndroidAlarm(
    allowWhileIdle: reader.readBoolOrNull(offsets[0]) ?? true,
    exact: reader.readBoolOrNull(offsets[1]) ?? true,
    id: reader.readLongOrNull(offsets[2]) ?? 0,
    rescheduleOnReboot: reader.readBoolOrNull(offsets[3]) ?? true,
    time: reader.readDateTimeOrNull(offsets[4]),
  );
  return object;
}

P _androidAlarmDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 1:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 2:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 3:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension AndroidAlarmQueryFilter
    on QueryBuilder<AndroidAlarm, AndroidAlarm, QFilterCondition> {
  QueryBuilder<AndroidAlarm, AndroidAlarm, QAfterFilterCondition>
      allowWhileIdleEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'allowWhileIdle',
        value: value,
      ));
    });
  }

  QueryBuilder<AndroidAlarm, AndroidAlarm, QAfterFilterCondition> exactEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exact',
        value: value,
      ));
    });
  }

  QueryBuilder<AndroidAlarm, AndroidAlarm, QAfterFilterCondition> idEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AndroidAlarm, AndroidAlarm, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AndroidAlarm, AndroidAlarm, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AndroidAlarm, AndroidAlarm, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AndroidAlarm, AndroidAlarm, QAfterFilterCondition>
      rescheduleOnRebootEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rescheduleOnReboot',
        value: value,
      ));
    });
  }

  QueryBuilder<AndroidAlarm, AndroidAlarm, QAfterFilterCondition> timeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'time',
      ));
    });
  }

  QueryBuilder<AndroidAlarm, AndroidAlarm, QAfterFilterCondition>
      timeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'time',
      ));
    });
  }

  QueryBuilder<AndroidAlarm, AndroidAlarm, QAfterFilterCondition> timeEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'time',
        value: value,
      ));
    });
  }

  QueryBuilder<AndroidAlarm, AndroidAlarm, QAfterFilterCondition>
      timeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'time',
        value: value,
      ));
    });
  }

  QueryBuilder<AndroidAlarm, AndroidAlarm, QAfterFilterCondition> timeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'time',
        value: value,
      ));
    });
  }

  QueryBuilder<AndroidAlarm, AndroidAlarm, QAfterFilterCondition> timeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'time',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AndroidAlarmQueryObject
    on QueryBuilder<AndroidAlarm, AndroidAlarm, QFilterCondition> {}
