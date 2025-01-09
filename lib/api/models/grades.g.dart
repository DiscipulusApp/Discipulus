// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grades.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGradeCollection on Isar {
  IsarCollection<Grade> get grades => this.collection();
}

const GradeSchema = CollectionSchema(
  name: r'Grade',
  id: -5717027466259005798,
  properties: {
    r'cijferKolom': PropertySchema(
      id: 0,
      name: r'cijferKolom',
      type: IsarType.object,
      target: r'CijferKolom',
    ),
    r'cijferKolomIdEloOpdracht': PropertySchema(
      id: 1,
      name: r'cijferKolomIdEloOpdracht',
      type: IsarType.long,
    ),
    r'cijferStr': PropertySchema(
      id: 2,
      name: r'cijferStr',
      type: IsarType.string,
    ),
    r'datumIngevoerd': PropertySchema(
      id: 3,
      name: r'datumIngevoerd',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 4,
      name: r'description',
      type: IsarType.string,
    ),
    r'docent': PropertySchema(
      id: 5,
      name: r'docent',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 6,
      name: r'id',
      type: IsarType.long,
    ),
    r'ingevoerdDoor': PropertySchema(
      id: 7,
      name: r'ingevoerdDoor',
      type: IsarType.string,
    ),
    r'inhalen': PropertySchema(
      id: 8,
      name: r'inhalen',
      type: IsarType.bool,
    ),
    r'isEnabled': PropertySchema(
      id: 9,
      name: r'isEnabled',
      type: IsarType.bool,
    ),
    r'isVoldoende': PropertySchema(
      id: 10,
      name: r'isVoldoende',
      type: IsarType.bool,
    ),
    r'subjectUUID': PropertySchema(
      id: 11,
      name: r'subjectUUID',
      type: IsarType.long,
    ),
    r'teltMee': PropertySchema(
      id: 12,
      name: r'teltMee',
      type: IsarType.bool,
    ),
    r'testDate': PropertySchema(
      id: 13,
      name: r'testDate',
      type: IsarType.dateTime,
    ),
    r'vakOntheffing': PropertySchema(
      id: 14,
      name: r'vakOntheffing',
      type: IsarType.bool,
    ),
    r'vakVrijstelling': PropertySchema(
      id: 15,
      name: r'vakVrijstelling',
      type: IsarType.bool,
    ),
    r'vrijstelling': PropertySchema(
      id: 16,
      name: r'vrijstelling',
      type: IsarType.bool,
    ),
    r'weight': PropertySchema(
      id: 17,
      name: r'weight',
      type: IsarType.double,
    )
  },
  estimateSize: _gradeEstimateSize,
  serialize: _gradeSerialize,
  deserialize: _gradeDeserialize,
  deserializeProp: _gradeDeserializeProp,
  idName: r'uuid',
  indexes: {},
  links: {
    r'schoolyear': LinkSchema(
      id: 5474044483799600523,
      name: r'schoolyear',
      target: r'Schoolyear',
      single: true,
      linkName: r'grades',
    ),
    r'period': LinkSchema(
      id: -568081783380256797,
      name: r'period',
      target: r'GradePeriod',
      single: true,
    ),
    r'subject': LinkSchema(
      id: -7386020070213761028,
      name: r'subject',
      target: r'Subject',
      single: true,
    )
  },
  embeddedSchemas: {r'CijferKolom': CijferKolomSchema},
  getId: _gradeGetId,
  getLinks: _gradeGetLinks,
  attach: _gradeAttach,
  version: '3.1.0+1',
);

