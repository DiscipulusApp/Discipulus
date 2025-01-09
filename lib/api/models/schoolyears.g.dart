// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schoolyears.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSchoolyearCollection on Isar {
  IsarCollection<Schoolyear> get schoolyears => this.collection();
}

const SchoolyearSchema = CollectionSchema(
  name: r'Schoolyear',
  id: -6954828166610526055,
  properties: {
    r'begin': PropertySchema(
      id: 0,
      name: r'begin',
      type: IsarType.dateTime,
    ),
    r'einde': PropertySchema(
      id: 1,
      name: r'einde',
      type: IsarType.dateTime,
    ),
    r'groep': PropertySchema(
      id: 2,
      name: r'groep',
      type: IsarType.object,
      target: r'Groep',
    ),
    r'id': PropertySchema(
      id: 3,
      name: r'id',
      type: IsarType.long,
    ),
    r'indicatie': PropertySchema(
      id: 4,
      name: r'indicatie',
      type: IsarType.string,
    ),
    r'isHoofdAanmelding': PropertySchema(
      id: 5,
      name: r'isHoofdAanmelding',
      type: IsarType.bool,
    ),
    r'isZittenBlijver': PropertySchema(
      id: 6,
      name: r'isZittenBlijver',
      type: IsarType.bool,
    ),
    r'lesperiode': PropertySchema(
      id: 7,
      name: r'lesperiode',
      type: IsarType.object,
      target: r'Lesperiode',
    ),
    r'opleidingCode': PropertySchema(
      id: 8,
      name: r'opleidingCode',
      type: IsarType.object,
      target: r'OpleidingCode',
    ),
    r'persoonlijkeMentor': PropertySchema(
      id: 9,
      name: r'persoonlijkeMentor',
      type: IsarType.object,
      target: r'PersoonlijkeMentor',
    ),
    r'profielen': PropertySchema(
      id: 10,
      name: r'profielen',
      type: IsarType.objectList,
      target: r'Groep',
    ),
    r'studie': PropertySchema(
      id: 11,
      name: r'studie',
      type: IsarType.object,
      target: r'Groep',
    )
  },
  estimateSize: _schoolyearEstimateSize,
  serialize: _schoolyearSerialize,
  deserialize: _schoolyearDeserialize,
  deserializeProp: _schoolyearDeserializeProp,
  idName: r'uuid',
  indexes: {},
  links: {
    r'profile': LinkSchema(
      id: -5147113010263410565,
      name: r'profile',
      target: r'Profile',
      single: true,
      linkName: r'schoolyears',
    ),
    r'grades': LinkSchema(
      id: -7282358687597856915,
      name: r'grades',
      target: r'Grade',
      single: false,
    ),
    r'periods': LinkSchema(
      id: -5899003679300814444,
      name: r'periods',
      target: r'GradePeriod',
      single: false,
    ),
    r'subjects': LinkSchema(
      id: -9098510550281770251,
      name: r'subjects',
      target: r'Subject',
      single: false,
    )
  },
  embeddedSchemas: {
    r'Groep': GroepSchema,
    r'Lesperiode': LesperiodeSchema,
    r'PersoonlijkeMentor': PersoonlijkeMentorSchema,
    r'OpleidingCode': OpleidingCodeSchema
  },
  getId: _schoolyearGetId,
  getLinks: _schoolyearGetLinks,
  attach: _schoolyearAttach,
  version: '3.1.0+1',
);

