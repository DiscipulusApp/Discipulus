// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCalendarEventCollection on Isar {
  IsarCollection<CalendarEvent> get calendarEvents => this.collection();
}

const CalendarEventSchema = CollectionSchema(
  name: r'CalendarEvent',
  id: 2832606634183555054,
  properties: {
    r'aangemaakt': PropertySchema(
      id: 0,
      name: r'aangemaakt',
      type: IsarType.dateTime,
    ),
    r'aantekening': PropertySchema(
      id: 1,
      name: r'aantekening',
      type: IsarType.string,
    ),
    r'afgerond': PropertySchema(
      id: 2,
      name: r'afgerond',
      type: IsarType.bool,
    ),
    r'afwezigheid': PropertySchema(
      id: 3,
      name: r'afwezigheid',
      type: IsarType.object,
      target: r'Absence',
    ),
    r'customCalendarProperties': PropertySchema(
      id: 4,
      name: r'customCalendarProperties',
      type: IsarType.object,
      target: r'CustomCalendarProperties',
    ),
    r'docenten': PropertySchema(
      id: 5,
      name: r'docenten',
      type: IsarType.objectList,
      target: r'Docenten',
    ),
    r'duurtHeleDag': PropertySchema(
      id: 6,
      name: r'duurtHeleDag',
      type: IsarType.bool,
    ),
    r'einde': PropertySchema(
      id: 7,
      name: r'einde',
      type: IsarType.dateTime,
    ),
    r'excludeFromAutoDND': PropertySchema(
      id: 8,
      name: r'excludeFromAutoDND',
      type: IsarType.bool,
    ),
    r'gewijzigd': PropertySchema(
      id: 9,
      name: r'gewijzigd',
      type: IsarType.dateTime,
    ),
    r'heeftBijlagen': PropertySchema(
      id: 10,
      name: r'heeftBijlagen',
      type: IsarType.bool,
    ),
    r'herhaalStatus': PropertySchema(
      id: 11,
      name: r'herhaalStatus',
      type: IsarType.long,
    ),
    r'id': PropertySchema(
      id: 12,
      name: r'id',
      type: IsarType.long,
    ),
    r'infoType': PropertySchema(
      id: 13,
      name: r'infoType',
      type: IsarType.byte,
      enumMap: _CalendarEventinfoTypeEnumValueMap,
    ),
    r'inhoud': PropertySchema(
      id: 14,
      name: r'inhoud',
      type: IsarType.string,
    ),
    r'isOnlineDeelname': PropertySchema(
      id: 15,
      name: r'isOnlineDeelname',
      type: IsarType.bool,
    ),
    r'lesuurTotMet': PropertySchema(
      id: 16,
      name: r'lesuurTotMet',
      type: IsarType.long,
    ),
    r'lesuurVan': PropertySchema(
      id: 17,
      name: r'lesuurVan',
      type: IsarType.long,
    ),
    r'lokalen': PropertySchema(
      id: 18,
      name: r'lokalen',
      type: IsarType.objectList,
      target: r'Lokalen',
    ),
    r'lokatie': PropertySchema(
      id: 19,
      name: r'lokatie',
      type: IsarType.string,
    ),
    r'omschrijving': PropertySchema(
      id: 20,
      name: r'omschrijving',
      type: IsarType.string,
    ),
    r'opdrachtId': PropertySchema(
      id: 21,
      name: r'opdrachtId',
      type: IsarType.long,
    ),
    r'rawInfoType': PropertySchema(
      id: 22,
      name: r'rawInfoType',
      type: IsarType.byte,
      enumMap: _CalendarEventrawInfoTypeEnumValueMap,
    ),
    r'rawInhoud': PropertySchema(
      id: 23,
      name: r'rawInhoud',
      type: IsarType.string,
    ),
    r'rawLokatie': PropertySchema(
      id: 24,
      name: r'rawLokatie',
      type: IsarType.string,
    ),
    r'rawStatus': PropertySchema(
      id: 25,
      name: r'rawStatus',
      type: IsarType.byte,
      enumMap: _CalendarEventrawStatusEnumValueMap,
    ),
    r'selfUrl': PropertySchema(
      id: 26,
      name: r'selfUrl',
      type: IsarType.string,
    ),
    r'start': PropertySchema(
      id: 27,
      name: r'start',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(
      id: 28,
      name: r'status',
      type: IsarType.byte,
      enumMap: _CalendarEventstatusEnumValueMap,
    ),
    r'subtype': PropertySchema(
      id: 29,
      name: r'subtype',
      type: IsarType.long,
    ),
    r'type': PropertySchema(
      id: 30,
      name: r'type',
      type: IsarType.byte,
      enumMap: _CalendarEventtypeEnumValueMap,
    ),
    r'vakken': PropertySchema(
      id: 31,
      name: r'vakken',
      type: IsarType.objectList,
      target: r'Vakken',
    ),
    r'weergaveType': PropertySchema(
      id: 32,
      name: r'weergaveType',
      type: IsarType.long,
    )
  },
  estimateSize: _calendarEventEstimateSize,
  serialize: _calendarEventSerialize,
  deserialize: _calendarEventDeserialize,
  deserializeProp: _calendarEventDeserializeProp,
  idName: r'uuid',
  indexes: {},
  links: {
    r'profile': LinkSchema(
      id: 5217495728355514439,
      name: r'profile',
      target: r'Profile',
      single: true,
    ),
    r'subject': LinkSchema(
      id: -1984083795299018980,
      name: r'subject',
      target: r'Subject',
      single: true,
    ),
    r'bronnen': LinkSchema(
      id: 8792292482664861941,
      name: r'bronnen',
      target: r'Bron',
      single: false,
    ),
    r'studiewijzers': LinkSchema(
      id: -5019929566153875909,
      name: r'studiewijzers',
      target: r'Studiewijzer',
      single: false,
    )
  },
  embeddedSchemas: {
    r'Vakken': VakkenSchema,
    r'Docenten': DocentenSchema,
    r'Lokalen': LokalenSchema,
    r'Absence': AbsenceSchema,
    r'CustomCalendarProperties': CustomCalendarPropertiesSchema
  },
  getId: _calendarEventGetId,
  getLinks: _calendarEventGetLinks,
  attach: _calendarEventAttach,
  version: '3.1.0+1',
);

int _calendarEventEstimateSize(
  CalendarEvent object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.aantekening;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.afwezigheid;
    if (value != null) {
      bytesCount += 3 +
          AbsenceSchema.estimateSize(value, allOffsets[Absence]!, allOffsets);
    }
  }
  {
    final value = object.customCalendarProperties;
    if (value != null) {
      bytesCount += 3 +
          CustomCalendarPropertiesSchema.estimateSize(
              value, allOffsets[CustomCalendarProperties]!, allOffsets);
    }
  }
  {
    final list = object.docenten;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[Docenten]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += DocentenSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final value = object.inhoud;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.lokalen;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[Lokalen]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += LokalenSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final value = object.lokatie;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.omschrijving;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.rawInhoud;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.rawLokatie;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.selfUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.vakken;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[Vakken]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += VakkenSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  return bytesCount;
}

void _calendarEventSerialize(
  CalendarEvent object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.aangemaakt);
  writer.writeString(offsets[1], object.aantekening);
  writer.writeBool(offsets[2], object.afgerond);
  writer.writeObject<Absence>(
    offsets[3],
    allOffsets,
    AbsenceSchema.serialize,
    object.afwezigheid,
  );
  writer.writeObject<CustomCalendarProperties>(
    offsets[4],
    allOffsets,
    CustomCalendarPropertiesSchema.serialize,
    object.customCalendarProperties,
  );
  writer.writeObjectList<Docenten>(
    offsets[5],
    allOffsets,
    DocentenSchema.serialize,
    object.docenten,
  );
  writer.writeBool(offsets[6], object.duurtHeleDag);
  writer.writeDateTime(offsets[7], object.einde);
  writer.writeBool(offsets[8], object.excludeFromAutoDND);
  writer.writeDateTime(offsets[9], object.gewijzigd);
  writer.writeBool(offsets[10], object.heeftBijlagen);
  writer.writeLong(offsets[11], object.herhaalStatus);
  writer.writeLong(offsets[12], object.id);
  writer.writeByte(offsets[13], object.infoType.index);
  writer.writeString(offsets[14], object.inhoud);
  writer.writeBool(offsets[15], object.isOnlineDeelname);
  writer.writeLong(offsets[16], object.lesuurTotMet);
  writer.writeLong(offsets[17], object.lesuurVan);
  writer.writeObjectList<Lokalen>(
    offsets[18],
    allOffsets,
    LokalenSchema.serialize,
    object.lokalen,
  );
  writer.writeString(offsets[19], object.lokatie);
  writer.writeString(offsets[20], object.omschrijving);
  writer.writeLong(offsets[21], object.opdrachtId);
  writer.writeByte(offsets[22], object.rawInfoType.index);
  writer.writeString(offsets[23], object.rawInhoud);
  writer.writeString(offsets[24], object.rawLokatie);
  writer.writeByte(offsets[25], object.rawStatus.index);
  writer.writeString(offsets[26], object.selfUrl);
  writer.writeDateTime(offsets[27], object.start);
  writer.writeByte(offsets[28], object.status.index);
  writer.writeLong(offsets[29], object.subtype);
  writer.writeByte(offsets[30], object.type.index);
  writer.writeObjectList<Vakken>(
    offsets[31],
    allOffsets,
    VakkenSchema.serialize,
    object.vakken,
  );
  writer.writeLong(offsets[32], object.weergaveType);
}

