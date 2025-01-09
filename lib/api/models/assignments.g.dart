// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignments.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAssignmentCollection on Isar {
  IsarCollection<Assignment> get assignments => this.collection();
}

const AssignmentSchema = CollectionSchema(
  name: r'Assignment',
  id: 6342734841231534375,
  properties: {
    r'afgesloten': PropertySchema(
      id: 0,
      name: r'afgesloten',
      type: IsarType.bool,
    ),
    r'beoordeeldOp': PropertySchema(
      id: 1,
      name: r'beoordeeldOp',
      type: IsarType.dateTime,
    ),
    r'beoordeling': PropertySchema(
      id: 2,
      name: r'beoordeling',
      type: IsarType.string,
    ),
    r'docenten': PropertySchema(
      id: 3,
      name: r'docenten',
      type: IsarType.objectList,
      target: r'Docenten',
    ),
    r'id': PropertySchema(
      id: 4,
      name: r'id',
      type: IsarType.long,
    ),
    r'ingeleverdOp': PropertySchema(
      id: 5,
      name: r'ingeleverdOp',
      type: IsarType.dateTime,
    ),
    r'inleverenVoor': PropertySchema(
      id: 6,
      name: r'inleverenVoor',
      type: IsarType.dateTime,
    ),
    r'laatsteOpdrachtVersienummer': PropertySchema(
      id: 7,
      name: r'laatsteOpdrachtVersienummer',
      type: IsarType.long,
    ),
    r'links': PropertySchema(
      id: 8,
      name: r'links',
      type: IsarType.objectList,
      target: r'BronLink',
    ),
    r'magInleveren': PropertySchema(
      id: 9,
      name: r'magInleveren',
      type: IsarType.bool,
    ),
    r'omschrijving': PropertySchema(
      id: 10,
      name: r'omschrijving',
      type: IsarType.string,
    ),
    r'opnieuwInleveren': PropertySchema(
      id: 11,
      name: r'opnieuwInleveren',
      type: IsarType.bool,
    ),
    r'statusLaatsteOpdrachtVersie': PropertySchema(
      id: 12,
      name: r'statusLaatsteOpdrachtVersie',
      type: IsarType.byte,
      enumMap: _AssignmentstatusLaatsteOpdrachtVersieEnumValueMap,
    ),
    r'titel': PropertySchema(
      id: 13,
      name: r'titel',
      type: IsarType.string,
    ),
    r'vak': PropertySchema(
      id: 14,
      name: r'vak',
      type: IsarType.string,
    )
  },
  estimateSize: _assignmentEstimateSize,
  serialize: _assignmentSerialize,
  deserialize: _assignmentDeserialize,
  deserializeProp: _assignmentDeserializeProp,
  idName: r'uuid',
  indexes: {},
  links: {
    r'profile': LinkSchema(
      id: 4294703118509627747,
      name: r'profile',
      target: r'Profile',
      single: true,
      linkName: r'assignments',
    ),
    r'bronnen': LinkSchema(
      id: 8777713571149421433,
      name: r'bronnen',
      target: r'Bron',
      single: false,
    ),
    r'versies': LinkSchema(
      id: -9111620149969290953,
      name: r'versies',
      target: r'AssignmentVersion',
      single: false,
    )
  },
  embeddedSchemas: {r'BronLink': BronLinkSchema, r'Docenten': DocentenSchema},
  getId: _assignmentGetId,
  getLinks: _assignmentGetLinks,
  attach: _assignmentAttach,
  version: '3.1.0+1',
);

int _assignmentEstimateSize(
  Assignment object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.beoordeling.length * 3;
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
  bytesCount += 3 + object.links.length * 3;
  {
    final offsets = allOffsets[BronLink]!;
    for (var i = 0; i < object.links.length; i++) {
      final value = object.links[i];
      bytesCount += BronLinkSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.omschrijving.length * 3;
  bytesCount += 3 + object.titel.length * 3;
  bytesCount += 3 + object.vak.length * 3;
  return bytesCount;
}

void _assignmentSerialize(
  Assignment object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.afgesloten);
  writer.writeDateTime(offsets[1], object.beoordeeldOp);
  writer.writeString(offsets[2], object.beoordeling);
  writer.writeObjectList<Docenten>(
    offsets[3],
    allOffsets,
    DocentenSchema.serialize,
    object.docenten,
  );
  writer.writeLong(offsets[4], object.id);
  writer.writeDateTime(offsets[5], object.ingeleverdOp);
  writer.writeDateTime(offsets[6], object.inleverenVoor);
  writer.writeLong(offsets[7], object.laatsteOpdrachtVersienummer);
  writer.writeObjectList<BronLink>(
    offsets[8],
    allOffsets,
    BronLinkSchema.serialize,
    object.links,
  );
  writer.writeBool(offsets[9], object.magInleveren);
  writer.writeString(offsets[10], object.omschrijving);
  writer.writeBool(offsets[11], object.opnieuwInleveren);
  writer.writeByte(offsets[12], object.statusLaatsteOpdrachtVersie.index);
  writer.writeString(offsets[13], object.titel);
  writer.writeString(offsets[14], object.vak);
}

Assignment _assignmentDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Assignment(
    afgesloten: reader.readBool(offsets[0]),
    beoordeeldOp: reader.readDateTimeOrNull(offsets[1]),
    beoordeling: reader.readString(offsets[2]),
    docenten: reader.readObjectList<Docenten>(
      offsets[3],
      DocentenSchema.deserialize,
      allOffsets,
      Docenten(),
    ),
    id: reader.readLong(offsets[4]),
    ingeleverdOp: reader.readDateTimeOrNull(offsets[5]),
    inleverenVoor: reader.readDateTime(offsets[6]),
    laatsteOpdrachtVersienummer: reader.readLong(offsets[7]),
    links: reader.readObjectList<BronLink>(
          offsets[8],
          BronLinkSchema.deserialize,
          allOffsets,
          BronLink(),
        ) ??
        [],
    magInleveren: reader.readBool(offsets[9]),
    omschrijving: reader.readString(offsets[10]),
    opnieuwInleveren: reader.readBool(offsets[11]),
    statusLaatsteOpdrachtVersie:
        _AssignmentstatusLaatsteOpdrachtVersieValueEnumMap[
                reader.readByteOrNull(offsets[12])] ??
            VersieStatus.alle,
    titel: reader.readString(offsets[13]),
    vak: reader.readString(offsets[14]),
  );
  return object;
}