int _schoolyearEstimateSize(
  Schoolyear object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 +
      GroepSchema.estimateSize(object.groep, allOffsets[Groep]!, allOffsets);
  {
    final value = object.indicatie;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 +
      LesperiodeSchema.estimateSize(
          object.lesperiode, allOffsets[Lesperiode]!, allOffsets);
  {
    final value = object.opleidingCode;
    if (value != null) {
      bytesCount += 3 +
          OpleidingCodeSchema.estimateSize(
              value, allOffsets[OpleidingCode]!, allOffsets);
    }
  }
  {
    final value = object.persoonlijkeMentor;
    if (value != null) {
      bytesCount += 3 +
          PersoonlijkeMentorSchema.estimateSize(
              value, allOffsets[PersoonlijkeMentor]!, allOffsets);
    }
  }
  bytesCount += 3 + object.profielen.length * 3;
  {
    final offsets = allOffsets[Groep]!;
    for (var i = 0; i < object.profielen.length; i++) {
      final value = object.profielen[i];
      bytesCount += GroepSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 +
      GroepSchema.estimateSize(object.studie, allOffsets[Groep]!, allOffsets);
  return bytesCount;
}

void _schoolyearSerialize(
  Schoolyear object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.begin);
  writer.writeDateTime(offsets[1], object.einde);
  writer.writeObject<Groep>(
    offsets[2],
    allOffsets,
    GroepSchema.serialize,
    object.groep,
  );
  writer.writeLong(offsets[3], object.id);
  writer.writeString(offsets[4], object.indicatie);
  writer.writeBool(offsets[5], object.isHoofdAanmelding);
  writer.writeBool(offsets[6], object.isZittenBlijver);
  writer.writeObject<Lesperiode>(
    offsets[7],
    allOffsets,
    LesperiodeSchema.serialize,
    object.lesperiode,
  );
  writer.writeObject<OpleidingCode>(
    offsets[8],
    allOffsets,
    OpleidingCodeSchema.serialize,
    object.opleidingCode,
  );
  writer.writeObject<PersoonlijkeMentor>(
    offsets[9],
    allOffsets,
    PersoonlijkeMentorSchema.serialize,
    object.persoonlijkeMentor,
  );
  writer.writeObjectList<Groep>(
    offsets[10],
    allOffsets,
    GroepSchema.serialize,
    object.profielen,
  );
  writer.writeObject<Groep>(
    offsets[11],
    allOffsets,
    GroepSchema.serialize,
    object.studie,
  );
}

Schoolyear _schoolyearDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Schoolyear(
    begin: reader.readDateTime(offsets[0]),
    einde: reader.readDateTime(offsets[1]),
    groep: reader.readObjectOrNull<Groep>(
          offsets[2],
          GroepSchema.deserialize,
          allOffsets,
        ) ??
        Groep(),
    id: reader.readLongOrNull(offsets[3]),
    indicatie: reader.readStringOrNull(offsets[4]),
    isHoofdAanmelding: reader.readBoolOrNull(offsets[5]),
    isZittenBlijver: reader.readBoolOrNull(offsets[6]),
    lesperiode: reader.readObjectOrNull<Lesperiode>(
          offsets[7],
          LesperiodeSchema.deserialize,
          allOffsets,
        ) ??
        Lesperiode(),
    opleidingCode: reader.readObjectOrNull<OpleidingCode>(
      offsets[8],
      OpleidingCodeSchema.deserialize,
      allOffsets,
    ),
    persoonlijkeMentor: reader.readObjectOrNull<PersoonlijkeMentor>(
      offsets[9],
      PersoonlijkeMentorSchema.deserialize,
      allOffsets,
    ),
    profielen: reader.readObjectList<Groep>(
          offsets[10],
          GroepSchema.deserialize,
          allOffsets,
          Groep(),
        ) ??
        [],
    studie: reader.readObjectOrNull<Groep>(
          offsets[11],
          GroepSchema.deserialize,
          allOffsets,
        ) ??
        Groep(),
  );
  return object;
}

P _schoolyearDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readObjectOrNull<Groep>(
            offset,
            GroepSchema.deserialize,
            allOffsets,
          ) ??
          Groep()) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readBoolOrNull(offset)) as P;
    case 6:
      return (reader.readBoolOrNull(offset)) as P;
    case 7:
      return (reader.readObjectOrNull<Lesperiode>(
            offset,
            LesperiodeSchema.deserialize,
            allOffsets,
          ) ??
          Lesperiode()) as P;
    case 8:
      return (reader.readObjectOrNull<OpleidingCode>(
        offset,
        OpleidingCodeSchema.deserialize,
        allOffsets,
      )) as P;
    case 9:
      return (reader.readObjectOrNull<PersoonlijkeMentor>(
        offset,
        PersoonlijkeMentorSchema.deserialize,
        allOffsets,
      )) as P;
    case 10:
      return (reader.readObjectList<Groep>(
            offset,
            GroepSchema.deserialize,
            allOffsets,
            Groep(),
          ) ??
          []) as P;
    case 11:
      return (reader.readObjectOrNull<Groep>(
            offset,
            GroepSchema.deserialize,
            allOffsets,
          ) ??
          Groep()) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _schoolyearGetId(Schoolyear object) {
  return object.uuid;
}