CalendarEvent _calendarEventDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CalendarEvent(
    aangemaakt: reader.readDateTimeOrNull(offsets[0]),
    aantekening: reader.readStringOrNull(offsets[1]),
    afgerond: reader.readBoolOrNull(offsets[2]) ?? false,
    afwezigheid: reader.readObjectOrNull<Absence>(
      offsets[3],
      AbsenceSchema.deserialize,
      allOffsets,
    ),
    docenten: reader.readObjectList<Docenten>(
      offsets[5],
      DocentenSchema.deserialize,
      allOffsets,
      Docenten(),
    ),
    duurtHeleDag: reader.readBoolOrNull(offsets[6]) ?? false,
    einde: reader.readDateTime(offsets[7]),
    gewijzigd: reader.readDateTimeOrNull(offsets[9]),
    heeftBijlagen: reader.readBoolOrNull(offsets[10]) ?? false,
    herhaalStatus: reader.readLongOrNull(offsets[11]) ?? 0,
    id: reader.readLongOrNull(offsets[12]) ?? 0,
    isOnlineDeelname: reader.readBoolOrNull(offsets[15]) ?? false,
    lesuurTotMet: reader.readLongOrNull(offsets[16]),
    lesuurVan: reader.readLongOrNull(offsets[17]),
    lokalen: reader.readObjectList<Lokalen>(
      offsets[18],
      LokalenSchema.deserialize,
      allOffsets,
      Lokalen(),
    ),
    omschrijving: reader.readStringOrNull(offsets[20]),
    opdrachtId: reader.readLongOrNull(offsets[21]) ?? 0,
    rawInfoType: _CalendarEventrawInfoTypeValueEnumMap[
            reader.readByteOrNull(offsets[22])] ??
        InfoType.information,
    rawInhoud: reader.readStringOrNull(offsets[23]),
    rawLokatie: reader.readStringOrNull(offsets[24]),
    rawStatus: _CalendarEventrawStatusValueEnumMap[
            reader.readByteOrNull(offsets[25])] ??
        Status.manuallyScheduled,
    selfUrl: reader.readStringOrNull(offsets[26]),
    start: reader.readDateTime(offsets[27]),
    subtype: reader.readLongOrNull(offsets[29]) ?? 1,
    type: _CalendarEventtypeValueEnumMap[reader.readByteOrNull(offsets[30])] ??
        CalendarType.personal,
    vakken: reader.readObjectList<Vakken>(
      offsets[31],
      VakkenSchema.deserialize,
      allOffsets,
      Vakken(),
    ),
    weergaveType: reader.readLongOrNull(offsets[32]) ?? 1,
  );
  object.customCalendarProperties =
      reader.readObjectOrNull<CustomCalendarProperties>(
    offsets[4],
    CustomCalendarPropertiesSchema.deserialize,
    allOffsets,
  );
  object.excludeFromAutoDND = reader.readBool(offsets[8]);
  object.infoType =
      _CalendarEventinfoTypeValueEnumMap[reader.readByteOrNull(offsets[13])] ??
          InfoType.none;
  object.inhoud = reader.readStringOrNull(offsets[14]);
  object.lokatie = reader.readStringOrNull(offsets[19]);
  object.status =
      _CalendarEventstatusValueEnumMap[reader.readByteOrNull(offsets[28])] ??
          Status.unknown;
  return object;
}