int _gradeEstimateSize(
  Grade object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 +
      CijferKolomSchema.estimateSize(
          object.cijferKolom, allOffsets[CijferKolom]!, allOffsets);
  {
    final value = object.cijferStr;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.docent;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.ingevoerdDoor;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _gradeSerialize(
  Grade object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObject<CijferKolom>(
    offsets[0],
    allOffsets,
    CijferKolomSchema.serialize,
    object.cijferKolom,
  );
  writer.writeLong(offsets[1], object.cijferKolomIdEloOpdracht);
  writer.writeString(offsets[2], object.cijferStr);
  writer.writeDateTime(offsets[3], object.datumIngevoerd);
  writer.writeString(offsets[4], object.description);
  writer.writeString(offsets[5], object.docent);
  writer.writeLong(offsets[6], object.id);
  writer.writeString(offsets[7], object.ingevoerdDoor);
  writer.writeBool(offsets[8], object.inhalen);
  writer.writeBool(offsets[9], object.isEnabled);
  writer.writeBool(offsets[10], object.isVoldoende);
  writer.writeLong(offsets[11], object.subjectUUID);
  writer.writeBool(offsets[12], object.teltMee);
  writer.writeDateTime(offsets[13], object.testDate);
  writer.writeBool(offsets[14], object.vakOntheffing);
  writer.writeBool(offsets[15], object.vakVrijstelling);
  writer.writeBool(offsets[16], object.vrijstelling);
  writer.writeDouble(offsets[17], object.weight);
}

Grade _gradeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Grade(
    cijferKolom: reader.readObjectOrNull<CijferKolom>(
          offsets[0],
          CijferKolomSchema.deserialize,
          allOffsets,
        ) ??
        CijferKolom(),
    cijferKolomIdEloOpdracht: reader.readLongOrNull(offsets[1]) ?? -1,
    cijferStr: reader.readStringOrNull(offsets[2]),
    datumIngevoerd: reader.readDateTimeOrNull(offsets[3]),
    docent: reader.readStringOrNull(offsets[5]),
    id: reader.readLong(offsets[6]),
    ingevoerdDoor: reader.readStringOrNull(offsets[7]),
    inhalen: reader.readBoolOrNull(offsets[8]) ?? false,
    isVoldoende: reader.readBoolOrNull(offsets[10]) ?? true,
    teltMee: reader.readBoolOrNull(offsets[12]) ?? true,
    vakOntheffing: reader.readBoolOrNull(offsets[14]) ?? false,
    vakVrijstelling: reader.readBoolOrNull(offsets[15]) ?? false,
    vrijstelling: reader.readBoolOrNull(offsets[16]) ?? false,
    weight: reader.readDoubleOrNull(offsets[17]),
  );
  object.description = reader.readStringOrNull(offsets[4]);
  object.isEnabled = reader.readBool(offsets[9]);
  object.testDate = reader.readDateTimeOrNull(offsets[13]);
  return object;
}

P _gradeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectOrNull<CijferKolom>(
            offset,
            CijferKolomSchema.deserialize,
            allOffsets,
          ) ??
          CijferKolom()) as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? -1) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 11:
      return (reader.readLongOrNull(offset)) as P;
    case 12:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 13:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 14:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 15:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 16:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 17:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _gradeGetId(Grade object) {
  return object.uuid;
}

List<IsarLinkBase<dynamic>> _gradeGetLinks(Grade object) {
  return [object.schoolyear, object.period, object.subject];
}

void _gradeAttach(IsarCollection<dynamic> col, Id id, Grade object) {
  object.schoolyear
      .attach(col, col.isar.collection<Schoolyear>(), r'schoolyear', id);
  object.period.attach(col, col.isar.collection<GradePeriod>(), r'period', id);
  object.subject.attach(col, col.isar.collection<Subject>(), r'subject', id);
}

extension GradeQueryWhereSort on QueryBuilder<Grade, Grade, QWhere> {
  QueryBuilder<Grade, Grade, QAfterWhere> anyUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GradeQueryWhere on QueryBuilder<Grade, Grade, QWhereClause> {
  QueryBuilder<Grade, Grade, QAfterWhereClause> uuidEqualTo(Id uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: uuid,
        upper: uuid,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterWhereClause> uuidNotEqualTo(Id uuid) {
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

  QueryBuilder<Grade, Grade, QAfterWhereClause> uuidGreaterThan(Id uuid,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: uuid, includeLower: include),
      );
    });
  }

  QueryBuilder<Grade, Grade, QAfterWhereClause> uuidLessThan(Id uuid,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: uuid, includeUpper: include),
      );
    });
  }

  QueryBuilder<Grade, Grade, QAfterWhereClause> uuidBetween(
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

extension GradeQueryFilter on QueryBuilder<Grade, Grade, QFilterCondition> {
  QueryBuilder<Grade, Grade, QAfterFilterCondition>
      cijferKolomIdEloOpdrachtEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cijferKolomIdEloOpdracht',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition>
      cijferKolomIdEloOpdrachtGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cijferKolomIdEloOpdracht',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition>
      cijferKolomIdEloOpdrachtLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cijferKolomIdEloOpdracht',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition>
      cijferKolomIdEloOpdrachtBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cijferKolomIdEloOpdracht',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> cijferStrIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cijferStr',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> cijferStrIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cijferStr',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> cijferStrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cijferStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> cijferStrGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cijferStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> cijferStrLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cijferStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> cijferStrBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cijferStr',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> cijferStrStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cijferStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> cijferStrEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cijferStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> cijferStrContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cijferStr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> cijferStrMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cijferStr',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> cijferStrIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cijferStr',
        value: '',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> cijferStrIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cijferStr',
        value: '',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> datumIngevoerdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'datumIngevoerd',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> datumIngevoerdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'datumIngevoerd',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> datumIngevoerdEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'datumIngevoerd',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> datumIngevoerdGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'datumIngevoerd',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> datumIngevoerdLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'datumIngevoerd',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> datumIngevoerdBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'datumIngevoerd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> descriptionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> descriptionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> docentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'docent',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> docentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'docent',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> docentEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'docent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> docentGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'docent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> docentLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'docent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> docentBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'docent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> docentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'docent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> docentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'docent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> docentContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'docent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> docentMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'docent',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> docentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'docent',
        value: '',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> docentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'docent',
        value: '',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Grade, Grade, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Grade, Grade, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Grade, Grade, QAfterFilterCondition> ingevoerdDoorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ingevoerdDoor',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> ingevoerdDoorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ingevoerdDoor',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> ingevoerdDoorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ingevoerdDoor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> ingevoerdDoorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ingevoerdDoor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> ingevoerdDoorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ingevoerdDoor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> ingevoerdDoorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ingevoerdDoor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> ingevoerdDoorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ingevoerdDoor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> ingevoerdDoorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ingevoerdDoor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> ingevoerdDoorContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ingevoerdDoor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> ingevoerdDoorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ingevoerdDoor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> ingevoerdDoorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ingevoerdDoor',
        value: '',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> ingevoerdDoorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ingevoerdDoor',
        value: '',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> inhalenEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'inhalen',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> isEnabledEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> isVoldoendeEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isVoldoende',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> subjectUUIDIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'subjectUUID',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> subjectUUIDIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'subjectUUID',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> subjectUUIDEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subjectUUID',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> subjectUUIDGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subjectUUID',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> subjectUUIDLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subjectUUID',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> subjectUUIDBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subjectUUID',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> teltMeeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'teltMee',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> testDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'testDate',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> testDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'testDate',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> testDateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'testDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> testDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'testDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> testDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'testDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> testDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'testDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> uuidEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> uuidGreaterThan(
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

  QueryBuilder<Grade, Grade, QAfterFilterCondition> uuidLessThan(
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

  QueryBuilder<Grade, Grade, QAfterFilterCondition> uuidBetween(
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

  QueryBuilder<Grade, Grade, QAfterFilterCondition> vakOntheffingEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vakOntheffing',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> vakVrijstellingEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vakVrijstelling',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> vrijstellingEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vrijstelling',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> weightIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'weight',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> weightIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'weight',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> weightEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> weightGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> weightLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> weightBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension GradeQueryObject on QueryBuilder<Grade, Grade, QFilterCondition> {
  QueryBuilder<Grade, Grade, QAfterFilterCondition> cijferKolom(
      FilterQuery<CijferKolom> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'cijferKolom');
    });
  }
}