List<IsarLinkBase<dynamic>> _schoolyearGetLinks(Schoolyear object) {
  return [object.profile, object.grades, object.periods, object.subjects];
}

void _schoolyearAttach(IsarCollection<dynamic> col, Id id, Schoolyear object) {
  object.profile.attach(col, col.isar.collection<Profile>(), r'profile', id);
  object.grades.attach(col, col.isar.collection<Grade>(), r'grades', id);
  object.periods
      .attach(col, col.isar.collection<GradePeriod>(), r'periods', id);
  object.subjects.attach(col, col.isar.collection<Subject>(), r'subjects', id);
}

extension SchoolyearQueryWhereSort
    on QueryBuilder<Schoolyear, Schoolyear, QWhere> {
  QueryBuilder<Schoolyear, Schoolyear, QAfterWhere> anyUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SchoolyearQueryWhere
    on QueryBuilder<Schoolyear, Schoolyear, QWhereClause> {
  QueryBuilder<Schoolyear, Schoolyear, QAfterWhereClause> uuidEqualTo(Id uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: uuid,
        upper: uuid,
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterWhereClause> uuidNotEqualTo(
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

  QueryBuilder<Schoolyear, Schoolyear, QAfterWhereClause> uuidGreaterThan(
      Id uuid,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: uuid, includeLower: include),
      );
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterWhereClause> uuidLessThan(Id uuid,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: uuid, includeUpper: include),
      );
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterWhereClause> uuidBetween(
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

extension SchoolyearQueryFilter
    on QueryBuilder<Schoolyear, Schoolyear, QFilterCondition> {
  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> beginEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'begin',
        value: value,
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> beginGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'begin',
        value: value,
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> beginLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'begin',
        value: value,
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> beginBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'begin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> eindeEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'einde',
        value: value,
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> eindeGreaterThan(
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

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> eindeLessThan(
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

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> eindeBetween(
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

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> idEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> idGreaterThan(
    int? value, {
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

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> idLessThan(
    int? value, {
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

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> idBetween(
    int? lower,
    int? upper, {
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

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      indicatieIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'indicatie',
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      indicatieIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'indicatie',
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> indicatieEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'indicatie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      indicatieGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'indicatie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> indicatieLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'indicatie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> indicatieBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'indicatie',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      indicatieStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'indicatie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> indicatieEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'indicatie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> indicatieContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'indicatie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> indicatieMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'indicatie',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      indicatieIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'indicatie',
        value: '',
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      indicatieIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'indicatie',
        value: '',
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      isHoofdAanmeldingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isHoofdAanmelding',
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      isHoofdAanmeldingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isHoofdAanmelding',
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      isHoofdAanmeldingEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isHoofdAanmelding',
        value: value,
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      isZittenBlijverIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isZittenBlijver',
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      isZittenBlijverIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isZittenBlijver',
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      isZittenBlijverEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isZittenBlijver',
        value: value,
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      opleidingCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'opleidingCode',
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      opleidingCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'opleidingCode',
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      persoonlijkeMentorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'persoonlijkeMentor',
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      persoonlijkeMentorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'persoonlijkeMentor',
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      profielenLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'profielen',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      profielenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'profielen',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      profielenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'profielen',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      profielenLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'profielen',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      profielenLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'profielen',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      profielenLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'profielen',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> uuidEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
      ));
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> uuidGreaterThan(
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

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> uuidLessThan(
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

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> uuidBetween(
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
}

extension SchoolyearQueryObject
    on QueryBuilder<Schoolyear, Schoolyear, QFilterCondition> {
  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> groep(
      FilterQuery<Groep> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'groep');
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> lesperiode(
      FilterQuery<Lesperiode> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'lesperiode');
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> opleidingCode(
      FilterQuery<OpleidingCode> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'opleidingCode');
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      persoonlijkeMentor(FilterQuery<PersoonlijkeMentor> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'persoonlijkeMentor');
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> profielenElement(
      FilterQuery<Groep> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'profielen');
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> studie(
      FilterQuery<Groep> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'studie');
    });
  }
}

extension SchoolyearQueryLinks
    on QueryBuilder<Schoolyear, Schoolyear, QFilterCondition> {
  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> profile(
      FilterQuery<Profile> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'profile');
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> profileIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'profile', 0, true, 0, true);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> grades(
      FilterQuery<Grade> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'grades');
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      gradesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'grades', length, true, length, true);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> gradesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'grades', 0, true, 0, true);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      gradesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'grades', 0, false, 999999, true);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      gradesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'grades', 0, true, length, include);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      gradesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'grades', length, include, 999999, true);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      gradesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'grades', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> periods(
      FilterQuery<GradePeriod> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'periods');
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      periodsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'periods', length, true, length, true);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> periodsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'periods', 0, true, 0, true);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      periodsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'periods', 0, false, 999999, true);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      periodsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'periods', 0, true, length, include);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      periodsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'periods', length, include, 999999, true);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      periodsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'periods', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition> subjects(
      FilterQuery<Subject> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'subjects');
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      subjectsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'subjects', length, true, length, true);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      subjectsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'subjects', 0, true, 0, true);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      subjectsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'subjects', 0, false, 999999, true);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      subjectsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'subjects', 0, true, length, include);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      subjectsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'subjects', length, include, 999999, true);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterFilterCondition>
      subjectsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'subjects', lower, includeLower, upper, includeUpper);
    });
  }
}