P _assignmentDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readObjectList<Docenten>(
        offset,
        DocentenSchema.deserialize,
        allOffsets,
        Docenten(),
      )) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readObjectList<BronLink>(
            offset,
            BronLinkSchema.deserialize,
            allOffsets,
            BronLink(),
          ) ??
          []) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (_AssignmentstatusLaatsteOpdrachtVersieValueEnumMap[
              reader.readByteOrNull(offset)] ??
          VersieStatus.alle) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _AssignmentstatusLaatsteOpdrachtVersieEnumValueMap = {
  'alle': 0,
  'ingeleverd': 1,
  'openstaand': 2,
  'beoordeeld': 3,
  'geen': 4,
  'afgesloten': 5,
};
const _AssignmentstatusLaatsteOpdrachtVersieValueEnumMap = {
  0: VersieStatus.alle,
  1: VersieStatus.ingeleverd,
  2: VersieStatus.openstaand,
  3: VersieStatus.beoordeeld,
  4: VersieStatus.geen,
  5: VersieStatus.afgesloten,
};

Id _assignmentGetId(Assignment object) {
  return object.uuid;
}

List<IsarLinkBase<dynamic>> _assignmentGetLinks(Assignment object) {
  return [object.profile, object.bronnen, object.versies];
}

void _assignmentAttach(IsarCollection<dynamic> col, Id id, Assignment object) {
  object.profile.attach(col, col.isar.collection<Profile>(), r'profile', id);
  object.bronnen.attach(col, col.isar.collection<Bron>(), r'bronnen', id);
  object.versies
      .attach(col, col.isar.collection<AssignmentVersion>(), r'versies', id);
}