P _calendarEventDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 3:
      return (reader.readObjectOrNull<Absence>(
        offset,
        AbsenceSchema.deserialize,
        allOffsets,
      )) as P;
    case 4:
      return (reader.readObjectOrNull<CustomCalendarProperties>(
        offset,
        CustomCalendarPropertiesSchema.deserialize,
        allOffsets,
      )) as P;
    case 5:
      return (reader.readObjectList<Docenten>(
        offset,
        DocentenSchema.deserialize,
        allOffsets,
        Docenten(),
      )) as P;
    case 6:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 10:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 11:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 12:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 13:
      return (_CalendarEventinfoTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          InfoType.none) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 16:
      return (reader.readLongOrNull(offset)) as P;
    case 17:
      return (reader.readLongOrNull(offset)) as P;
    case 18:
      return (reader.readObjectList<Lokalen>(
        offset,
        LokalenSchema.deserialize,
        allOffsets,
        Lokalen(),
      )) as P;
    case 19:
      return (reader.readStringOrNull(offset)) as P;
    case 20:
      return (reader.readStringOrNull(offset)) as P;
    case 21:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 22:
      return (_CalendarEventrawInfoTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          InfoType.information) as P;
    case 23:
      return (reader.readStringOrNull(offset)) as P;
    case 24:
      return (reader.readStringOrNull(offset)) as P;
    case 25:
      return (_CalendarEventrawStatusValueEnumMap[
              reader.readByteOrNull(offset)] ??
          Status.manuallyScheduled) as P;
    case 26:
      return (reader.readStringOrNull(offset)) as P;
    case 27:
      return (reader.readDateTime(offset)) as P;
    case 28:
      return (_CalendarEventstatusValueEnumMap[reader.readByteOrNull(offset)] ??
          Status.unknown) as P;
    case 29:
      return (reader.readLongOrNull(offset) ?? 1) as P;
    case 30:
      return (_CalendarEventtypeValueEnumMap[reader.readByteOrNull(offset)] ??
          CalendarType.personal) as P;
    case 31:
      return (reader.readObjectList<Vakken>(
        offset,
        VakkenSchema.deserialize,
        allOffsets,
        Vakken(),
      )) as P;
    case 32:
      return (reader.readLongOrNull(offset) ?? 1) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _CalendarEventinfoTypeEnumValueMap = {
  'none': 0,
  'homework': 1,
  'test': 2,
  'exam': 3,
  'writtenExam': 4,
  'oralExam': 5,
  'information': 6,
  'note': 7,
};
const _CalendarEventinfoTypeValueEnumMap = {
  0: InfoType.none,
  1: InfoType.homework,
  2: InfoType.test,
  3: InfoType.exam,
  4: InfoType.writtenExam,
  5: InfoType.oralExam,
  6: InfoType.information,
  7: InfoType.note,
};
const _CalendarEventrawInfoTypeEnumValueMap = {
  'none': 0,
  'homework': 1,
  'test': 2,
  'exam': 3,
  'writtenExam': 4,
  'oralExam': 5,
  'information': 6,
  'note': 7,
};
const _CalendarEventrawInfoTypeValueEnumMap = {
  0: InfoType.none,
  1: InfoType.homework,
  2: InfoType.test,
  3: InfoType.exam,
  4: InfoType.writtenExam,
  5: InfoType.oralExam,
  6: InfoType.information,
  7: InfoType.note,
};
const _CalendarEventrawStatusEnumValueMap = {
  'unknown': 0,
  'automaticallyScheduled': 1,
  'manuallyScheduled': 2,
  'changed': 3,
  'manuallyCanceled': 4,
  'automaticallyCanceled': 5,
  'inUse': 6,
  'finished': 7,
  'used': 8,
  'moved': 9,
  'changedAndMoved': 10,
};
const _CalendarEventrawStatusValueEnumMap = {
  0: Status.unknown,
  1: Status.automaticallyScheduled,
  2: Status.manuallyScheduled,
  3: Status.changed,
  4: Status.manuallyCanceled,
  5: Status.automaticallyCanceled,
  6: Status.inUse,
  7: Status.finished,
  8: Status.used,
  9: Status.moved,
  10: Status.changedAndMoved,
};
const _CalendarEventstatusEnumValueMap = {
  'unknown': 0,
  'automaticallyScheduled': 1,
  'manuallyScheduled': 2,
  'changed': 3,
  'manuallyCanceled': 4,
  'automaticallyCanceled': 5,
  'inUse': 6,
  'finished': 7,
  'used': 8,
  'moved': 9,
  'changedAndMoved': 10,
};
const _CalendarEventstatusValueEnumMap = {
  0: Status.unknown,
  1: Status.automaticallyScheduled,
  2: Status.manuallyScheduled,
  3: Status.changed,
  4: Status.manuallyCanceled,
  5: Status.automaticallyCanceled,
  6: Status.inUse,
  7: Status.finished,
  8: Status.used,
  9: Status.moved,
  10: Status.changedAndMoved,
};
const _CalendarEventtypeEnumValueMap = {
  'none': 0,
  'personal': 1,
  'general': 2,
  'schoolWide': 3,
  'internship': 4,
  'intake': 5,
  'free': 6,
  'kwt': 7,
  'standby': 8,
  'blocked': 9,
  'other': 10,
  'blockedClassroom': 11,
  'blockedClass': 12,
  'classs': 13,
  'studyHouse': 14,
  'freeStudy': 15,
  'schedule': 16,
  'measures': 17,
  'presentations': 18,
  'examSchedule': 19,
};
const _CalendarEventtypeValueEnumMap = {
  0: CalendarType.none,
  1: CalendarType.personal,
  2: CalendarType.general,
  3: CalendarType.schoolWide,
  4: CalendarType.internship,
  5: CalendarType.intake,
  6: CalendarType.free,
  7: CalendarType.kwt,
  8: CalendarType.standby,
  9: CalendarType.blocked,
  10: CalendarType.other,
  11: CalendarType.blockedClassroom,
  12: CalendarType.blockedClass,
  13: CalendarType.classs,
  14: CalendarType.studyHouse,
  15: CalendarType.freeStudy,
  16: CalendarType.schedule,
  17: CalendarType.measures,
  18: CalendarType.presentations,
  19: CalendarType.examSchedule,
};

Id _calendarEventGetId(CalendarEvent object) {
  return object.uuid;
}

List<IsarLinkBase<dynamic>> _calendarEventGetLinks(CalendarEvent object) {
  return [object.profile, object.subject, object.bronnen, object.studiewijzers];
}

void _calendarEventAttach(
    IsarCollection<dynamic> col, Id id, CalendarEvent object) {
  object.profile.attach(col, col.isar.collection<Profile>(), r'profile', id);
  object.subject.attach(col, col.isar.collection<Subject>(), r'subject', id);
  object.bronnen.attach(col, col.isar.collection<Bron>(), r'bronnen', id);
  object.studiewijzers
      .attach(col, col.isar.collection<Studiewijzer>(), r'studiewijzers', id);
}