extension GradeQueryLinks on QueryBuilder<Grade, Grade, QFilterCondition> {
  QueryBuilder<Grade, Grade, QAfterFilterCondition> schoolyear(
      FilterQuery<Schoolyear> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'schoolyear');
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> schoolyearIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'schoolyear', 0, true, 0, true);
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> period(
      FilterQuery<GradePeriod> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'period');
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> periodIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'period', 0, true, 0, true);
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> subject(
      FilterQuery<Subject> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'subject');
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> subjectIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'subject', 0, true, 0, true);
    });
  }
}

extension GradeQuerySortBy on QueryBuilder<Grade, Grade, QSortBy> {
  QueryBuilder<Grade, Grade, QAfterSortBy> sortByCijferKolomIdEloOpdracht() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cijferKolomIdEloOpdracht', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy>
      sortByCijferKolomIdEloOpdrachtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cijferKolomIdEloOpdracht', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByCijferStr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cijferStr', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByCijferStrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cijferStr', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByDatumIngevoerd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'datumIngevoerd', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByDatumIngevoerdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'datumIngevoerd', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByDocent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'docent', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByDocentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'docent', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByIngevoerdDoor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingevoerdDoor', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByIngevoerdDoorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingevoerdDoor', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByInhalen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inhalen', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByInhalenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inhalen', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByIsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByIsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByIsVoldoende() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isVoldoende', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByIsVoldoendeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isVoldoende', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortBySubjectUUID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subjectUUID', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortBySubjectUUIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subjectUUID', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByTeltMee() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teltMee', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByTeltMeeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teltMee', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByTestDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'testDate', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByTestDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'testDate', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByVakOntheffing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vakOntheffing', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByVakOntheffingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vakOntheffing', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByVakVrijstelling() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vakVrijstelling', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByVakVrijstellingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vakVrijstelling', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByVrijstelling() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vrijstelling', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByVrijstellingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vrijstelling', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.desc);
    });
  }
}