extension AssignmentQueryWhereSort
    on QueryBuilder<Assignment, Assignment, QWhere> {
  QueryBuilder<Assignment, Assignment, QAfterWhere> anyUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AssignmentQueryWhere
    on QueryBuilder<Assignment, Assignment, QWhereClause> {
  QueryBuilder<Assignment, Assignment, QAfterWhereClause> uuidEqualTo(Id uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: uuid,
        upper: uuid,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterWhereClause> uuidNotEqualTo(
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

  QueryBuilder<Assignment, Assignment, QAfterWhereClause> uuidGreaterThan(
      Id uuid,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: uuid, includeLower: include),
      );
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterWhereClause> uuidLessThan(Id uuid,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: uuid, includeUpper: include),
      );
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterWhereClause> uuidBetween(
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

extension AssignmentQueryFilter
    on QueryBuilder<Assignment, Assignment, QFilterCondition> {
  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> afgeslotenEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'afgesloten',
        value: value,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      beoordeeldOpIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'beoordeeldOp',
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      beoordeeldOpIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'beoordeeldOp',
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      beoordeeldOpEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'beoordeeldOp',
        value: value,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      beoordeeldOpGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'beoordeeldOp',
        value: value,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      beoordeeldOpLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'beoordeeldOp',
        value: value,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      beoordeeldOpBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'beoordeeldOp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      beoordelingEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'beoordeling',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      beoordelingGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'beoordeling',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      beoordelingLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'beoordeling',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      beoordelingBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'beoordeling',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      beoordelingStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'beoordeling',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      beoordelingEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'beoordeling',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      beoordelingContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'beoordeling',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      beoordelingMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'beoordeling',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      beoordelingIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'beoordeling',
        value: '',
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      beoordelingIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'beoordeling',
        value: '',
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> docentenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'docenten',
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      docentenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'docenten',
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
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

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
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

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
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

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
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

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
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

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
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

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> idEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      ingeleverdOpIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ingeleverdOp',
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      ingeleverdOpIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ingeleverdOp',
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      ingeleverdOpEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ingeleverdOp',
        value: value,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      ingeleverdOpGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ingeleverdOp',
        value: value,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      ingeleverdOpLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ingeleverdOp',
        value: value,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      ingeleverdOpBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ingeleverdOp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      inleverenVoorEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'inleverenVoor',
        value: value,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      inleverenVoorGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'inleverenVoor',
        value: value,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      inleverenVoorLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'inleverenVoor',
        value: value,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      inleverenVoorBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'inleverenVoor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      laatsteOpdrachtVersienummerEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'laatsteOpdrachtVersienummer',
        value: value,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      laatsteOpdrachtVersienummerGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'laatsteOpdrachtVersienummer',
        value: value,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      laatsteOpdrachtVersienummerLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'laatsteOpdrachtVersienummer',
        value: value,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      laatsteOpdrachtVersienummerBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'laatsteOpdrachtVersienummer',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      linksLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'links',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> linksIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'links',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      linksIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'links',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      linksLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'links',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      linksLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'links',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      linksLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'links',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      magInleverenEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'magInleveren',
        value: value,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
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

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
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

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
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

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
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

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
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

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
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

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      omschrijvingContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'omschrijving',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      omschrijvingMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'omschrijving',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      omschrijvingIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'omschrijving',
        value: '',
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      omschrijvingIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'omschrijving',
        value: '',
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      opnieuwInleverenEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'opnieuwInleveren',
        value: value,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      statusLaatsteOpdrachtVersieEqualTo(VersieStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statusLaatsteOpdrachtVersie',
        value: value,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      statusLaatsteOpdrachtVersieGreaterThan(
    VersieStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'statusLaatsteOpdrachtVersie',
        value: value,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      statusLaatsteOpdrachtVersieLessThan(
    VersieStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'statusLaatsteOpdrachtVersie',
        value: value,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      statusLaatsteOpdrachtVersieBetween(
    VersieStatus lower,
    VersieStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'statusLaatsteOpdrachtVersie',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> titelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> titelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'titel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> titelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'titel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> titelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'titel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> titelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'titel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> titelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'titel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> titelContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'titel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> titelMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'titel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> titelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titel',
        value: '',
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      titelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'titel',
        value: '',
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> uuidEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> uuidGreaterThan(
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

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> uuidLessThan(
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

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> uuidBetween(
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

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> vakEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vak',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> vakGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vak',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> vakLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vak',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> vakBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> vakStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vak',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> vakEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vak',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> vakContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vak',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> vakMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vak',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> vakIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vak',
        value: '',
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> vakIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vak',
        value: '',
      ));
    });
  }
}

extension AssignmentQueryObject
    on QueryBuilder<Assignment, Assignment, QFilterCondition> {
  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> docentenElement(
      FilterQuery<Docenten> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'docenten');
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> linksElement(
      FilterQuery<BronLink> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'links');
    });
  }
}

extension AssignmentQueryLinks
    on QueryBuilder<Assignment, Assignment, QFilterCondition> {
  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> profile(
      FilterQuery<Profile> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'profile');
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> profileIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'profile', 0, true, 0, true);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> bronnen(
      FilterQuery<Bron> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'bronnen');
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      bronnenLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', length, true, length, true);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> bronnenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', 0, true, 0, true);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      bronnenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', 0, false, 999999, true);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      bronnenLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', 0, true, length, include);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      bronnenLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', length, include, 999999, true);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
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

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> versies(
      FilterQuery<AssignmentVersion> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'versies');
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      versiesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'versies', length, true, length, true);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> versiesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'versies', 0, true, 0, true);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      versiesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'versies', 0, false, 999999, true);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      versiesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'versies', 0, true, length, include);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      versiesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'versies', length, include, 999999, true);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      versiesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'versies', lower, includeLower, upper, includeUpper);
    });
  }
}

extension AssignmentQuerySortBy
    on QueryBuilder<Assignment, Assignment, QSortBy> {
  QueryBuilder<Assignment, Assignment, QAfterSortBy> sortByAfgesloten() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'afgesloten', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> sortByAfgeslotenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'afgesloten', Sort.desc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> sortByBeoordeeldOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beoordeeldOp', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> sortByBeoordeeldOpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beoordeeldOp', Sort.desc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> sortByBeoordeling() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beoordeling', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> sortByBeoordelingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beoordeling', Sort.desc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> sortByIngeleverdOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingeleverdOp', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> sortByIngeleverdOpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingeleverdOp', Sort.desc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> sortByInleverenVoor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inleverenVoor', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> sortByInleverenVoorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inleverenVoor', Sort.desc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy>
      sortByLaatsteOpdrachtVersienummer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'laatsteOpdrachtVersienummer', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy>
      sortByLaatsteOpdrachtVersienummerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'laatsteOpdrachtVersienummer', Sort.desc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> sortByMagInleveren() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'magInleveren', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> sortByMagInleverenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'magInleveren', Sort.desc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> sortByOmschrijving() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'omschrijving', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> sortByOmschrijvingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'omschrijving', Sort.desc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> sortByOpnieuwInleveren() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'opnieuwInleveren', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy>
      sortByOpnieuwInleverenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'opnieuwInleveren', Sort.desc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy>
      sortByStatusLaatsteOpdrachtVersie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusLaatsteOpdrachtVersie', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy>
      sortByStatusLaatsteOpdrachtVersieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusLaatsteOpdrachtVersie', Sort.desc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> sortByTitel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titel', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> sortByTitelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titel', Sort.desc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> sortByVak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vak', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> sortByVakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vak', Sort.desc);
    });
  }
}