extension CalendarEventQueryWhereSort
    on QueryBuilder<CalendarEvent, CalendarEvent, QWhere> {
  QueryBuilder<CalendarEvent, CalendarEvent, QAfterWhere> anyUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CalendarEventQueryWhere
    on QueryBuilder<CalendarEvent, CalendarEvent, QWhereClause> {
  QueryBuilder<CalendarEvent, CalendarEvent, QAfterWhereClause> uuidEqualTo(
      Id uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: uuid,
        upper: uuid,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterWhereClause> uuidNotEqualTo(
      Id uuid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: uuid, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: uuid, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: uuid, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: uuid, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterWhereClause> uuidGreaterThan(
      Id uuid,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: uuid, includeLower: include),
      );
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterWhereClause> uuidLessThan(
      Id uuid,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: uuid, includeUpper: include),
      );
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterWhereClause> uuidBetween(
    Id lowerUuid,
    Id upperUuid, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerUuid,
        includeLower: includeLower,
        upper: upperUuid,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CalendarEventQueryFilter
    on QueryBuilder<CalendarEvent, CalendarEvent, QFilterCondition> {
  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      aangemaaktIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'aangemaakt',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      aangemaaktIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'aangemaakt',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      aangemaaktEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aangemaakt',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      aangemaaktGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'aangemaakt',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      aangemaaktLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'aangemaakt',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      aangemaaktBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'aangemaakt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      aantekeningIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'aantekening',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      aantekeningIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'aantekening',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      aantekeningEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aantekening',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      aantekeningGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'aantekening',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      aantekeningLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'aantekening',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      aantekeningBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'aantekening',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      aantekeningStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'aantekening',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      aantekeningEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'aantekening',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      aantekeningContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'aantekening',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      aantekeningMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'aantekening',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      aantekeningIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aantekening',
        value: '',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      aantekeningIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'aantekening',
        value: '',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      afgerondEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'afgerond',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      afwezigheidIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'afwezigheid',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      afwezigheidIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'afwezigheid',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      customCalendarPropertiesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customCalendarProperties',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      customCalendarPropertiesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customCalendarProperties',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      docentenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'docenten',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      docentenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'docenten',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      docentenLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'docenten',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      docentenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'docenten',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      docentenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'docenten',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      docentenLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'docenten',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      docentenLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'docenten',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      docentenLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'docenten',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      duurtHeleDagEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'duurtHeleDag',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      eindeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'einde',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      eindeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'einde',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      eindeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'einde',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      eindeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'einde',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      excludeFromAutoDNDEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'excludeFromAutoDND',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      gewijzigdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'gewijzigd',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      gewijzigdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'gewijzigd',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      gewijzigdEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gewijzigd',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      gewijzigdGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gewijzigd',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      gewijzigdLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gewijzigd',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      gewijzigdBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gewijzigd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      heeftBijlagenEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'heeftBijlagen',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      herhaalStatusEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'herhaalStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      herhaalStatusGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'herhaalStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      herhaalStatusLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'herhaalStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      herhaalStatusBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'herhaalStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition> idEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      infoTypeEqualTo(InfoType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'infoType',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      infoTypeGreaterThan(
    InfoType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'infoType',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      infoTypeLessThan(
    InfoType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'infoType',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      infoTypeBetween(
    InfoType lower,
    InfoType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'infoType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      inhoudIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'inhoud',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      inhoudIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'inhoud',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      inhoudEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'inhoud',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      inhoudGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'inhoud',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      inhoudLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'inhoud',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      inhoudBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'inhoud',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      inhoudStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'inhoud',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      inhoudEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'inhoud',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      inhoudContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'inhoud',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      inhoudMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'inhoud',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      inhoudIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'inhoud',
        value: '',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      inhoudIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'inhoud',
        value: '',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      isOnlineDeelnameEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isOnlineDeelname',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lesuurTotMetIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lesuurTotMet',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lesuurTotMetIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lesuurTotMet',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lesuurTotMetEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lesuurTotMet',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lesuurTotMetGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lesuurTotMet',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lesuurTotMetLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lesuurTotMet',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lesuurTotMetBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lesuurTotMet',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lesuurVanIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lesuurVan',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lesuurVanIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lesuurVan',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lesuurVanEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lesuurVan',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lesuurVanGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lesuurVan',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lesuurVanLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lesuurVan',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lesuurVanBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lesuurVan',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lokalenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lokalen',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lokalenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lokalen',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lokalenLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lokalen',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lokalenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lokalen',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lokalenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lokalen',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lokalenLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lokalen',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lokalenLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lokalen',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lokalenLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lokalen',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lokatieIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lokatie',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lokatieIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lokatie',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lokatieEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lokatie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lokatieGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lokatie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lokatieLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lokatie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lokatieBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lokatie',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lokatieStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lokatie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lokatieEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lokatie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lokatieContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lokatie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lokatieMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lokatie',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lokatieIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lokatie',
        value: '',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lokatieIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lokatie',
        value: '',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      omschrijvingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'omschrijving',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      omschrijvingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'omschrijving',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      omschrijvingEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'omschrijving',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      omschrijvingGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'omschrijving',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      omschrijvingLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'omschrijving',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      omschrijvingBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'omschrijving',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      omschrijvingStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'omschrijving',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      omschrijvingEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'omschrijving',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      omschrijvingContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'omschrijving',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      omschrijvingMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'omschrijving',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      omschrijvingIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'omschrijving',
        value: '',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      omschrijvingIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'omschrijving',
        value: '',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      opdrachtIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'opdrachtId',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      opdrachtIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'opdrachtId',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      opdrachtIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'opdrachtId',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      opdrachtIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'opdrachtId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawInfoTypeEqualTo(InfoType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawInfoType',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawInfoTypeGreaterThan(
    InfoType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawInfoType',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawInfoTypeLessThan(
    InfoType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawInfoType',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawInfoTypeBetween(
    InfoType lower,
    InfoType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawInfoType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawInhoudIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rawInhoud',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawInhoudIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rawInhoud',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawInhoudEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawInhoud',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawInhoudGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawInhoud',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawInhoudLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawInhoud',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawInhoudBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawInhoud',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawInhoudStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rawInhoud',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawInhoudEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rawInhoud',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawInhoudContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rawInhoud',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawInhoudMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rawInhoud',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawInhoudIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawInhoud',
        value: '',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawInhoudIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rawInhoud',
        value: '',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawLokatieIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rawLokatie',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawLokatieIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rawLokatie',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawLokatieEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawLokatie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawLokatieGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawLokatie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawLokatieLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawLokatie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawLokatieBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawLokatie',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawLokatieStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rawLokatie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawLokatieEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rawLokatie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawLokatieContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rawLokatie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawLokatieMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rawLokatie',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawLokatieIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawLokatie',
        value: '',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawLokatieIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rawLokatie',
        value: '',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawStatusEqualTo(Status value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawStatusGreaterThan(
    Status value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawStatusLessThan(
    Status value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      rawStatusBetween(
    Status lower,
    Status upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      selfUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'selfUrl',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      selfUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'selfUrl',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      selfUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selfUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      selfUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selfUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      selfUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selfUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      selfUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selfUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      selfUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'selfUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      selfUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'selfUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      selfUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'selfUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      selfUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'selfUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      selfUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selfUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      selfUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'selfUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      startEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'start',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      startGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'start',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      startLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'start',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      startBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'start',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      statusEqualTo(Status value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      statusGreaterThan(
    Status value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      statusLessThan(
    Status value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      statusBetween(
    Status lower,
    Status upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      subtypeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subtype',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      subtypeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subtype',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      subtypeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subtype',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      subtypeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subtype',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition> typeEqualTo(
      CalendarType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      typeGreaterThan(
    CalendarType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      typeLessThan(
    CalendarType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition> typeBetween(
    CalendarType lower,
    CalendarType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition> uuidEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      uuidGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uuid',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      uuidLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uuid',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition> uuidBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      vakkenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'vakken',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      vakkenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'vakken',
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      vakkenLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'vakken',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      vakkenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'vakken',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      vakkenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'vakken',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      vakkenLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'vakken',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      vakkenLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'vakken',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      vakkenLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'vakken',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      weergaveTypeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weergaveType',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      weergaveTypeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weergaveType',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      weergaveTypeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weergaveType',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      weergaveTypeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weergaveType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CalendarEventQueryObject
    on QueryBuilder<CalendarEvent, CalendarEvent, QFilterCondition> {
  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition> afwezigheid(
      FilterQuery<Absence> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'afwezigheid');
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      customCalendarProperties(FilterQuery<CustomCalendarProperties> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'customCalendarProperties');
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      docentenElement(FilterQuery<Docenten> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'docenten');
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      lokalenElement(FilterQuery<Lokalen> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'lokalen');
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      vakkenElement(FilterQuery<Vakken> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'vakken');
    });
  }
}

extension CalendarEventQueryLinks
    on QueryBuilder<CalendarEvent, CalendarEvent, QFilterCondition> {
  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition> profile(
      FilterQuery<Profile> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'profile');
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      profileIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'profile', 0, true, 0, true);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition> subject(
      FilterQuery<Subject> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'subject');
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      subjectIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'subject', 0, true, 0, true);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition> bronnen(
      FilterQuery<Bron> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'bronnen');
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      bronnenLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', length, true, length, true);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      bronnenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', 0, true, 0, true);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      bronnenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', 0, false, 999999, true);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      bronnenLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', 0, true, length, include);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      bronnenLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', length, include, 999999, true);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      bronnenLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'bronnen', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      studiewijzers(FilterQuery<Studiewijzer> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'studiewijzers');
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      studiewijzersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'studiewijzers', length, true, length, true);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      studiewijzersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'studiewijzers', 0, true, 0, true);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      studiewijzersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'studiewijzers', 0, false, 999999, true);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      studiewijzersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'studiewijzers', 0, true, length, include);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      studiewijzersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'studiewijzers', length, include, 999999, true);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      studiewijzersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'studiewijzers', lower, includeLower, upper, includeUpper);
    });
  }
}

extension CalendarEventQuerySortBy
    on QueryBuilder<CalendarEvent, CalendarEvent, QSortBy> {
  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> sortByAangemaakt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aangemaakt', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      sortByAangemaaktDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aangemaakt', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> sortByAantekening() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aantekening', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      sortByAantekeningDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aantekening', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> sortByAfgerond() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'afgerond', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      sortByAfgerondDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'afgerond', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      sortByDuurtHeleDag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duurtHeleDag', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      sortByDuurtHeleDagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duurtHeleDag', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> sortByEinde() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'einde', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> sortByEindeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'einde', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      sortByExcludeFromAutoDND() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'excludeFromAutoDND', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      sortByExcludeFromAutoDNDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'excludeFromAutoDND', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> sortByGewijzigd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gewijzigd', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      sortByGewijzigdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gewijzigd', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      sortByHeeftBijlagen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heeftBijlagen', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      sortByHeeftBijlagenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heeftBijlagen', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      sortByHerhaalStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'herhaalStatus', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      sortByHerhaalStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'herhaalStatus', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> sortByInfoType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'infoType', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      sortByInfoTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'infoType', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> sortByInhoud() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inhoud', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> sortByInhoudDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inhoud', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      sortByIsOnlineDeelname() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOnlineDeelname', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      sortByIsOnlineDeelnameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOnlineDeelname', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      sortByLesuurTotMet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lesuurTotMet', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      sortByLesuurTotMetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lesuurTotMet', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> sortByLesuurVan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lesuurVan', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      sortByLesuurVanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lesuurVan', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> sortByLokatie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lokatie', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> sortByLokatieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lokatie', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      sortByOmschrijving() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'omschrijving', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      sortByOmschrijvingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'omschrijving', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> sortByOpdrachtId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'opdrachtId', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      sortByOpdrachtIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'opdrachtId', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> sortByRawInfoType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawInfoType', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      sortByRawInfoTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawInfoType', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> sortByRawInhoud() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawInhoud', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      sortByRawInhoudDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawInhoud', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> sortByRawLokatie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawLokatie', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      sortByRawLokatieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawLokatie', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> sortByRawStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawStatus', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      sortByRawStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawStatus', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> sortBySelfUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selfUrl', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> sortBySelfUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selfUrl', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> sortByStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'start', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> sortByStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'start', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> sortBySubtype() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtype', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> sortBySubtypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtype', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      sortByWeergaveType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weergaveType', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      sortByWeergaveTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weergaveType', Sort.desc);
    });
  }
}