extension GradeQuerySortThenBy on QueryBuilder<Grade, Grade, QSortThenBy> {
  QueryBuilder<Grade, Grade, QAfterSortBy> thenByCijferKolomIdEloOpdracht() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cijferKolomIdEloOpdracht', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy>
      thenByCijferKolomIdEloOpdrachtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cijferKolomIdEloOpdracht', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByCijferStr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cijferStr', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByCijferStrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cijferStr', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByDatumIngevoerd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'datumIngevoerd', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByDatumIngevoerdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'datumIngevoerd', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByDocent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'docent', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByDocentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'docent', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByIngevoerdDoor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingevoerdDoor', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByIngevoerdDoorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingevoerdDoor', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByInhalen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inhalen', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByInhalenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inhalen', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByIsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByIsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByIsVoldoende() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isVoldoende', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByIsVoldoendeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isVoldoende', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenBySubjectUUID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subjectUUID', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenBySubjectUUIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subjectUUID', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByTeltMee() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teltMee', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByTeltMeeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teltMee', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByTestDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'testDate', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByTestDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'testDate', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByVakOntheffing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vakOntheffing', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByVakOntheffingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vakOntheffing', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByVakVrijstelling() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vakVrijstelling', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByVakVrijstellingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vakVrijstelling', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByVrijstelling() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vrijstelling', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByVrijstellingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vrijstelling', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.desc);
    });
  }
}

extension GradeQueryWhereDistinct on QueryBuilder<Grade, Grade, QDistinct> {
  QueryBuilder<Grade, Grade, QDistinct> distinctByCijferKolomIdEloOpdracht() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cijferKolomIdEloOpdracht');
    });
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByCijferStr(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cijferStr', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByDatumIngevoerd() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'datumIngevoerd');
    });
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByDocent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'docent', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctById() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id');
    });
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByIngevoerdDoor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ingevoerdDoor',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByInhalen() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'inhalen');
    });
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByIsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isEnabled');
    });
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByIsVoldoende() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isVoldoende');
    });
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctBySubjectUUID() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subjectUUID');
    });
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByTeltMee() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'teltMee');
    });
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByTestDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'testDate');
    });
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByVakOntheffing() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vakOntheffing');
    });
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByVakVrijstelling() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vakVrijstelling');
    });
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByVrijstelling() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vrijstelling');
    });
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weight');
    });
  }
}

extension GradeQueryProperty on QueryBuilder<Grade, Grade, QQueryProperty> {
  QueryBuilder<Grade, int, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }

  QueryBuilder<Grade, CijferKolom, QQueryOperations> cijferKolomProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cijferKolom');
    });
  }

  QueryBuilder<Grade, int, QQueryOperations>
      cijferKolomIdEloOpdrachtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cijferKolomIdEloOpdracht');
    });
  }

  QueryBuilder<Grade, String?, QQueryOperations> cijferStrProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cijferStr');
    });
  }

  QueryBuilder<Grade, DateTime?, QQueryOperations> datumIngevoerdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'datumIngevoerd');
    });
  }

  QueryBuilder<Grade, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<Grade, String?, QQueryOperations> docentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'docent');
    });
  }

  QueryBuilder<Grade, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Grade, String?, QQueryOperations> ingevoerdDoorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ingevoerdDoor');
    });
  }

  QueryBuilder<Grade, bool, QQueryOperations> inhalenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'inhalen');
    });
  }

  QueryBuilder<Grade, bool, QQueryOperations> isEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isEnabled');
    });
  }

  QueryBuilder<Grade, bool, QQueryOperations> isVoldoendeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isVoldoende');
    });
  }

  QueryBuilder<Grade, int?, QQueryOperations> subjectUUIDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subjectUUID');
    });
  }

  QueryBuilder<Grade, bool, QQueryOperations> teltMeeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'teltMee');
    });
  }

  QueryBuilder<Grade, DateTime?, QQueryOperations> testDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'testDate');
    });
  }

  QueryBuilder<Grade, bool, QQueryOperations> vakOntheffingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vakOntheffing');
    });
  }

  QueryBuilder<Grade, bool, QQueryOperations> vakVrijstellingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vakVrijstelling');
    });
  }

  QueryBuilder<Grade, bool, QQueryOperations> vrijstellingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vrijstelling');
    });
  }

  QueryBuilder<Grade, double?, QQueryOperations> weightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weight');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGradePeriodCollection on Isar {
  IsarCollection<GradePeriod> get gradePeriods => this.collection();
}