extension SchoolyearQuerySortBy
    on QueryBuilder<Schoolyear, Schoolyear, QSortBy> {
  QueryBuilder<Schoolyear, Schoolyear, QAfterSortBy> sortByBegin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'begin', Sort.asc);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterSortBy> sortByBeginDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'begin', Sort.desc);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterSortBy> sortByEinde() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'einde', Sort.asc);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterSortBy> sortByEindeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'einde', Sort.desc);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterSortBy> sortByIndicatie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'indicatie', Sort.asc);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterSortBy> sortByIndicatieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'indicatie', Sort.desc);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterSortBy> sortByIsHoofdAanmelding() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isHoofdAanmelding', Sort.asc);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterSortBy>
      sortByIsHoofdAanmeldingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isHoofdAanmelding', Sort.desc);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterSortBy> sortByIsZittenBlijver() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isZittenBlijver', Sort.asc);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterSortBy>
      sortByIsZittenBlijverDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isZittenBlijver', Sort.desc);
    });
  }
}

extension SchoolyearQuerySortThenBy
    on QueryBuilder<Schoolyear, Schoolyear, QSortThenBy> {
  QueryBuilder<Schoolyear, Schoolyear, QAfterSortBy> thenByBegin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'begin', Sort.asc);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterSortBy> thenByBeginDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'begin', Sort.desc);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterSortBy> thenByEinde() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'einde', Sort.asc);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterSortBy> thenByEindeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'einde', Sort.desc);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterSortBy> thenByIndicatie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'indicatie', Sort.asc);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterSortBy> thenByIndicatieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'indicatie', Sort.desc);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterSortBy> thenByIsHoofdAanmelding() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isHoofdAanmelding', Sort.asc);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterSortBy>
      thenByIsHoofdAanmeldingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isHoofdAanmelding', Sort.desc);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterSortBy> thenByIsZittenBlijver() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isZittenBlijver', Sort.asc);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterSortBy>
      thenByIsZittenBlijverDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isZittenBlijver', Sort.desc);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension SchoolyearQueryWhereDistinct
    on QueryBuilder<Schoolyear, Schoolyear, QDistinct> {
  QueryBuilder<Schoolyear, Schoolyear, QDistinct> distinctByBegin() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'begin');
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QDistinct> distinctByEinde() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'einde');
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QDistinct> distinctById() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id');
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QDistinct> distinctByIndicatie(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'indicatie', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QDistinct>
      distinctByIsHoofdAanmelding() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isHoofdAanmelding');
    });
  }

  QueryBuilder<Schoolyear, Schoolyear, QDistinct> distinctByIsZittenBlijver() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isZittenBlijver');
    });
  }
}