extension AssignmentQuerySortThenBy
    on QueryBuilder<Assignment, Assignment, QSortThenBy> {
  QueryBuilder<Assignment, Assignment, QAfterSortBy> thenByAfgesloten() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'afgesloten', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> thenByAfgeslotenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'afgesloten', Sort.desc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> thenByBeoordeeldOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beoordeeldOp', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> thenByBeoordeeldOpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beoordeeldOp', Sort.desc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> thenByBeoordeling() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beoordeling', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> thenByBeoordelingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beoordeling', Sort.desc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> thenByIngeleverdOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingeleverdOp', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> thenByIngeleverdOpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingeleverdOp', Sort.desc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> thenByInleverenVoor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inleverenVoor', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> thenByInleverenVoorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inleverenVoor', Sort.desc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy>
      thenByLaatsteOpdrachtVersienummer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'laatsteOpdrachtVersienummer', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy>
      thenByLaatsteOpdrachtVersienummerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'laatsteOpdrachtVersienummer', Sort.desc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> thenByMagInleveren() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'magInleveren', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> thenByMagInleverenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'magInleveren', Sort.desc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> thenByOmschrijving() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'omschrijving', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> thenByOmschrijvingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'omschrijving', Sort.desc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> thenByOpnieuwInleveren() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'opnieuwInleveren', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy>
      thenByOpnieuwInleverenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'opnieuwInleveren', Sort.desc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy>
      thenByStatusLaatsteOpdrachtVersie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusLaatsteOpdrachtVersie', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy>
      thenByStatusLaatsteOpdrachtVersieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusLaatsteOpdrachtVersie', Sort.desc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> thenByTitel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titel', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> thenByTitelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titel', Sort.desc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> thenByVak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vak', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> thenByVakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vak', Sort.desc);
    });
  }
}

extension AssignmentQueryWhereDistinct
    on QueryBuilder<Assignment, Assignment, QDistinct> {
  QueryBuilder<Assignment, Assignment, QDistinct> distinctByAfgesloten() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'afgesloten');
    });
  }

  QueryBuilder<Assignment, Assignment, QDistinct> distinctByBeoordeeldOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'beoordeeldOp');
    });
  }

  QueryBuilder<Assignment, Assignment, QDistinct> distinctByBeoordeling(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'beoordeling', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Assignment, Assignment, QDistinct> distinctById() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id');
    });
  }

  QueryBuilder<Assignment, Assignment, QDistinct> distinctByIngeleverdOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ingeleverdOp');
    });
  }

  QueryBuilder<Assignment, Assignment, QDistinct> distinctByInleverenVoor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'inleverenVoor');
    });
  }

  QueryBuilder<Assignment, Assignment, QDistinct>
      distinctByLaatsteOpdrachtVersienummer() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'laatsteOpdrachtVersienummer');
    });
  }

  QueryBuilder<Assignment, Assignment, QDistinct> distinctByMagInleveren() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'magInleveren');
    });
  }

  QueryBuilder<Assignment, Assignment, QDistinct> distinctByOmschrijving(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'omschrijving', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Assignment, Assignment, QDistinct> distinctByOpnieuwInleveren() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'opnieuwInleveren');
    });
  }

  QueryBuilder<Assignment, Assignment, QDistinct>
      distinctByStatusLaatsteOpdrachtVersie() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'statusLaatsteOpdrachtVersie');
    });
  }

  QueryBuilder<Assignment, Assignment, QDistinct> distinctByTitel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'titel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Assignment, Assignment, QDistinct> distinctByVak(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vak', caseSensitive: caseSensitive);
    });
  }
}

extension AssignmentQueryProperty
    on QueryBuilder<Assignment, Assignment, QQueryProperty> {
  QueryBuilder<Assignment, int, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }

  QueryBuilder<Assignment, bool, QQueryOperations> afgeslotenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'afgesloten');
    });
  }

  QueryBuilder<Assignment, DateTime?, QQueryOperations> beoordeeldOpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'beoordeeldOp');
    });
  }

  QueryBuilder<Assignment, String, QQueryOperations> beoordelingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'beoordeling');
    });
  }

  QueryBuilder<Assignment, List<Docenten>?, QQueryOperations>
      docentenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'docenten');
    });
  }

  QueryBuilder<Assignment, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Assignment, DateTime?, QQueryOperations> ingeleverdOpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ingeleverdOp');
    });
  }

  QueryBuilder<Assignment, DateTime, QQueryOperations> inleverenVoorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'inleverenVoor');
    });
  }

  QueryBuilder<Assignment, int, QQueryOperations>
      laatsteOpdrachtVersienummerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'laatsteOpdrachtVersienummer');
    });
  }

  QueryBuilder<Assignment, List<BronLink>, QQueryOperations> linksProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'links');
    });
  }

  QueryBuilder<Assignment, bool, QQueryOperations> magInleverenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'magInleveren');
    });
  }

  QueryBuilder<Assignment, String, QQueryOperations> omschrijvingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'omschrijving');
    });
  }

  QueryBuilder<Assignment, bool, QQueryOperations> opnieuwInleverenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'opnieuwInleveren');
    });
  }

  QueryBuilder<Assignment, VersieStatus, QQueryOperations>
      statusLaatsteOpdrachtVersieProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statusLaatsteOpdrachtVersie');
    });
  }

  QueryBuilder<Assignment, String, QQueryOperations> titelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'titel');
    });
  }

  QueryBuilder<Assignment, String, QQueryOperations> vakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vak');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAssignmentVersionCollection on Isar {
  IsarCollection<AssignmentVersion> get assignmentVersions => this.collection();
}