const GradePeriodSchema = CollectionSchema(
  name: r'GradePeriod',
  id: 5599132949867222290,
  properties: {
    r'end': PropertySchema(
      id: 0,
      name: r'end',
      type: IsarType.dateTime,
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
    ),
    r'start': PropertySchema(
      id: 3,
      name: r'start',
      type: IsarType.dateTime,
    ),
    r'volgNummer': PropertySchema(
      id: 4,
      name: r'volgNummer',
      type: IsarType.long,
    )
  },
  estimateSize: _gradePeriodEstimateSize,
  serialize: _gradePeriodSerialize,
  deserialize: _gradePeriodDeserialize,
  deserializeProp: _gradePeriodDeserializeProp,
  idName: r'uuid',
  indexes: {},
  links: {
    r'grades': LinkSchema(
      id: -880979156053534749,
      name: r'grades',
      target: r'Grade',
      single: false,
      linkName: r'period',
    ),
    r'schoolyear': LinkSchema(
      id: -4824714202794232468,
      name: r'schoolyear',
      target: r'Schoolyear',
      single: true,
      linkName: r'periods',
    ),
    r'subjects': LinkSchema(
      id: 8702726322431959461,
      name: r'subjects',
      target: r'Subject',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _gradePeriodGetId,
  getLinks: _gradePeriodGetLinks,
  attach: _gradePeriodAttach,
  version: '3.1.0+1',
);

int _gradePeriodEstimateSize(
  GradePeriod object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.naam.length * 3;
  return bytesCount;
}

void _gradePeriodSerialize(
  GradePeriod object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.end);
  writer.writeLong(offsets[1], object.id);
  writer.writeString(offsets[2], object.naam);
  writer.writeDateTime(offsets[3], object.start);
  writer.writeLong(offsets[4], object.volgNummer);
}

GradePeriod _gradePeriodDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GradePeriod(
    end: reader.readDateTimeOrNull(offsets[0]),
    id: reader.readLong(offsets[1]),
    naam: reader.readString(offsets[2]),
    start: reader.readDateTimeOrNull(offsets[3]),
    volgNummer: reader.readLong(offsets[4]),
  );
  return object;
}

P _gradePeriodDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _gradePeriodGetId(GradePeriod object) {
  return object.uuid;
}

List<IsarLinkBase<dynamic>> _gradePeriodGetLinks(GradePeriod object) {
  return [object.grades, object.schoolyear, object.subjects];
}

void _gradePeriodAttach(
    IsarCollection<dynamic> col, Id id, GradePeriod object) {
  object.grades.attach(col, col.isar.collection<Grade>(), r'grades', id);
  object.schoolyear
      .attach(col, col.isar.collection<Schoolyear>(), r'schoolyear', id);
  object.subjects.attach(col, col.isar.collection<Subject>(), r'subjects', id);
}

extension GradePeriodQueryWhereSort
    on QueryBuilder<GradePeriod, GradePeriod, QWhere> {
  QueryBuilder<GradePeriod, GradePeriod, QAfterWhere> anyUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GradePeriodQueryWhere
    on QueryBuilder<GradePeriod, GradePeriod, QWhereClause> {
  QueryBuilder<GradePeriod, GradePeriod, QAfterWhereClause> uuidEqualTo(
      Id uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: uuid,
        upper: uuid,
      ));
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterWhereClause> uuidNotEqualTo(
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

  QueryBuilder<GradePeriod, GradePeriod, QAfterWhereClause> uuidGreaterThan(
      Id uuid,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: uuid, includeLower: include),
      );
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterWhereClause> uuidLessThan(
      Id uuid,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: uuid, includeUpper: include),
      );
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterWhereClause> uuidBetween(
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

extension GradePeriodQueryFilter
    on QueryBuilder<GradePeriod, GradePeriod, QFilterCondition> {
  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> endIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'end',
      ));
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> endIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'end',
      ));
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> endEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'end',
        value: value,
      ));
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> endGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'end',
        value: value,
      ));
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> endLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'end',
        value: value,
      ));
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> endBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'end',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> idEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> idBetween(
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

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> naamEqualTo(
    String value, {
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

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> naamGreaterThan(
    String value, {
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

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> naamLessThan(
    String value, {
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

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> naamBetween(
    String lower,
    String upper, {
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

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> naamStartsWith(
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

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> naamEndsWith(
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

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> naamContains(
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

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> naamMatches(
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

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> naamIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'naam',
        value: '',
      ));
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition>
      naamIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'naam',
        value: '',
      ));
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> startIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'start',
      ));
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition>
      startIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'start',
      ));
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> startEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'start',
        value: value,
      ));
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition>
      startGreaterThan(
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

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> startLessThan(
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

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> startBetween(
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

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> uuidEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
      ));
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> uuidGreaterThan(
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

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> uuidLessThan(
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

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> uuidBetween(
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

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition>
      volgNummerEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'volgNummer',
        value: value,
      ));
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition>
      volgNummerGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'volgNummer',
        value: value,
      ));
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition>
      volgNummerLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'volgNummer',
        value: value,
      ));
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition>
      volgNummerBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'volgNummer',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension GradePeriodQueryObject
    on QueryBuilder<GradePeriod, GradePeriod, QFilterCondition> {}

extension GradePeriodQueryLinks
    on QueryBuilder<GradePeriod, GradePeriod, QFilterCondition> {
  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> grades(
      FilterQuery<Grade> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'grades');
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition>
      gradesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'grades', length, true, length, true);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition>
      gradesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'grades', 0, true, 0, true);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition>
      gradesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'grades', 0, false, 999999, true);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition>
      gradesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'grades', 0, true, length, include);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition>
      gradesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'grades', length, include, 999999, true);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition>
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

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> schoolyear(
      FilterQuery<Schoolyear> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'schoolyear');
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition>
      schoolyearIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'schoolyear', 0, true, 0, true);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition> subjects(
      FilterQuery<Subject> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'subjects');
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition>
      subjectsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'subjects', length, true, length, true);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition>
      subjectsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'subjects', 0, true, 0, true);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition>
      subjectsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'subjects', 0, false, 999999, true);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition>
      subjectsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'subjects', 0, true, length, include);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition>
      subjectsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'subjects', length, include, 999999, true);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterFilterCondition>
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