extension CalendarEventQuerySortThenBy
    on QueryBuilder<CalendarEvent, CalendarEvent, QSortThenBy> {
  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenByAangemaakt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aangemaakt', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      thenByAangemaaktDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aangemaakt', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenByAantekening() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aantekening', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      thenByAantekeningDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aantekening', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenByAfgerond() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'afgerond', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      thenByAfgerondDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'afgerond', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      thenByDuurtHeleDag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duurtHeleDag', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      thenByDuurtHeleDagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duurtHeleDag', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenByEinde() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'einde', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenByEindeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'einde', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      thenByExcludeFromAutoDND() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'excludeFromAutoDND', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      thenByExcludeFromAutoDNDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'excludeFromAutoDND', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenByGewijzigd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gewijzigd', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      thenByGewijzigdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gewijzigd', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      thenByHeeftBijlagen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heeftBijlagen', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      thenByHeeftBijlagenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heeftBijlagen', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      thenByHerhaalStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'herhaalStatus', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      thenByHerhaalStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'herhaalStatus', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenByInfoType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'infoType', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      thenByInfoTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'infoType', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenByInhoud() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inhoud', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenByInhoudDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inhoud', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      thenByIsOnlineDeelname() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOnlineDeelname', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      thenByIsOnlineDeelnameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOnlineDeelname', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      thenByLesuurTotMet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lesuurTotMet', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      thenByLesuurTotMetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lesuurTotMet', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenByLesuurVan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lesuurVan', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      thenByLesuurVanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lesuurVan', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenByLokatie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lokatie', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenByLokatieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lokatie', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      thenByOmschrijving() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'omschrijving', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      thenByOmschrijvingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'omschrijving', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenByOpdrachtId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'opdrachtId', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      thenByOpdrachtIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'opdrachtId', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenByRawInfoType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawInfoType', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      thenByRawInfoTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawInfoType', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenByRawInhoud() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawInhoud', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      thenByRawInhoudDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawInhoud', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenByRawLokatie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawLokatie', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      thenByRawLokatieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawLokatie', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenByRawStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawStatus', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      thenByRawStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawStatus', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenBySelfUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selfUrl', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenBySelfUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selfUrl', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenByStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'start', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenByStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'start', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenBySubtype() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtype', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenBySubtypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtype', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      thenByWeergaveType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weergaveType', Sort.asc);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QAfterSortBy>
      thenByWeergaveTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weergaveType', Sort.desc);
    });
  }
}

extension CalendarEventQueryWhereDistinct
    on QueryBuilder<CalendarEvent, CalendarEvent, QDistinct> {
  QueryBuilder<CalendarEvent, CalendarEvent, QDistinct> distinctByAangemaakt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'aangemaakt');
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QDistinct> distinctByAantekening(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'aantekening', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QDistinct> distinctByAfgerond() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'afgerond');
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QDistinct>
      distinctByDuurtHeleDag() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'duurtHeleDag');
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QDistinct> distinctByEinde() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'einde');
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QDistinct>
      distinctByExcludeFromAutoDND() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'excludeFromAutoDND');
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QDistinct> distinctByGewijzigd() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gewijzigd');
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QDistinct>
      distinctByHeeftBijlagen() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'heeftBijlagen');
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QDistinct>
      distinctByHerhaalStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'herhaalStatus');
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QDistinct> distinctById() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id');
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QDistinct> distinctByInfoType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'infoType');
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QDistinct> distinctByInhoud(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'inhoud', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QDistinct>
      distinctByIsOnlineDeelname() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isOnlineDeelname');
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QDistinct>
      distinctByLesuurTotMet() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lesuurTotMet');
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QDistinct> distinctByLesuurVan() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lesuurVan');
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QDistinct> distinctByLokatie(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lokatie', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QDistinct> distinctByOmschrijving(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'omschrijving', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QDistinct> distinctByOpdrachtId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'opdrachtId');
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QDistinct>
      distinctByRawInfoType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rawInfoType');
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QDistinct> distinctByRawInhoud(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rawInhoud', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QDistinct> distinctByRawLokatie(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rawLokatie', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QDistinct> distinctByRawStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rawStatus');
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QDistinct> distinctBySelfUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selfUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QDistinct> distinctByStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'start');
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QDistinct> distinctBySubtype() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subtype');
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }

  QueryBuilder<CalendarEvent, CalendarEvent, QDistinct>
      distinctByWeergaveType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weergaveType');
    });
  }
}

extension CalendarEventQueryProperty
    on QueryBuilder<CalendarEvent, CalendarEvent, QQueryProperty> {
  QueryBuilder<CalendarEvent, int, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }

  QueryBuilder<CalendarEvent, DateTime?, QQueryOperations>
      aangemaaktProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'aangemaakt');
    });
  }

  QueryBuilder<CalendarEvent, String?, QQueryOperations> aantekeningProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'aantekening');
    });
  }

  QueryBuilder<CalendarEvent, bool, QQueryOperations> afgerondProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'afgerond');
    });
  }

  QueryBuilder<CalendarEvent, Absence?, QQueryOperations>
      afwezigheidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'afwezigheid');
    });
  }

  QueryBuilder<CalendarEvent, CustomCalendarProperties?, QQueryOperations>
      customCalendarPropertiesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customCalendarProperties');
    });
  }

  QueryBuilder<CalendarEvent, List<Docenten>?, QQueryOperations>
      docentenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'docenten');
    });
  }

  QueryBuilder<CalendarEvent, bool, QQueryOperations> duurtHeleDagProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'duurtHeleDag');
    });
  }

  QueryBuilder<CalendarEvent, DateTime, QQueryOperations> eindeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'einde');
    });
  }

  QueryBuilder<CalendarEvent, bool, QQueryOperations>
      excludeFromAutoDNDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'excludeFromAutoDND');
    });
  }

  QueryBuilder<CalendarEvent, DateTime?, QQueryOperations> gewijzigdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gewijzigd');
    });
  }

  QueryBuilder<CalendarEvent, bool, QQueryOperations> heeftBijlagenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'heeftBijlagen');
    });
  }

  QueryBuilder<CalendarEvent, int, QQueryOperations> herhaalStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'herhaalStatus');
    });
  }

  QueryBuilder<CalendarEvent, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CalendarEvent, InfoType, QQueryOperations> infoTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'infoType');
    });
  }

  QueryBuilder<CalendarEvent, String?, QQueryOperations> inhoudProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'inhoud');
    });
  }

  QueryBuilder<CalendarEvent, bool, QQueryOperations>
      isOnlineDeelnameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isOnlineDeelname');
    });
  }

  QueryBuilder<CalendarEvent, int?, QQueryOperations> lesuurTotMetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lesuurTotMet');
    });
  }

  QueryBuilder<CalendarEvent, int?, QQueryOperations> lesuurVanProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lesuurVan');
    });
  }

  QueryBuilder<CalendarEvent, List<Lokalen>?, QQueryOperations>
      lokalenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lokalen');
    });
  }

  QueryBuilder<CalendarEvent, String?, QQueryOperations> lokatieProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lokatie');
    });
  }

  QueryBuilder<CalendarEvent, String?, QQueryOperations>
      omschrijvingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'omschrijving');
    });
  }

  QueryBuilder<CalendarEvent, int, QQueryOperations> opdrachtIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'opdrachtId');
    });
  }

  QueryBuilder<CalendarEvent, InfoType, QQueryOperations>
      rawInfoTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rawInfoType');
    });
  }

  QueryBuilder<CalendarEvent, String?, QQueryOperations> rawInhoudProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rawInhoud');
    });
  }

  QueryBuilder<CalendarEvent, String?, QQueryOperations> rawLokatieProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rawLokatie');
    });
  }

  QueryBuilder<CalendarEvent, Status, QQueryOperations> rawStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rawStatus');
    });
  }

  QueryBuilder<CalendarEvent, String?, QQueryOperations> selfUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selfUrl');
    });
  }

  QueryBuilder<CalendarEvent, DateTime, QQueryOperations> startProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'start');
    });
  }

  QueryBuilder<CalendarEvent, Status, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<CalendarEvent, int, QQueryOperations> subtypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subtype');
    });
  }

  QueryBuilder<CalendarEvent, CalendarType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<CalendarEvent, List<Vakken>?, QQueryOperations>
      vakkenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vakken');
    });
  }

  QueryBuilder<CalendarEvent, int, QQueryOperations> weergaveTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weergaveType');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const DocentenSchema = Schema(
  name: r'Docenten',
  id: 5899530930643084232,
  properties: {
    r'docentcode': PropertySchema(
      id: 0,
      name: r'docentcode',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 1,
      name: r'id',
      type: IsarType.long,
    ),
    r'naam': PropertySchema(
      id: 2,
      name: r'naam',
      type: IsarType.string,
    )
  },
  estimateSize: _docentenEstimateSize,
  serialize: _docentenSerialize,
  deserialize: _docentenDeserialize,
  deserializeProp: _docentenDeserializeProp,
);