const AssignmentVersionSchema = CollectionSchema(
  name: r'AssignmentVersion',
  id: -1410530384118317333,
  properties: {
    r'beoordeeldOp': PropertySchema(
      id: 0,
      name: r'beoordeeldOp',
      type: IsarType.dateTime,
    ),
    r'beoordeling': PropertySchema(
      id: 1,
      name: r'beoordeling',
      type: IsarType.string,
    ),
    r'docentOpmerking': PropertySchema(
      id: 2,
      name: r'docentOpmerking',
      type: IsarType.string,
    ),
    r'gestartOp': PropertySchema(
      id: 3,
      name: r'gestartOp',
      type: IsarType.dateTime,
    ),
    r'id': PropertySchema(
      id: 4,
      name: r'id',
      type: IsarType.long,
    ),
    r'ingeleverdOp': PropertySchema(
      id: 5,
      name: r'ingeleverdOp',
      type: IsarType.dateTime,
    ),
    r'inleverenVoor': PropertySchema(
      id: 6,
      name: r'inleverenVoor',
      type: IsarType.dateTime,
    ),
    r'isTeLaat': PropertySchema(
      id: 7,
      name: r'isTeLaat',
      type: IsarType.bool,
    ),
    r'leerlingOpmerking': PropertySchema(
      id: 8,
      name: r'leerlingOpmerking',
      type: IsarType.string,
    ),
    r'links': PropertySchema(
      id: 9,
      name: r'links',
      type: IsarType.objectList,
      target: r'BronLink',
    ),
    r'omschrijving': PropertySchema(
      id: 10,
      name: r'omschrijving',
      type: IsarType.string,
    ),
    r'opdrachtId': PropertySchema(
      id: 11,
      name: r'opdrachtId',
      type: IsarType.long,
    ),
    r'status': PropertySchema(
      id: 12,
      name: r'status',
      type: IsarType.byte,
      enumMap: _AssignmentVersionstatusEnumValueMap,
    ),
    r'vak': PropertySchema(
      id: 13,
      name: r'vak',
      type: IsarType.string,
    ),
    r'versieNummer': PropertySchema(
      id: 14,
      name: r'versieNummer',
      type: IsarType.long,
    )
  },
  estimateSize: _assignmentVersionEstimateSize,
  serialize: _assignmentVersionSerialize,
  deserialize: _assignmentVersionDeserialize,
  deserializeProp: _assignmentVersionDeserializeProp,
  idName: r'uuid',
  indexes: {},
  links: {
    r'assignment': LinkSchema(
      id: -3889318383635019060,
      name: r'assignment',
      target: r'Assignment',
      single: true,
      linkName: r'versies',
    ),
    r'leerlingBijlagen': LinkSchema(
      id: 5288953927409776802,
      name: r'leerlingBijlagen',
      target: r'Bron',
      single: false,
    ),
    r'feedbackBijlagen': LinkSchema(
      id: 3673252138709554170,
      name: r'feedbackBijlagen',
      target: r'Bron',
      single: false,
    )
  },
  embeddedSchemas: {r'BronLink': BronLinkSchema},
  getId: _assignmentVersionGetId,
  getLinks: _assignmentVersionGetLinks,
  attach: _assignmentVersionAttach,
  version: '3.1.0+1',
);

int _assignmentVersionEstimateSize(
  AssignmentVersion object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.beoordeling;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.docentOpmerking;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.leerlingOpmerking;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.links.length * 3;
  {
    final offsets = allOffsets[BronLink]!;
    for (var i = 0; i < object.links.length; i++) {
      final value = object.links[i];
      bytesCount += BronLinkSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.omschrijving.length * 3;
  bytesCount += 3 + object.vak.length * 3;
  return bytesCount;
}

void _assignmentVersionSerialize(
  AssignmentVersion object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.beoordeeldOp);
  writer.writeString(offsets[1], object.beoordeling);
  writer.writeString(offsets[2], object.docentOpmerking);
  writer.writeDateTime(offsets[3], object.gestartOp);
  writer.writeLong(offsets[4], object.id);
  writer.writeDateTime(offsets[5], object.ingeleverdOp);
  writer.writeDateTime(offsets[6], object.inleverenVoor);
  writer.writeBool(offsets[7], object.isTeLaat);
  writer.writeString(offsets[8], object.leerlingOpmerking);
  writer.writeObjectList<BronLink>(
    offsets[9],
    allOffsets,
    BronLinkSchema.serialize,
    object.links,
  );
  writer.writeString(offsets[10], object.omschrijving);
  writer.writeLong(offsets[11], object.opdrachtId);
  writer.writeByte(offsets[12], object.status.index);
  writer.writeString(offsets[13], object.vak);
  writer.writeLong(offsets[14], object.versieNummer);
}

AssignmentVersion _assignmentVersionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AssignmentVersion(
    beoordeeldOp: reader.readDateTimeOrNull(offsets[0]),
    beoordeling: reader.readStringOrNull(offsets[1]),
    docentOpmerking: reader.readStringOrNull(offsets[2]),
    gestartOp: reader.readDateTimeOrNull(offsets[3]),
    id: reader.readLongOrNull(offsets[4]) ?? 0,
    ingeleverdOp: reader.readDateTimeOrNull(offsets[5]),
    inleverenVoor: reader.readDateTimeOrNull(offsets[6]),
    isTeLaat: reader.readBoolOrNull(offsets[7]) ?? false,
    leerlingOpmerking: reader.readStringOrNull(offsets[8]),
    links: reader.readObjectList<BronLink>(
          offsets[9],
          BronLinkSchema.deserialize,
          allOffsets,
          BronLink(),
        ) ??
        const [],
    omschrijving: reader.readStringOrNull(offsets[10]) ?? "",
    opdrachtId: reader.readLongOrNull(offsets[11]) ?? 0,
    status: _AssignmentVersionstatusValueEnumMap[
            reader.readByteOrNull(offsets[12])] ??
        VersieStatus.geen,
    vak: reader.readStringOrNull(offsets[13]) ?? "",
    versieNummer: reader.readLongOrNull(offsets[14]) ?? 0,
  );
  return object;
}