extension GradePeriodQuerySortBy
    on QueryBuilder<GradePeriod, GradePeriod, QSortBy> {
  QueryBuilder<GradePeriod, GradePeriod, QAfterSortBy> sortByEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'end', Sort.asc);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterSortBy> sortByEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'end', Sort.desc);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterSortBy> sortByNaam() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'naam', Sort.asc);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterSortBy> sortByNaamDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'naam', Sort.desc);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterSortBy> sortByStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'start', Sort.asc);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterSortBy> sortByStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'start', Sort.desc);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterSortBy> sortByVolgNummer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volgNummer', Sort.asc);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterSortBy> sortByVolgNummerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volgNummer', Sort.desc);
    });
  }
}

extension GradePeriodQuerySortThenBy
    on QueryBuilder<GradePeriod, GradePeriod, QSortThenBy> {
  QueryBuilder<GradePeriod, GradePeriod, QAfterSortBy> thenByEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'end', Sort.asc);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterSortBy> thenByEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'end', Sort.desc);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterSortBy> thenByNaam() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'naam', Sort.asc);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterSortBy> thenByNaamDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'naam', Sort.desc);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterSortBy> thenByStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'start', Sort.asc);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterSortBy> thenByStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'start', Sort.desc);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterSortBy> thenByVolgNummer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volgNummer', Sort.asc);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QAfterSortBy> thenByVolgNummerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volgNummer', Sort.desc);
    });
  }
}

extension GradePeriodQueryWhereDistinct
    on QueryBuilder<GradePeriod, GradePeriod, QDistinct> {
  QueryBuilder<GradePeriod, GradePeriod, QDistinct> distinctByEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'end');
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QDistinct> distinctById() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id');
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QDistinct> distinctByNaam(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'naam', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QDistinct> distinctByStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'start');
    });
  }

  QueryBuilder<GradePeriod, GradePeriod, QDistinct> distinctByVolgNummer() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'volgNummer');
    });
  }
}

extension GradePeriodQueryProperty
    on QueryBuilder<GradePeriod, GradePeriod, QQueryProperty> {
  QueryBuilder<GradePeriod, int, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }

  QueryBuilder<GradePeriod, DateTime?, QQueryOperations> endProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'end');
    });
  }

  QueryBuilder<GradePeriod, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GradePeriod, String, QQueryOperations> naamProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'naam');
    });
  }

  QueryBuilder<GradePeriod, DateTime?, QQueryOperations> startProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'start');
    });
  }

  QueryBuilder<GradePeriod, int, QQueryOperations> volgNummerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'volgNummer');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const CijferKolomSchema = Schema(
  name: r'CijferKolom',
  id: -3258701313704097823,
  properties: {
    r'heeftOnderliggendeKolommen': PropertySchema(
      id: 0,
      name: r'heeftOnderliggendeKolommen',
      type: IsarType.bool,
    ),
    r'id': PropertySchema(
      id: 1,
      name: r'id',
      type: IsarType.long,
    ),
    r'isDocentKolom': PropertySchema(
      id: 2,
      name: r'isDocentKolom',
      type: IsarType.bool,
    ),
    r'isHerkansingKolom': PropertySchema(
      id: 3,
      name: r'isHerkansingKolom',
      type: IsarType.bool,
    ),
    r'isPtaKolom': PropertySchema(
      id: 4,
      name: r'isPtaKolom',
      type: IsarType.bool,
    ),
    r'kolomKop': PropertySchema(
      id: 5,
      name: r'kolomKop',
      type: IsarType.string,
    ),
    r'kolomNaam': PropertySchema(
      id: 6,
      name: r'kolomNaam',
      type: IsarType.string,
    ),
    r'kolomNummer': PropertySchema(
      id: 7,
      name: r'kolomNummer',
      type: IsarType.string,
    ),
    r'kolomOmschrijving': PropertySchema(
      id: 8,
      name: r'kolomOmschrijving',
      type: IsarType.string,
    ),
    r'kolomSoort': PropertySchema(
      id: 9,
      name: r'kolomSoort',
      type: IsarType.long,
    ),
    r'kolomVolgNummer': PropertySchema(
      id: 10,
      name: r'kolomVolgNummer',
      type: IsarType.string,
    )
  },
  estimateSize: _cijferKolomEstimateSize,
  serialize: _cijferKolomSerialize,
  deserialize: _cijferKolomDeserialize,
  deserializeProp: _cijferKolomDeserializeProp,
);