extension SchoolyearQueryProperty
    on QueryBuilder<Schoolyear, Schoolyear, QQueryProperty> {
  QueryBuilder<Schoolyear, int, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }

  QueryBuilder<Schoolyear, DateTime, QQueryOperations> beginProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'begin');
    });
  }

  QueryBuilder<Schoolyear, DateTime, QQueryOperations> eindeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'einde');
    });
  }

  QueryBuilder<Schoolyear, Groep, QQueryOperations> groepProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groep');
    });
  }

  QueryBuilder<Schoolyear, int?, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Schoolyear, String?, QQueryOperations> indicatieProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'indicatie');
    });
  }

  QueryBuilder<Schoolyear, bool?, QQueryOperations>
      isHoofdAanmeldingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isHoofdAanmelding');
    });
  }

  QueryBuilder<Schoolyear, bool?, QQueryOperations> isZittenBlijverProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isZittenBlijver');
    });
  }

  QueryBuilder<Schoolyear, Lesperiode, QQueryOperations> lesperiodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lesperiode');
    });
  }

  QueryBuilder<Schoolyear, OpleidingCode?, QQueryOperations>
      opleidingCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'opleidingCode');
    });
  }

  QueryBuilder<Schoolyear, PersoonlijkeMentor?, QQueryOperations>
      persoonlijkeMentorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'persoonlijkeMentor');
    });
  }

  QueryBuilder<Schoolyear, List<Groep>, QQueryOperations> profielenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'profielen');
    });
  }

  QueryBuilder<Schoolyear, Groep, QQueryOperations> studieProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'studie');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const GroepSchema = Schema(
  name: r'Groep',
  id: -678355625717658135,
  properties: {
    r'code': PropertySchema(
      id: 0,
      name: r'code',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 1,
      name: r'id',
      type: IsarType.long,
    ),
    r'omschrijving': PropertySchema(
      id: 2,
      name: r'omschrijving',
      type: IsarType.string,
    )
  },
  estimateSize: _groepEstimateSize,
  serialize: _groepSerialize,
  deserialize: _groepDeserialize,
  deserializeProp: _groepDeserializeProp,
);

int _groepEstimateSize(
  Groep object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.code.length * 3;
  {
    final value = object.omschrijving;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _groepSerialize(
  Groep object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.code);
  writer.writeLong(offsets[1], object.id);
  writer.writeString(offsets[2], object.omschrijving);
}

Groep _groepDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Groep(
    code: reader.readStringOrNull(offsets[0]) ?? "",
    id: reader.readLongOrNull(offsets[1]),
    omschrijving: reader.readStringOrNull(offsets[2]),
  );
  return object;
}