int _docentenEstimateSize(
  Docenten object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.docentcode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.naam;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _docentenSerialize(
  Docenten object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.docentcode);
  writer.writeLong(offsets[1], object.id);
  writer.writeString(offsets[2], object.naam);
}

Docenten _docentenDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Docenten(
    docentcode: reader.readStringOrNull(offsets[0]),
    id: reader.readLongOrNull(offsets[1]) ?? 0,
    naam: reader.readStringOrNull(offsets[2]),
  );
  return object;
}

P _docentenDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension DocentenQueryFilter
    on QueryBuilder<Docenten, Docenten, QFilterCondition> {
  QueryBuilder<Docenten, Docenten, QAfterFilterCondition> docentcodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'docentcode',
      ));
    });
  }

  QueryBuilder<Docenten, Docenten, QAfterFilterCondition>
      docentcodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'docentcode',
      ));
    });
  }

  QueryBuilder<Docenten, Docenten, QAfterFilterCondition> docentcodeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'docentcode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Docenten, Docenten, QAfterFilterCondition> docentcodeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'docentcode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Docenten, Docenten, QAfterFilterCondition> docentcodeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'docentcode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Docenten, Docenten, QAfterFilterCondition> docentcodeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'docentcode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Docenten, Docenten, QAfterFilterCondition> docentcodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'docentcode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Docenten, Docenten, QAfterFilterCondition> docentcodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'docentcode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Docenten, Docenten, QAfterFilterCondition> docentcodeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'docentcode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Docenten, Docenten, QAfterFilterCondition> docentcodeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'docentcode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Docenten, Docenten, QAfterFilterCondition> docentcodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'docentcode',
        value: '',
      ));
    });
  }

  QueryBuilder<Docenten, Docenten, QAfterFilterCondition>
      docentcodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'docentcode',
        value: '',
      ));
    });
  }

  QueryBuilder<Docenten, Docenten, QAfterFilterCondition> idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Docenten, Docenten, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Docenten, Docenten, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Docenten, Docenten, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Docenten, Docenten, QAfterFilterCondition> naamIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'naam',
      ));
    });
  }

  QueryBuilder<Docenten, Docenten, QAfterFilterCondition> naamIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'naam',
      ));
    });
  }

  QueryBuilder<Docenten, Docenten, QAfterFilterCondition> naamEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'naam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Docenten, Docenten, QAfterFilterCondition> naamGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'naam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Docenten, Docenten, QAfterFilterCondition> naamLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'naam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Docenten, Docenten, QAfterFilterCondition> naamBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'naam',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Docenten, Docenten, QAfterFilterCondition> naamStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'naam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Docenten, Docenten, QAfterFilterCondition> naamEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'naam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Docenten, Docenten, QAfterFilterCondition> naamContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'naam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Docenten, Docenten, QAfterFilterCondition> naamMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'naam',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Docenten, Docenten, QAfterFilterCondition> naamIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'naam',
        value: '',
      ));
    });
  }

  QueryBuilder<Docenten, Docenten, QAfterFilterCondition> naamIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'naam',
        value: '',
      ));
    });
  }
}

extension DocentenQueryObject
    on QueryBuilder<Docenten, Docenten, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const VakkenSchema = Schema(
  name: r'Vakken',
  id: 161897197865961037,
  properties: {
    r'id': PropertySchema(
      id: 0,
      name: r'id',
      type: IsarType.long,
    ),
    r'naam': PropertySchema(
      id: 1,
      name: r'naam',
      type: IsarType.string,
    )
  },
  estimateSize: _vakkenEstimateSize,
  serialize: _vakkenSerialize,
  deserialize: _vakkenDeserialize,
  deserializeProp: _vakkenDeserializeProp,
);

int _vakkenEstimateSize(
  Vakken object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.naam;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _vakkenSerialize(
  Vakken object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.id);
  writer.writeString(offsets[1], object.naam);
}

Vakken _vakkenDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Vakken(
    id: reader.readLongOrNull(offsets[0]) ?? 0,
    naam: reader.readStringOrNull(offsets[1]),
  );
  return object;
}

P _vakkenDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension VakkenQueryFilter on QueryBuilder<Vakken, Vakken, QFilterCondition> {
  QueryBuilder<Vakken, Vakken, QAfterFilterCondition> idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Vakken, Vakken, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Vakken, Vakken, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Vakken, Vakken, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Vakken, Vakken, QAfterFilterCondition> naamIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'naam',
      ));
    });
  }

  QueryBuilder<Vakken, Vakken, QAfterFilterCondition> naamIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'naam',
      ));
    });
  }

  QueryBuilder<Vakken, Vakken, QAfterFilterCondition> naamEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'naam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Vakken, Vakken, QAfterFilterCondition> naamGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'naam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Vakken, Vakken, QAfterFilterCondition> naamLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'naam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Vakken, Vakken, QAfterFilterCondition> naamBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'naam',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Vakken, Vakken, QAfterFilterCondition> naamStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'naam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Vakken, Vakken, QAfterFilterCondition> naamEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'naam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Vakken, Vakken, QAfterFilterCondition> naamContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'naam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Vakken, Vakken, QAfterFilterCondition> naamMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'naam',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Vakken, Vakken, QAfterFilterCondition> naamIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'naam',
        value: '',
      ));
    });
  }

  QueryBuilder<Vakken, Vakken, QAfterFilterCondition> naamIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'naam',
        value: '',
      ));
    });
  }
}

extension VakkenQueryObject on QueryBuilder<Vakken, Vakken, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const LokalenSchema = Schema(
  name: r'Lokalen',
  id: -5703677483014504927,
  properties: {
    r'naam': PropertySchema(
      id: 0,
      name: r'naam',
      type: IsarType.string,
    )
  },
  estimateSize: _lokalenEstimateSize,
  serialize: _lokalenSerialize,
  deserialize: _lokalenDeserialize,
  deserializeProp: _lokalenDeserializeProp,
);

int _lokalenEstimateSize(
  Lokalen object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.naam;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _lokalenSerialize(
  Lokalen object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.naam);
}

Lokalen _lokalenDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Lokalen(
    naam: reader.readStringOrNull(offsets[0]),
  );
  return object;
}