int _cijferKolomEstimateSize(
  CijferKolom object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.kolomKop;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.kolomNaam;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.kolomNummer;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.kolomOmschrijving;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.kolomVolgNummer.length * 3;
  return bytesCount;
}

void _cijferKolomSerialize(
  CijferKolom object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.heeftOnderliggendeKolommen);
  writer.writeLong(offsets[1], object.id);
  writer.writeBool(offsets[2], object.isDocentKolom);
  writer.writeBool(offsets[3], object.isHerkansingKolom);
  writer.writeBool(offsets[4], object.isPtaKolom);
  writer.writeString(offsets[5], object.kolomKop);
  writer.writeString(offsets[6], object.kolomNaam);
  writer.writeString(offsets[7], object.kolomNummer);
  writer.writeString(offsets[8], object.kolomOmschrijving);
  writer.writeLong(offsets[9], object.kolomSoort);
  writer.writeString(offsets[10], object.kolomVolgNummer);
}

CijferKolom _cijferKolomDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CijferKolom(
    heeftOnderliggendeKolommen: reader.readBoolOrNull(offsets[0]) ?? false,
    id: reader.readLongOrNull(offsets[1]) ?? 0,
    isDocentKolom: reader.readBoolOrNull(offsets[2]) ?? false,
    isHerkansingKolom: reader.readBoolOrNull(offsets[3]) ?? false,
    isPtaKolom: reader.readBoolOrNull(offsets[4]) ?? false,
    kolomKop: reader.readStringOrNull(offsets[5]),
    kolomNaam: reader.readStringOrNull(offsets[6]),
    kolomNummer: reader.readStringOrNull(offsets[7]),
    kolomOmschrijving: reader.readStringOrNull(offsets[8]),
    kolomSoort: reader.readLongOrNull(offsets[9]) ?? 0,
    kolomVolgNummer: reader.readStringOrNull(offsets[10]) ?? "",
  );
  return object;
}

P _cijferKolomDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 2:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 3:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 4:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 10:
      return (reader.readStringOrNull(offset) ?? "") as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension CijferKolomQueryFilter
    on QueryBuilder<CijferKolom, CijferKolom, QFilterCondition> {
  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      heeftOnderliggendeKolommenEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'heeftOnderliggendeKolommen',
        value: value,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition> idEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      isDocentKolomEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDocentKolom',
        value: value,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      isHerkansingKolomEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isHerkansingKolom',
        value: value,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      isPtaKolomEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPtaKolom',
        value: value,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomKopIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'kolomKop',
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomKopIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'kolomKop',
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition> kolomKopEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kolomKop',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomKopGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'kolomKop',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomKopLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'kolomKop',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition> kolomKopBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'kolomKop',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomKopStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'kolomKop',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomKopEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'kolomKop',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomKopContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'kolomKop',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition> kolomKopMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'kolomKop',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomKopIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kolomKop',
        value: '',
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomKopIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'kolomKop',
        value: '',
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomNaamIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'kolomNaam',
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomNaamIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'kolomNaam',
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomNaamEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kolomNaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomNaamGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'kolomNaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomNaamLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'kolomNaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomNaamBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'kolomNaam',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomNaamStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'kolomNaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomNaamEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'kolomNaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomNaamContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'kolomNaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomNaamMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'kolomNaam',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomNaamIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kolomNaam',
        value: '',
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomNaamIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'kolomNaam',
        value: '',
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomNummerIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'kolomNummer',
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomNummerIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'kolomNummer',
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomNummerEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kolomNummer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomNummerGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'kolomNummer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomNummerLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'kolomNummer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomNummerBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'kolomNummer',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomNummerStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'kolomNummer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomNummerEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'kolomNummer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomNummerContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'kolomNummer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomNummerMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'kolomNummer',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomNummerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kolomNummer',
        value: '',
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomNummerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'kolomNummer',
        value: '',
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomOmschrijvingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'kolomOmschrijving',
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomOmschrijvingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'kolomOmschrijving',
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomOmschrijvingEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kolomOmschrijving',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomOmschrijvingGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'kolomOmschrijving',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomOmschrijvingLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'kolomOmschrijving',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomOmschrijvingBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'kolomOmschrijving',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomOmschrijvingStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'kolomOmschrijving',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomOmschrijvingEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'kolomOmschrijving',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomOmschrijvingContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'kolomOmschrijving',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomOmschrijvingMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'kolomOmschrijving',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomOmschrijvingIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kolomOmschrijving',
        value: '',
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomOmschrijvingIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'kolomOmschrijving',
        value: '',
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomSoortEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kolomSoort',
        value: value,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomSoortGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'kolomSoort',
        value: value,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomSoortLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'kolomSoort',
        value: value,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomSoortBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'kolomSoort',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomVolgNummerEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kolomVolgNummer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomVolgNummerGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'kolomVolgNummer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomVolgNummerLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'kolomVolgNummer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomVolgNummerBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'kolomVolgNummer',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomVolgNummerStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'kolomVolgNummer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomVolgNummerEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'kolomVolgNummer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomVolgNummerContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'kolomVolgNummer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomVolgNummerMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'kolomVolgNummer',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomVolgNummerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kolomVolgNummer',
        value: '',
      ));
    });
  }

  QueryBuilder<CijferKolom, CijferKolom, QAfterFilterCondition>
      kolomVolgNummerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'kolomVolgNummer',
        value: '',
      ));
    });
  }
}