P _groepDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension GroepQueryFilter on QueryBuilder<Groep, Groep, QFilterCondition> {
  QueryBuilder<Groep, Groep, QAfterFilterCondition> codeEqualTo(
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

  QueryBuilder<Groep, Groep, QAfterFilterCondition> codeGreaterThan(
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

  QueryBuilder<Groep, Groep, QAfterFilterCondition> codeLessThan(
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

  QueryBuilder<Groep, Groep, QAfterFilterCondition> codeBetween(
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

  QueryBuilder<Groep, Groep, QAfterFilterCondition> codeStartsWith(
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

  QueryBuilder<Groep, Groep, QAfterFilterCondition> codeEndsWith(
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

  QueryBuilder<Groep, Groep, QAfterFilterCondition> codeContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Groep, Groep, QAfterFilterCondition> codeMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'code',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Groep, Groep, QAfterFilterCondition> codeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'code',
        value: '',
      ));
    });
  }

  QueryBuilder<Groep, Groep, QAfterFilterCondition> codeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'code',
        value: '',
      ));
    });
  }

  QueryBuilder<Groep, Groep, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Groep, Groep, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Groep, Groep, QAfterFilterCondition> idEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Groep, Groep, QAfterFilterCondition> idGreaterThan(
    int? value, {
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

  QueryBuilder<Groep, Groep, QAfterFilterCondition> idLessThan(
    int? value, {
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

  QueryBuilder<Groep, Groep, QAfterFilterCondition> idBetween(
    int? lower,
    int? upper, {
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

  QueryBuilder<Groep, Groep, QAfterFilterCondition> omschrijvingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'omschrijving',
      ));
    });
  }

  QueryBuilder<Groep, Groep, QAfterFilterCondition> omschrijvingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'omschrijving',
      ));
    });
  }

  QueryBuilder<Groep, Groep, QAfterFilterCondition> omschrijvingEqualTo(
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

  QueryBuilder<Groep, Groep, QAfterFilterCondition> omschrijvingGreaterThan(
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

  QueryBuilder<Groep, Groep, QAfterFilterCondition> omschrijvingLessThan(
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

  QueryBuilder<Groep, Groep, QAfterFilterCondition> omschrijvingBetween(
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

  QueryBuilder<Groep, Groep, QAfterFilterCondition> omschrijvingStartsWith(
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

  QueryBuilder<Groep, Groep, QAfterFilterCondition> omschrijvingEndsWith(
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

  QueryBuilder<Groep, Groep, QAfterFilterCondition> omschrijvingContains(
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

  QueryBuilder<Groep, Groep, QAfterFilterCondition> omschrijvingMatches(
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

  QueryBuilder<Groep, Groep, QAfterFilterCondition> omschrijvingIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'omschrijving',
        value: '',
      ));
    });
  }

  QueryBuilder<Groep, Groep, QAfterFilterCondition> omschrijvingIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'omschrijving',
        value: '',
      ));
    });
  }
}

extension GroepQueryObject on QueryBuilder<Groep, Groep, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const LesperiodeSchema = Schema(
  name: r'Lesperiode',
  id: 1830301919153565720,
  properties: {
    r'code': PropertySchema(
      id: 0,
      name: r'code',
      type: IsarType.string,
    )
  },
  estimateSize: _lesperiodeEstimateSize,
  serialize: _lesperiodeSerialize,
  deserialize: _lesperiodeDeserialize,
  deserializeProp: _lesperiodeDeserializeProp,
);

int _lesperiodeEstimateSize(
  Lesperiode object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.code.length * 3;
  return bytesCount;
}

void _lesperiodeSerialize(
  Lesperiode object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.code);
}

Lesperiode _lesperiodeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Lesperiode(
    code: reader.readStringOrNull(offsets[0]) ?? "",
  );
  return object;
}