P _lokalenDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension LokalenQueryFilter
    on QueryBuilder<Lokalen, Lokalen, QFilterCondition> {
  QueryBuilder<Lokalen, Lokalen, QAfterFilterCondition> naamIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'naam',
      ));
    });
  }

  QueryBuilder<Lokalen, Lokalen, QAfterFilterCondition> naamIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'naam',
      ));
    });
  }

  QueryBuilder<Lokalen, Lokalen, QAfterFilterCondition> naamEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'naam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Lokalen, Lokalen, QAfterFilterCondition> naamGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'naam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Lokalen, Lokalen, QAfterFilterCondition> naamLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'naam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Lokalen, Lokalen, QAfterFilterCondition> naamBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'naam',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Lokalen, Lokalen, QAfterFilterCondition> naamStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'naam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Lokalen, Lokalen, QAfterFilterCondition> naamEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'naam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Lokalen, Lokalen, QAfterFilterCondition> naamContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'naam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Lokalen, Lokalen, QAfterFilterCondition> naamMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'naam',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Lokalen, Lokalen, QAfterFilterCondition> naamIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'naam',
        value: '',
      ));
    });
  }

  QueryBuilder<Lokalen, Lokalen, QAfterFilterCondition> naamIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'naam',
        value: '',
      ));
    });
  }
}

extension LokalenQueryObject
    on QueryBuilder<Lokalen, Lokalen, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const AbsenceSchema = Schema(
  name: r'Absence',
  id: -7247862397841850355,
  properties: {
    r'afspraakId': PropertySchema(
      id: 0,
      name: r'afspraakId',
      type: IsarType.long,
    ),
    r'code': PropertySchema(
      id: 1,
      name: r'code',
      type: IsarType.string,
    ),
    r'eind': PropertySchema(
      id: 2,
      name: r'eind',
      type: IsarType.dateTime,
    ),
    r'geoorloofd': PropertySchema(
      id: 3,
      name: r'geoorloofd',
      type: IsarType.bool,
    ),
    r'id': PropertySchema(
      id: 4,
      name: r'id',
      type: IsarType.long,
    ),
    r'lesuur': PropertySchema(
      id: 5,
      name: r'lesuur',
      type: IsarType.long,
    ),
    r'omschrijving': PropertySchema(
      id: 6,
      name: r'omschrijving',
      type: IsarType.string,
    ),
    r'start': PropertySchema(
      id: 7,
      name: r'start',
      type: IsarType.dateTime,
    ),
    r'verantwoordingtype': PropertySchema(
      id: 8,
      name: r'verantwoordingtype',
      type: IsarType.byte,
      enumMap: _AbsenceverantwoordingtypeEnumValueMap,
    )
  },
  estimateSize: _absenceEstimateSize,
  serialize: _absenceSerialize,
  deserialize: _absenceDeserialize,
  deserializeProp: _absenceDeserializeProp,
);

int _absenceEstimateSize(
  Absence object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.code.length * 3;
  bytesCount += 3 + object.omschrijving.length * 3;
  return bytesCount;
}

void _absenceSerialize(
  Absence object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.afspraakId);
  writer.writeString(offsets[1], object.code);
  writer.writeDateTime(offsets[2], object.eind);
  writer.writeBool(offsets[3], object.geoorloofd);
  writer.writeLong(offsets[4], object.id);
  writer.writeLong(offsets[5], object.lesuur);
  writer.writeString(offsets[6], object.omschrijving);
  writer.writeDateTime(offsets[7], object.start);
  writer.writeByte(offsets[8], object.verantwoordingtype.index);
}

Absence _absenceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Absence(
    afspraakId: reader.readLongOrNull(offsets[0]) ?? 0,
    code: reader.readStringOrNull(offsets[1]) ?? "??",
    eind: reader.readDateTimeOrNull(offsets[2]),
    geoorloofd: reader.readBoolOrNull(offsets[3]) ?? true,
    id: reader.readLongOrNull(offsets[4]) ?? 0,
    lesuur: reader.readLongOrNull(offsets[5]) ?? 0,
    omschrijving: reader.readStringOrNull(offsets[6]) ?? "No data",
    start: reader.readDateTimeOrNull(offsets[7]),
    verantwoordingtype: _AbsenceverantwoordingtypeValueEnumMap[
            reader.readByteOrNull(offsets[8])] ??
        AbsenceType.unknown,
  );
  return object;
}

P _absenceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? "??") as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 4:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 5:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 6:
      return (reader.readStringOrNull(offset) ?? "No data") as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 8:
      return (_AbsenceverantwoordingtypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          AbsenceType.unknown) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _AbsenceverantwoordingtypeEnumValueMap = {
  'absent': 0,
  'late': 1,
  'sick': 2,
  'discharged': 3,
  'exemption': 4,
  'books': 5,
  'homework': 6,
  'unknown': 7,
};
const _AbsenceverantwoordingtypeValueEnumMap = {
  0: AbsenceType.absent,
  1: AbsenceType.late,
  2: AbsenceType.sick,
  3: AbsenceType.discharged,
  4: AbsenceType.exemption,
  5: AbsenceType.books,
  6: AbsenceType.homework,
  7: AbsenceType.unknown,
};