P _assignmentVersionDeserializeProp<P>(
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
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readObjectList<BronLink>(
            offset,
            BronLinkSchema.deserialize,
            allOffsets,
            BronLink(),
          ) ??
          const []) as P;
    case 10:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 11:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 12:
      return (_AssignmentVersionstatusValueEnumMap[
              reader.readByteOrNull(offset)] ??
          VersieStatus.geen) as P;
    case 13:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 14:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _AssignmentVersionstatusEnumValueMap = {
  'alle': 0,
  'ingeleverd': 1,
  'openstaand': 2,
  'beoordeeld': 3,
  'geen': 4,
  'afgesloten': 5,
};
const _AssignmentVersionstatusValueEnumMap = {
  0: VersieStatus.alle,
  1: VersieStatus.ingeleverd,
  2: VersieStatus.openstaand,
  3: VersieStatus.beoordeeld,
  4: VersieStatus.geen,
  5: VersieStatus.afgesloten,
};

Id _assignmentVersionGetId(AssignmentVersion object) {
  return object.uuid;
}

List<IsarLinkBase<dynamic>> _assignmentVersionGetLinks(
    AssignmentVersion object) {
  return [object.assignment, object.leerlingBijlagen, object.feedbackBijlagen];
}

void _assignmentVersionAttach(
    IsarCollection<dynamic> col, Id id, AssignmentVersion object) {
  object.assignment
      .attach(col, col.isar.collection<Assignment>(), r'assignment', id);
  object.leerlingBijlagen
      .attach(col, col.isar.collection<Bron>(), r'leerlingBijlagen', id);
  object.feedbackBijlagen
      .attach(col, col.isar.collection<Bron>(), r'feedbackBijlagen', id);
}