extension CijferKolomQueryObject
    on QueryBuilder<CijferKolom, CijferKolom, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const VakSchema = Schema(
  name: r'Vak',
  id: 8004703842565028090,
  properties: {
    r'afkorting': PropertySchema(
      id: 0,
      name: r'afkorting',
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
    ),
    r'volgnr': PropertySchema(
      id: 3,
      name: r'volgnr',
      type: IsarType.long,
    )
  },
  estimateSize: _vakEstimateSize,
  serialize: _vakSerialize,
  deserialize: _vakDeserialize,
  deserializeProp: _vakDeserializeProp,
);

int _vakEstimateSize(
  Vak object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.afkorting.length * 3;
  bytesCount += 3 + object.omschrijving.length * 3;
  return bytesCount;
}

void _vakSerialize(
  Vak object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.afkorting);
  writer.writeLong(offsets[1], object.id);
  writer.writeString(offsets[2], object.omschrijving);
  writer.writeLong(offsets[3], object.volgnr);
}

Vak _vakDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Vak(
    afkorting: reader.readStringOrNull(offsets[0]) ?? "",
    id: reader.readLongOrNull(offsets[1]) ?? 0,
    omschrijving: reader.readStringOrNull(offsets[2]) ?? "",
    volgnr: reader.readLongOrNull(offsets[3]) ?? 0,
  );
  return object;
}

P _vakDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 3:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension VakQueryFilter on QueryBuilder<Vak, Vak, QFilterCondition> {
  QueryBuilder<Vak, Vak, QAfterFilterCondition> afkortingEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'afkorting',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Vak, Vak, QAfterFilterCondition> afkortingGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'afkorting',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Vak, Vak, QAfterFilterCondition> afkortingLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'afkorting',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Vak, Vak, QAfterFilterCondition> afkortingBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'afkorting',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Vak, Vak, QAfterFilterCondition> afkortingStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'afkorting',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Vak, Vak, QAfterFilterCondition> afkortingEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'afkorting',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Vak, Vak, QAfterFilterCondition> afkortingContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'afkorting',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Vak, Vak, QAfterFilterCondition> afkortingMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'afkorting',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Vak, Vak, QAfterFilterCondition> afkortingIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'afkorting',
        value: '',
      ));
    });
  }

  QueryBuilder<Vak, Vak, QAfterFilterCondition> afkortingIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'afkorting',
        value: '',
      ));
    });
  }

  QueryBuilder<Vak, Vak, QAfterFilterCondition> idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Vak, Vak, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Vak, Vak, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Vak, Vak, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Vak, Vak, QAfterFilterCondition> omschrijvingEqualTo(
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

  QueryBuilder<Vak, Vak, QAfterFilterCondition> omschrijvingGreaterThan(
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

  QueryBuilder<Vak, Vak, QAfterFilterCondition> omschrijvingLessThan(
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

  QueryBuilder<Vak, Vak, QAfterFilterCondition> omschrijvingBetween(
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

  QueryBuilder<Vak, Vak, QAfterFilterCondition> omschrijvingStartsWith(
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

  QueryBuilder<Vak, Vak, QAfterFilterCondition> omschrijvingEndsWith(
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

  QueryBuilder<Vak, Vak, QAfterFilterCondition> omschrijvingContains(
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

  QueryBuilder<Vak, Vak, QAfterFilterCondition> omschrijvingMatches(
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

  QueryBuilder<Vak, Vak, QAfterFilterCondition> omschrijvingIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'omschrijving',
        value: '',
      ));
    });
  }

  QueryBuilder<Vak, Vak, QAfterFilterCondition> omschrijvingIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'omschrijving',
        value: '',
      ));
    });
  }

  QueryBuilder<Vak, Vak, QAfterFilterCondition> volgnrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'volgnr',
        value: value,
      ));
    });
  }

  QueryBuilder<Vak, Vak, QAfterFilterCondition> volgnrGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'volgnr',
        value: value,
      ));
    });
  }

  QueryBuilder<Vak, Vak, QAfterFilterCondition> volgnrLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'volgnr',
        value: value,
      ));
    });
  }

  QueryBuilder<Vak, Vak, QAfterFilterCondition> volgnrBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'volgnr',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension VakQueryObject on QueryBuilder<Vak, Vak, QFilterCondition> {}