P _lesperiodeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? "") as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension LesperiodeQueryFilter
    on QueryBuilder<Lesperiode, Lesperiode, QFilterCondition> {
  QueryBuilder<Lesperiode, Lesperiode, QAfterFilterCondition> codeEqualTo(
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

  QueryBuilder<Lesperiode, Lesperiode, QAfterFilterCondition> codeGreaterThan(
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

  QueryBuilder<Lesperiode, Lesperiode, QAfterFilterCondition> codeLessThan(
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

  QueryBuilder<Lesperiode, Lesperiode, QAfterFilterCondition> codeBetween(
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

  QueryBuilder<Lesperiode, Lesperiode, QAfterFilterCondition> codeStartsWith(
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

  QueryBuilder<Lesperiode, Lesperiode, QAfterFilterCondition> codeEndsWith(
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

  QueryBuilder<Lesperiode, Lesperiode, QAfterFilterCondition> codeContains(
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

  QueryBuilder<Lesperiode, Lesperiode, QAfterFilterCondition> codeMatches(
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

  QueryBuilder<Lesperiode, Lesperiode, QAfterFilterCondition> codeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'code',
        value: '',
      ));
    });
  }

  QueryBuilder<Lesperiode, Lesperiode, QAfterFilterCondition> codeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'code',
        value: '',
      ));
    });
  }
}

extension LesperiodeQueryObject
    on QueryBuilder<Lesperiode, Lesperiode, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const OpleidingCodeSchema = Schema(
  name: r'OpleidingCode',
  id: -682619571047085557,
  properties: {
    r'code': PropertySchema(
      id: 0,
      name: r'code',
      type: IsarType.long,
    ),
    r'omschrijving': PropertySchema(
      id: 1,
      name: r'omschrijving',
      type: IsarType.string,
    )
  },
  estimateSize: _opleidingCodeEstimateSize,
  serialize: _opleidingCodeSerialize,
  deserialize: _opleidingCodeDeserialize,
  deserializeProp: _opleidingCodeDeserializeProp,
);

int _opleidingCodeEstimateSize(
  OpleidingCode object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.omschrijving.length * 3;
  return bytesCount;
}

void _opleidingCodeSerialize(
  OpleidingCode object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.code);
  writer.writeString(offsets[1], object.omschrijving);
}

OpleidingCode _opleidingCodeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OpleidingCode(
    code: reader.readLongOrNull(offsets[0]) ?? 0,
    omschrijving: reader.readStringOrNull(offsets[1]) ?? "",
  );
  return object;
}

P _opleidingCodeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? "") as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension OpleidingCodeQueryFilter
    on QueryBuilder<OpleidingCode, OpleidingCode, QFilterCondition> {
  QueryBuilder<OpleidingCode, OpleidingCode, QAfterFilterCondition> codeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'code',
        value: value,
      ));
    });
  }

  QueryBuilder<OpleidingCode, OpleidingCode, QAfterFilterCondition>
      codeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'code',
        value: value,
      ));
    });
  }

  QueryBuilder<OpleidingCode, OpleidingCode, QAfterFilterCondition>
      codeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'code',
        value: value,
      ));
    });
  }

  QueryBuilder<OpleidingCode, OpleidingCode, QAfterFilterCondition> codeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'code',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OpleidingCode, OpleidingCode, QAfterFilterCondition>
      omschrijvingEqualTo(
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

  QueryBuilder<OpleidingCode, OpleidingCode, QAfterFilterCondition>
      omschrijvingGreaterThan(
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

  QueryBuilder<OpleidingCode, OpleidingCode, QAfterFilterCondition>
      omschrijvingLessThan(
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

  QueryBuilder<OpleidingCode, OpleidingCode, QAfterFilterCondition>
      omschrijvingBetween(
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

  QueryBuilder<OpleidingCode, OpleidingCode, QAfterFilterCondition>
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

  QueryBuilder<OpleidingCode, OpleidingCode, QAfterFilterCondition>
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

  QueryBuilder<OpleidingCode, OpleidingCode, QAfterFilterCondition>
      omschrijvingContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'omschrijving',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpleidingCode, OpleidingCode, QAfterFilterCondition>
      omschrijvingMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'omschrijving',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpleidingCode, OpleidingCode, QAfterFilterCondition>
      omschrijvingIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'omschrijving',
        value: '',
      ));
    });
  }

  QueryBuilder<OpleidingCode, OpleidingCode, QAfterFilterCondition>
      omschrijvingIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'omschrijving',
        value: '',
      ));
    });
  }
}