extension AssignmentVersionQueryWhereSort
    on QueryBuilder<AssignmentVersion, AssignmentVersion, QWhere> {
  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterWhere> anyUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AssignmentVersionQueryWhere
    on QueryBuilder<AssignmentVersion, AssignmentVersion, QWhereClause> {
  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterWhereClause>
      uuidEqualTo(Id uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: uuid,
        upper: uuid,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterWhereClause>
      uuidNotEqualTo(Id uuid) {
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

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterWhereClause>
      uuidGreaterThan(Id uuid, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: uuid, includeLower: include),
      );
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterWhereClause>
      uuidLessThan(Id uuid, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: uuid, includeUpper: include),
      );
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterWhereClause>
      uuidBetween(
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

extension AssignmentVersionQueryFilter
    on QueryBuilder<AssignmentVersion, AssignmentVersion, QFilterCondition> {
  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      beoordeeldOpIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'beoordeeldOp',
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      beoordeeldOpIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'beoordeeldOp',
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      beoordeeldOpEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'beoordeeldOp',
        value: value,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      beoordeeldOpGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'beoordeeldOp',
        value: value,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      beoordeeldOpLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'beoordeeldOp',
        value: value,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      beoordeeldOpBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'beoordeeldOp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      beoordelingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'beoordeling',
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      beoordelingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'beoordeling',
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      beoordelingEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'beoordeling',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      beoordelingGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'beoordeling',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      beoordelingLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'beoordeling',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      beoordelingBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'beoordeling',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      beoordelingStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'beoordeling',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      beoordelingEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'beoordeling',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      beoordelingContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'beoordeling',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      beoordelingMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'beoordeling',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      beoordelingIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'beoordeling',
        value: '',
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      beoordelingIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'beoordeling',
        value: '',
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      docentOpmerkingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'docentOpmerking',
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      docentOpmerkingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'docentOpmerking',
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      docentOpmerkingEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'docentOpmerking',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      docentOpmerkingGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'docentOpmerking',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      docentOpmerkingLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'docentOpmerking',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      docentOpmerkingBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'docentOpmerking',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      docentOpmerkingStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'docentOpmerking',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      docentOpmerkingEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'docentOpmerking',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      docentOpmerkingContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'docentOpmerking',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      docentOpmerkingMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'docentOpmerking',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      docentOpmerkingIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'docentOpmerking',
        value: '',
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      docentOpmerkingIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'docentOpmerking',
        value: '',
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      gestartOpIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'gestartOp',
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      gestartOpIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'gestartOp',
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      gestartOpEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gestartOp',
        value: value,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      gestartOpGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gestartOp',
        value: value,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      gestartOpLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gestartOp',
        value: value,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      gestartOpBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gestartOp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
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

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      ingeleverdOpIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ingeleverdOp',
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      ingeleverdOpIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ingeleverdOp',
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      ingeleverdOpEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ingeleverdOp',
        value: value,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      ingeleverdOpGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ingeleverdOp',
        value: value,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      ingeleverdOpLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ingeleverdOp',
        value: value,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      ingeleverdOpBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ingeleverdOp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      inleverenVoorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'inleverenVoor',
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      inleverenVoorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'inleverenVoor',
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      inleverenVoorEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'inleverenVoor',
        value: value,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      inleverenVoorGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'inleverenVoor',
        value: value,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      inleverenVoorLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'inleverenVoor',
        value: value,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      inleverenVoorBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'inleverenVoor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      isTeLaatEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isTeLaat',
        value: value,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      leerlingOpmerkingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'leerlingOpmerking',
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      leerlingOpmerkingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'leerlingOpmerking',
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      leerlingOpmerkingEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'leerlingOpmerking',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      leerlingOpmerkingGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'leerlingOpmerking',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      leerlingOpmerkingLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'leerlingOpmerking',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      leerlingOpmerkingBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'leerlingOpmerking',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      leerlingOpmerkingStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'leerlingOpmerking',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      leerlingOpmerkingEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'leerlingOpmerking',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      leerlingOpmerkingContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'leerlingOpmerking',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      leerlingOpmerkingMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'leerlingOpmerking',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      leerlingOpmerkingIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'leerlingOpmerking',
        value: '',
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      leerlingOpmerkingIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'leerlingOpmerking',
        value: '',
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      linksLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'links',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      linksIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'links',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      linksIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'links',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      linksLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'links',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      linksLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'links',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      linksLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'links',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
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

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
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

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
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

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
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

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
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

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
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

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      omschrijvingContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'omschrijving',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      omschrijvingMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'omschrijving',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      omschrijvingIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'omschrijving',
        value: '',
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      omschrijvingIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'omschrijving',
        value: '',
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      opdrachtIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'opdrachtId',
        value: value,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
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

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
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

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
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

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      statusEqualTo(VersieStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      statusGreaterThan(
    VersieStatus value, {
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

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      statusLessThan(
    VersieStatus value, {
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

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      statusBetween(
    VersieStatus lower,
    VersieStatus upper, {
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

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      uuidEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
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

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
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

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      uuidBetween(
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

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      vakEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vak',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      vakGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vak',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      vakLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vak',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      vakBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      vakStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vak',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      vakEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vak',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      vakContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vak',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      vakMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vak',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      vakIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vak',
        value: '',
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      vakIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vak',
        value: '',
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      versieNummerEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'versieNummer',
        value: value,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      versieNummerGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'versieNummer',
        value: value,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      versieNummerLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'versieNummer',
        value: value,
      ));
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      versieNummerBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'versieNummer',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AssignmentVersionQueryObject
    on QueryBuilder<AssignmentVersion, AssignmentVersion, QFilterCondition> {
  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      linksElement(FilterQuery<BronLink> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'links');
    });
  }
}

extension AssignmentVersionQueryLinks
    on QueryBuilder<AssignmentVersion, AssignmentVersion, QFilterCondition> {
  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      assignment(FilterQuery<Assignment> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'assignment');
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      assignmentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'assignment', 0, true, 0, true);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      leerlingBijlagen(FilterQuery<Bron> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'leerlingBijlagen');
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      leerlingBijlagenLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'leerlingBijlagen', length, true, length, true);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      leerlingBijlagenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'leerlingBijlagen', 0, true, 0, true);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      leerlingBijlagenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'leerlingBijlagen', 0, false, 999999, true);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      leerlingBijlagenLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'leerlingBijlagen', 0, true, length, include);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      leerlingBijlagenLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'leerlingBijlagen', length, include, 999999, true);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      leerlingBijlagenLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'leerlingBijlagen', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      feedbackBijlagen(FilterQuery<Bron> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'feedbackBijlagen');
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      feedbackBijlagenLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'feedbackBijlagen', length, true, length, true);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      feedbackBijlagenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'feedbackBijlagen', 0, true, 0, true);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      feedbackBijlagenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'feedbackBijlagen', 0, false, 999999, true);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      feedbackBijlagenLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'feedbackBijlagen', 0, true, length, include);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      feedbackBijlagenLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'feedbackBijlagen', length, include, 999999, true);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterFilterCondition>
      feedbackBijlagenLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'feedbackBijlagen', lower, includeLower, upper, includeUpper);
    });
  }
}

extension AssignmentVersionQuerySortBy
    on QueryBuilder<AssignmentVersion, AssignmentVersion, QSortBy> {
  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      sortByBeoordeeldOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beoordeeldOp', Sort.asc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      sortByBeoordeeldOpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beoordeeldOp', Sort.desc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      sortByBeoordeling() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beoordeling', Sort.asc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      sortByBeoordelingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beoordeling', Sort.desc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      sortByDocentOpmerking() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'docentOpmerking', Sort.asc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      sortByDocentOpmerkingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'docentOpmerking', Sort.desc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      sortByGestartOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gestartOp', Sort.asc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      sortByGestartOpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gestartOp', Sort.desc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      sortByIngeleverdOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingeleverdOp', Sort.asc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      sortByIngeleverdOpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingeleverdOp', Sort.desc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      sortByInleverenVoor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inleverenVoor', Sort.asc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      sortByInleverenVoorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inleverenVoor', Sort.desc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      sortByIsTeLaat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTeLaat', Sort.asc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      sortByIsTeLaatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTeLaat', Sort.desc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      sortByLeerlingOpmerking() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leerlingOpmerking', Sort.asc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      sortByLeerlingOpmerkingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leerlingOpmerking', Sort.desc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      sortByOmschrijving() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'omschrijving', Sort.asc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      sortByOmschrijvingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'omschrijving', Sort.desc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      sortByOpdrachtId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'opdrachtId', Sort.asc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      sortByOpdrachtIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'opdrachtId', Sort.desc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy> sortByVak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vak', Sort.asc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      sortByVakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vak', Sort.desc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      sortByVersieNummer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'versieNummer', Sort.asc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      sortByVersieNummerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'versieNummer', Sort.desc);
    });
  }
}