extension AbsenceQueryFilter
    on QueryBuilder<Absence, Absence, QFilterCondition> {
  QueryBuilder<Absence, Absence, QAfterFilterCondition> afspraakIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'afspraakId',
        value: value,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> afspraakIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'afspraakId',
        value: value,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> afspraakIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'afspraakId',
        value: value,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> afspraakIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'afspraakId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> codeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> codeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> codeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> codeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'code',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> codeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> codeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> codeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> codeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'code',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> codeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'code',
        value: '',
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> codeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'code',
        value: '',
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> eindIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'eind',
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> eindIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'eind',
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> eindEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eind',
        value: value,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> eindGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eind',
        value: value,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> eindLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eind',
        value: value,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> eindBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eind',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> geoorloofdEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'geoorloofd',
        value: value,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Absence, Absence, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Absence, Absence, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Absence, Absence, QAfterFilterCondition> lesuurEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lesuur',
        value: value,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> lesuurGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lesuur',
        value: value,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> lesuurLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lesuur',
        value: value,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> lesuurBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lesuur',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> omschrijvingEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'omschrijving',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> omschrijvingGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'omschrijving',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> omschrijvingLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'omschrijving',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> omschrijvingBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'omschrijving',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> omschrijvingStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'omschrijving',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> omschrijvingEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'omschrijving',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> omschrijvingContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'omschrijving',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> omschrijvingMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'omschrijving',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> omschrijvingIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'omschrijving',
        value: '',
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition>
      omschrijvingIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'omschrijving',
        value: '',
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> startIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'start',
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> startIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'start',
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> startEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'start',
        value: value,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> startGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'start',
        value: value,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> startLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'start',
        value: value,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition> startBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'start',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition>
      verantwoordingtypeEqualTo(AbsenceType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verantwoordingtype',
        value: value,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition>
      verantwoordingtypeGreaterThan(
    AbsenceType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'verantwoordingtype',
        value: value,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition>
      verantwoordingtypeLessThan(
    AbsenceType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'verantwoordingtype',
        value: value,
      ));
    });
  }

  QueryBuilder<Absence, Absence, QAfterFilterCondition>
      verantwoordingtypeBetween(
    AbsenceType lower,
    AbsenceType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'verantwoordingtype',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AbsenceQueryObject
    on QueryBuilder<Absence, Absence, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const CustomCalendarPropertiesSchema = Schema(
  name: r'CustomCalendarProperties',
  id: 5751158405299993516,
  properties: {
    r'infotypeChanged': PropertySchema(
      id: 0,
      name: r'infotypeChanged',
      type: IsarType.dateTime,
    ),
    r'inhoudChanged': PropertySchema(
      id: 1,
      name: r'inhoudChanged',
      type: IsarType.dateTime,
    ),
    r'inhoudOriginal': PropertySchema(
      id: 2,
      name: r'inhoudOriginal',
      type: IsarType.string,
    ),
    r'lokatieChanged': PropertySchema(
      id: 3,
      name: r'lokatieChanged',
      type: IsarType.dateTime,
    ),
    r'lokatieOriginal': PropertySchema(
      id: 4,
      name: r'lokatieOriginal',
      type: IsarType.string,
    ),
    r'rawInfotype': PropertySchema(
      id: 5,
      name: r'rawInfotype',
      type: IsarType.long,
    ),
    r'rawInfotypeOriginal': PropertySchema(
      id: 6,
      name: r'rawInfotypeOriginal',
      type: IsarType.long,
    ),
    r'rawInhoud': PropertySchema(
      id: 7,
      name: r'rawInhoud',
      type: IsarType.string,
    ),
    r'rawLokatie': PropertySchema(
      id: 8,
      name: r'rawLokatie',
      type: IsarType.string,
    ),
    r'rawStatus': PropertySchema(
      id: 9,
      name: r'rawStatus',
      type: IsarType.long,
    ),
    r'rawStatusOriginal': PropertySchema(
      id: 10,
      name: r'rawStatusOriginal',
      type: IsarType.long,
    ),
    r'statusChanged': PropertySchema(
      id: 11,
      name: r'statusChanged',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _customCalendarPropertiesEstimateSize,
  serialize: _customCalendarPropertiesSerialize,
  deserialize: _customCalendarPropertiesDeserialize,
  deserializeProp: _customCalendarPropertiesDeserializeProp,
);

int _customCalendarPropertiesEstimateSize(
  CustomCalendarProperties object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.inhoudOriginal;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lokatieOriginal;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.rawInhoud;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.rawLokatie;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _customCalendarPropertiesSerialize(
  CustomCalendarProperties object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.infotypeChanged);
  writer.writeDateTime(offsets[1], object.inhoudChanged);
  writer.writeString(offsets[2], object.inhoudOriginal);
  writer.writeDateTime(offsets[3], object.lokatieChanged);
  writer.writeString(offsets[4], object.lokatieOriginal);
  writer.writeLong(offsets[5], object.rawInfotype);
  writer.writeLong(offsets[6], object.rawInfotypeOriginal);
  writer.writeString(offsets[7], object.rawInhoud);
  writer.writeString(offsets[8], object.rawLokatie);
  writer.writeLong(offsets[9], object.rawStatus);
  writer.writeLong(offsets[10], object.rawStatusOriginal);
  writer.writeDateTime(offsets[11], object.statusChanged);
}

CustomCalendarProperties _customCalendarPropertiesDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CustomCalendarProperties(
    infotypeChanged: reader.readDateTimeOrNull(offsets[0]),
    inhoudChanged: reader.readDateTimeOrNull(offsets[1]),
    inhoudOriginal: reader.readStringOrNull(offsets[2]),
    lokatieChanged: reader.readDateTimeOrNull(offsets[3]),
    lokatieOriginal: reader.readStringOrNull(offsets[4]),
    rawInfotype: reader.readLongOrNull(offsets[5]),
    rawInfotypeOriginal: reader.readLongOrNull(offsets[6]),
    rawInhoud: reader.readStringOrNull(offsets[7]),
    rawLokatie: reader.readStringOrNull(offsets[8]),
    rawStatus: reader.readLongOrNull(offsets[9]),
    rawStatusOriginal: reader.readLongOrNull(offsets[10]),
    statusChanged: reader.readDateTimeOrNull(offsets[11]),
  );
  return object;
}

P _customCalendarPropertiesDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    case 11:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension CustomCalendarPropertiesQueryFilter on QueryBuilder<
    CustomCalendarProperties, CustomCalendarProperties, QFilterCondition> {
  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> infotypeChangedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'infotypeChanged',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> infotypeChangedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'infotypeChanged',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> infotypeChangedEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'infotypeChanged',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> infotypeChangedGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'infotypeChanged',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> infotypeChangedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'infotypeChanged',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> infotypeChangedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'infotypeChanged',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> inhoudChangedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'inhoudChanged',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> inhoudChangedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'inhoudChanged',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> inhoudChangedEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'inhoudChanged',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> inhoudChangedGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'inhoudChanged',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> inhoudChangedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'inhoudChanged',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> inhoudChangedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'inhoudChanged',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> inhoudOriginalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'inhoudOriginal',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> inhoudOriginalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'inhoudOriginal',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> inhoudOriginalEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'inhoudOriginal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> inhoudOriginalGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'inhoudOriginal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> inhoudOriginalLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'inhoudOriginal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> inhoudOriginalBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'inhoudOriginal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> inhoudOriginalStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'inhoudOriginal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> inhoudOriginalEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'inhoudOriginal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
          QAfterFilterCondition>
      inhoudOriginalContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'inhoudOriginal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
          QAfterFilterCondition>
      inhoudOriginalMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'inhoudOriginal',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> inhoudOriginalIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'inhoudOriginal',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> inhoudOriginalIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'inhoudOriginal',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> lokatieChangedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lokatieChanged',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> lokatieChangedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lokatieChanged',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> lokatieChangedEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lokatieChanged',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> lokatieChangedGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lokatieChanged',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> lokatieChangedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lokatieChanged',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> lokatieChangedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lokatieChanged',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> lokatieOriginalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lokatieOriginal',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> lokatieOriginalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lokatieOriginal',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> lokatieOriginalEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lokatieOriginal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> lokatieOriginalGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lokatieOriginal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> lokatieOriginalLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lokatieOriginal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> lokatieOriginalBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lokatieOriginal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> lokatieOriginalStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lokatieOriginal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> lokatieOriginalEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lokatieOriginal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
          QAfterFilterCondition>
      lokatieOriginalContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lokatieOriginal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
          QAfterFilterCondition>
      lokatieOriginalMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lokatieOriginal',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> lokatieOriginalIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lokatieOriginal',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> lokatieOriginalIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lokatieOriginal',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawInfotypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rawInfotype',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawInfotypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rawInfotype',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawInfotypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawInfotype',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawInfotypeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawInfotype',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawInfotypeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawInfotype',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawInfotypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawInfotype',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawInfotypeOriginalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rawInfotypeOriginal',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawInfotypeOriginalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rawInfotypeOriginal',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawInfotypeOriginalEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawInfotypeOriginal',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawInfotypeOriginalGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawInfotypeOriginal',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawInfotypeOriginalLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawInfotypeOriginal',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawInfotypeOriginalBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawInfotypeOriginal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawInhoudIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rawInhoud',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawInhoudIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rawInhoud',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawInhoudEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawInhoud',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawInhoudGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawInhoud',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawInhoudLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawInhoud',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawInhoudBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawInhoud',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawInhoudStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rawInhoud',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawInhoudEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rawInhoud',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
          QAfterFilterCondition>
      rawInhoudContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rawInhoud',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
          QAfterFilterCondition>
      rawInhoudMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rawInhoud',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawInhoudIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawInhoud',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawInhoudIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rawInhoud',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawLokatieIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rawLokatie',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawLokatieIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rawLokatie',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawLokatieEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawLokatie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawLokatieGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawLokatie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawLokatieLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawLokatie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawLokatieBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawLokatie',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawLokatieStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rawLokatie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawLokatieEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rawLokatie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
          QAfterFilterCondition>
      rawLokatieContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rawLokatie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
          QAfterFilterCondition>
      rawLokatieMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rawLokatie',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawLokatieIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawLokatie',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawLokatieIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rawLokatie',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawStatusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rawStatus',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawStatusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rawStatus',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawStatusEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawStatusGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawStatusLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawStatusBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawStatusOriginalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rawStatusOriginal',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawStatusOriginalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rawStatusOriginal',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawStatusOriginalEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawStatusOriginal',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawStatusOriginalGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawStatusOriginal',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawStatusOriginalLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawStatusOriginal',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> rawStatusOriginalBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawStatusOriginal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> statusChangedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'statusChanged',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> statusChangedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'statusChanged',
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> statusChangedEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statusChanged',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> statusChangedGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'statusChanged',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> statusChangedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'statusChanged',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomCalendarProperties, CustomCalendarProperties,
      QAfterFilterCondition> statusChangedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'statusChanged',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CustomCalendarPropertiesQueryObject on QueryBuilder<
    CustomCalendarProperties, CustomCalendarProperties, QFilterCondition> {}