extension OpleidingCodeQueryObject
    on QueryBuilder<OpleidingCode, OpleidingCode, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const PersoonlijkeMentorSchema = Schema(
  name: r'PersoonlijkeMentor',
  id: -1281727570083870467,
  properties: {
    r'achternaam': PropertySchema(
      id: 0,
      name: r'achternaam',
      type: IsarType.string,
    ),
    r'tussenvoegsel': PropertySchema(
      id: 1,
      name: r'tussenvoegsel',
      type: IsarType.string,
    ),
    r'voorletters': PropertySchema(
      id: 2,
      name: r'voorletters',
      type: IsarType.string,
    )
  },
  estimateSize: _persoonlijkeMentorEstimateSize,
  serialize: _persoonlijkeMentorSerialize,
  deserialize: _persoonlijkeMentorDeserialize,
  deserializeProp: _persoonlijkeMentorDeserializeProp,
);

int _persoonlijkeMentorEstimateSize(
  PersoonlijkeMentor object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.achternaam.length * 3;
  {
    final value = object.tussenvoegsel;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.voorletters.length * 3;
  return bytesCount;
}

void _persoonlijkeMentorSerialize(
  PersoonlijkeMentor object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.achternaam);
  writer.writeString(offsets[1], object.tussenvoegsel);
  writer.writeString(offsets[2], object.voorletters);
}

PersoonlijkeMentor _persoonlijkeMentorDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PersoonlijkeMentor(
    achternaam: reader.readStringOrNull(offsets[0]) ?? "",
    tussenvoegsel: reader.readStringOrNull(offsets[1]),
    voorletters: reader.readStringOrNull(offsets[2]) ?? "",
  );
  return object;
}

P _persoonlijkeMentorDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? "") as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension PersoonlijkeMentorQueryFilter
    on QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QFilterCondition> {
  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      achternaamEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'achternaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      achternaamGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'achternaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      achternaamLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'achternaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      achternaamBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'achternaam',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      achternaamStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'achternaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      achternaamEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'achternaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      achternaamContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'achternaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      achternaamMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'achternaam',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      achternaamIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'achternaam',
        value: '',
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      achternaamIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'achternaam',
        value: '',
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      tussenvoegselIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tussenvoegsel',
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      tussenvoegselIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tussenvoegsel',
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      tussenvoegselEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tussenvoegsel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      tussenvoegselGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tussenvoegsel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      tussenvoegselLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tussenvoegsel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      tussenvoegselBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tussenvoegsel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      tussenvoegselStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tussenvoegsel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      tussenvoegselEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tussenvoegsel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      tussenvoegselContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tussenvoegsel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      tussenvoegselMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tussenvoegsel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      tussenvoegselIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tussenvoegsel',
        value: '',
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      tussenvoegselIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tussenvoegsel',
        value: '',
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      voorlettersEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'voorletters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      voorlettersGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'voorletters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      voorlettersLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'voorletters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      voorlettersBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'voorletters',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      voorlettersStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'voorletters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      voorlettersEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'voorletters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      voorlettersContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'voorletters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      voorlettersMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'voorletters',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      voorlettersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'voorletters',
        value: '',
      ));
    });
  }

  QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QAfterFilterCondition>
      voorlettersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'voorletters',
        value: '',
      ));
    });
  }
}

extension PersoonlijkeMentorQueryObject
    on QueryBuilder<PersoonlijkeMentor, PersoonlijkeMentor, QFilterCondition> {}