extension AssignmentVersionQuerySortThenBy
    on QueryBuilder<AssignmentVersion, AssignmentVersion, QSortThenBy> {
  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      thenByBeoordeeldOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beoordeeldOp', Sort.asc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      thenByBeoordeeldOpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beoordeeldOp', Sort.desc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      thenByBeoordeling() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beoordeling', Sort.asc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      thenByBeoordelingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beoordeling', Sort.desc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      thenByDocentOpmerking() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'docentOpmerking', Sort.asc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      thenByDocentOpmerkingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'docentOpmerking', Sort.desc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      thenByGestartOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gestartOp', Sort.asc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      thenByGestartOpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gestartOp', Sort.desc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      thenByIngeleverdOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingeleverdOp', Sort.asc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      thenByIngeleverdOpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingeleverdOp', Sort.desc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      thenByInleverenVoor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inleverenVoor', Sort.asc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      thenByInleverenVoorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inleverenVoor', Sort.desc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      thenByIsTeLaat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTeLaat', Sort.asc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      thenByIsTeLaatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTeLaat', Sort.desc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      thenByLeerlingOpmerking() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leerlingOpmerking', Sort.asc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      thenByLeerlingOpmerkingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leerlingOpmerking', Sort.desc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      thenByOmschrijving() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'omschrijving', Sort.asc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      thenByOmschrijvingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'omschrijving', Sort.desc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      thenByOpdrachtId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'opdrachtId', Sort.asc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      thenByOpdrachtIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'opdrachtId', Sort.desc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy> thenByVak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vak', Sort.asc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      thenByVakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vak', Sort.desc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      thenByVersieNummer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'versieNummer', Sort.asc);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QAfterSortBy>
      thenByVersieNummerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'versieNummer', Sort.desc);
    });
  }
}

extension AssignmentVersionQueryWhereDistinct
    on QueryBuilder<AssignmentVersion, AssignmentVersion, QDistinct> {
  QueryBuilder<AssignmentVersion, AssignmentVersion, QDistinct>
      distinctByBeoordeeldOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'beoordeeldOp');
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QDistinct>
      distinctByBeoordeling({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'beoordeling', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QDistinct>
      distinctByDocentOpmerking({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'docentOpmerking',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QDistinct>
      distinctByGestartOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gestartOp');
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QDistinct> distinctById() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id');
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QDistinct>
      distinctByIngeleverdOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ingeleverdOp');
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QDistinct>
      distinctByInleverenVoor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'inleverenVoor');
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QDistinct>
      distinctByIsTeLaat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isTeLaat');
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QDistinct>
      distinctByLeerlingOpmerking({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'leerlingOpmerking',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QDistinct>
      distinctByOmschrijving({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'omschrijving', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QDistinct>
      distinctByOpdrachtId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'opdrachtId');
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QDistinct>
      distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QDistinct> distinctByVak(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vak', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssignmentVersion, AssignmentVersion, QDistinct>
      distinctByVersieNummer() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'versieNummer');
    });
  }
}

extension AssignmentVersionQueryProperty
    on QueryBuilder<AssignmentVersion, AssignmentVersion, QQueryProperty> {
  QueryBuilder<AssignmentVersion, int, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }

  QueryBuilder<AssignmentVersion, DateTime?, QQueryOperations>
      beoordeeldOpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'beoordeeldOp');
    });
  }

  QueryBuilder<AssignmentVersion, String?, QQueryOperations>
      beoordelingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'beoordeling');
    });
  }

  QueryBuilder<AssignmentVersion, String?, QQueryOperations>
      docentOpmerkingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'docentOpmerking');
    });
  }

  QueryBuilder<AssignmentVersion, DateTime?, QQueryOperations>
      gestartOpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gestartOp');
    });
  }

  QueryBuilder<AssignmentVersion, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AssignmentVersion, DateTime?, QQueryOperations>
      ingeleverdOpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ingeleverdOp');
    });
  }

  QueryBuilder<AssignmentVersion, DateTime?, QQueryOperations>
      inleverenVoorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'inleverenVoor');
    });
  }

  QueryBuilder<AssignmentVersion, bool, QQueryOperations> isTeLaatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isTeLaat');
    });
  }

  QueryBuilder<AssignmentVersion, String?, QQueryOperations>
      leerlingOpmerkingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'leerlingOpmerking');
    });
  }

  QueryBuilder<AssignmentVersion, List<BronLink>, QQueryOperations>
      linksProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'links');
    });
  }

  QueryBuilder<AssignmentVersion, String, QQueryOperations>
      omschrijvingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'omschrijving');
    });
  }

  QueryBuilder<AssignmentVersion, int, QQueryOperations> opdrachtIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'opdrachtId');
    });
  }

  QueryBuilder<AssignmentVersion, VersieStatus, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<AssignmentVersion, String, QQueryOperations> vakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vak');
    });
  }

  QueryBuilder<AssignmentVersion, int, QQueryOperations>
      versieNummerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'versieNummer');
    });
  }
}
