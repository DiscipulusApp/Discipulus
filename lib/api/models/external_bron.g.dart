// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'external_bron.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetExternalBronSourceCollection on Isar {
  IsarCollection<ExternalBronSource> get externalBronSources =>
      this.collection();
}

const ExternalBronSourceSchema = CollectionSchema(
  name: r'ExternalBronSource',
  id: 8941995980747855135,
  properties: {
    r'bronSoort': PropertySchema(
      id: 0,
      name: r'bronSoort',
      type: IsarType.long,
    ),
    r'contentType': PropertySchema(
      id: 1,
      name: r'contentType',
      type: IsarType.string,
    ),
    r'fileBlobId': PropertySchema(
      id: 2,
      name: r'fileBlobId',
      type: IsarType.long,
    ),
    r'gemaaktOp': PropertySchema(
      id: 3,
      name: r'gemaaktOp',
      type: IsarType.dateTime,
    ),
    r'geplaatstDoor': PropertySchema(
      id: 4,
      name: r'geplaatstDoor',
      type: IsarType.string,
    ),
    r'gewijzigdOp': PropertySchema(
      id: 5,
      name: r'gewijzigdOp',
      type: IsarType.dateTime,
    ),
    r'grootte': PropertySchema(
      id: 6,
      name: r'grootte',
      type: IsarType.long,
    ),
    r'id': PropertySchema(
      id: 7,
      name: r'id',
      type: IsarType.long,
    ),
    r'links': PropertySchema(
      id: 8,
      name: r'links',
      type: IsarType.objectList,
      target: r'ExternalResourceLink',
    ),
    r'moduleSoort': PropertySchema(
      id: 9,
      name: r'moduleSoort',
      type: IsarType.long,
    ),
    r'naam': PropertySchema(
      id: 10,
      name: r'naam',
      type: IsarType.string,
    ),
    r'parentId': PropertySchema(
      id: 11,
      name: r'parentId',
      type: IsarType.long,
    ),
    r'privilege': PropertySchema(
      id: 12,
      name: r'privilege',
      type: IsarType.long,
    ),
    r'referentie': PropertySchema(
      id: 13,
      name: r'referentie',
      type: IsarType.long,
    ),
    r'type': PropertySchema(
      id: 14,
      name: r'type',
      type: IsarType.long,
    ),
    r'uniqueId': PropertySchema(
      id: 15,
      name: r'uniqueId',
      type: IsarType.string,
    ),
    r'uri': PropertySchema(
      id: 16,
      name: r'uri',
      type: IsarType.string,
    ),
    r'volgnr': PropertySchema(
      id: 17,
      name: r'volgnr',
      type: IsarType.long,
    )
  },
  estimateSize: _externalBronSourceEstimateSize,
  serialize: _externalBronSourceSerialize,
  deserialize: _externalBronSourceDeserialize,
  deserializeProp: _externalBronSourceDeserializeProp,
  idName: r'uuid',
  indexes: {},
  links: {
    r'profile': LinkSchema(
      id: 2352577315874126163,
      name: r'profile',
      target: r'Profile',
      single: true,
      linkName: r'externalBronnen',
    ),
    r'bronnen': LinkSchema(
      id: 3649275002701800480,
      name: r'bronnen',
      target: r'Bron',
      single: false,
    )
  },
  embeddedSchemas: {r'ExternalResourceLink': ExternalResourceLinkSchema},
  getId: _externalBronSourceGetId,
  getLinks: _externalBronSourceGetLinks,
  attach: _externalBronSourceAttach,
  version: '3.1.0+1',
);

int _externalBronSourceEstimateSize(
  ExternalBronSource object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.contentType.length * 3;
  {
    final value = object.geplaatstDoor;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.links.length * 3;
  {
    final offsets = allOffsets[ExternalResourceLink]!;
    for (var i = 0; i < object.links.length; i++) {
      final value = object.links[i];
      bytesCount +=
          ExternalResourceLinkSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.naam.length * 3;
  bytesCount += 3 + object.uniqueId.length * 3;
  {
    final value = object.uri;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _externalBronSourceSerialize(
  ExternalBronSource object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.bronSoort);
  writer.writeString(offsets[1], object.contentType);
  writer.writeLong(offsets[2], object.fileBlobId);
  writer.writeDateTime(offsets[3], object.gemaaktOp);
  writer.writeString(offsets[4], object.geplaatstDoor);
  writer.writeDateTime(offsets[5], object.gewijzigdOp);
  writer.writeLong(offsets[6], object.grootte);
  writer.writeLong(offsets[7], object.id);
  writer.writeObjectList<ExternalResourceLink>(
    offsets[8],
    allOffsets,
    ExternalResourceLinkSchema.serialize,
    object.links,
  );
  writer.writeLong(offsets[9], object.moduleSoort);
  writer.writeString(offsets[10], object.naam);
  writer.writeLong(offsets[11], object.parentId);
  writer.writeLong(offsets[12], object.privilege);
  writer.writeLong(offsets[13], object.referentie);
  writer.writeLong(offsets[14], object.type);
  writer.writeString(offsets[15], object.uniqueId);
  writer.writeString(offsets[16], object.uri);
  writer.writeLong(offsets[17], object.volgnr);
}

ExternalBronSource _externalBronSourceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ExternalBronSource(
    bronSoort: reader.readLong(offsets[0]),
    contentType: reader.readString(offsets[1]),
    fileBlobId: reader.readLong(offsets[2]),
    gemaaktOp: reader.readDateTimeOrNull(offsets[3]),
    geplaatstDoor: reader.readStringOrNull(offsets[4]),
    gewijzigdOp: reader.readDateTimeOrNull(offsets[5]),
    grootte: reader.readLong(offsets[6]),
    id: reader.readLong(offsets[7]),
    links: reader.readObjectList<ExternalResourceLink>(
          offsets[8],
          ExternalResourceLinkSchema.deserialize,
          allOffsets,
          ExternalResourceLink(),
        ) ??
        [],
    moduleSoort: reader.readLong(offsets[9]),
    naam: reader.readString(offsets[10]),
    parentId: reader.readLong(offsets[11]),
    privilege: reader.readLong(offsets[12]),
    referentie: reader.readLong(offsets[13]),
    type: reader.readLong(offsets[14]),
    uniqueId: reader.readString(offsets[15]),
    uri: reader.readStringOrNull(offsets[16]),
    volgnr: reader.readLong(offsets[17]),
  );
  return object;
}

P _externalBronSourceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readObjectList<ExternalResourceLink>(
            offset,
            ExternalResourceLinkSchema.deserialize,
            allOffsets,
            ExternalResourceLink(),
          ) ??
          []) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _externalBronSourceGetId(ExternalBronSource object) {
  return object.uuid;
}

List<IsarLinkBase<dynamic>> _externalBronSourceGetLinks(
    ExternalBronSource object) {
  return [object.profile, object.bronnen];
}

void _externalBronSourceAttach(
    IsarCollection<dynamic> col, Id id, ExternalBronSource object) {
  object.profile.attach(col, col.isar.collection<Profile>(), r'profile', id);
  object.bronnen.attach(col, col.isar.collection<Bron>(), r'bronnen', id);
}

extension ExternalBronSourceQueryWhereSort
    on QueryBuilder<ExternalBronSource, ExternalBronSource, QWhere> {
  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterWhere> anyUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ExternalBronSourceQueryWhere
    on QueryBuilder<ExternalBronSource, ExternalBronSource, QWhereClause> {
  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterWhereClause>
      uuidEqualTo(Id uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: uuid,
        upper: uuid,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterWhereClause>
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

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterWhereClause>
      uuidGreaterThan(Id uuid, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: uuid, includeLower: include),
      );
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterWhereClause>
      uuidLessThan(Id uuid, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: uuid, includeUpper: include),
      );
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterWhereClause>
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

extension ExternalBronSourceQueryFilter
    on QueryBuilder<ExternalBronSource, ExternalBronSource, QFilterCondition> {
  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      bronSoortEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bronSoort',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      bronSoortGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bronSoort',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      bronSoortLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bronSoort',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      bronSoortBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bronSoort',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      contentTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      contentTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      contentTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      contentTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contentType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      contentTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'contentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      contentTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'contentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      contentTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'contentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      contentTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'contentType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      contentTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contentType',
        value: '',
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      contentTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'contentType',
        value: '',
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      fileBlobIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fileBlobId',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      fileBlobIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fileBlobId',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      fileBlobIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fileBlobId',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      fileBlobIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fileBlobId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      gemaaktOpIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'gemaaktOp',
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      gemaaktOpIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'gemaaktOp',
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      gemaaktOpEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gemaaktOp',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      gemaaktOpGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gemaaktOp',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      gemaaktOpLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gemaaktOp',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      gemaaktOpBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gemaaktOp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      geplaatstDoorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'geplaatstDoor',
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      geplaatstDoorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'geplaatstDoor',
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      geplaatstDoorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'geplaatstDoor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      geplaatstDoorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'geplaatstDoor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      geplaatstDoorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'geplaatstDoor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      geplaatstDoorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'geplaatstDoor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      geplaatstDoorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'geplaatstDoor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      geplaatstDoorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'geplaatstDoor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      geplaatstDoorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'geplaatstDoor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      geplaatstDoorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'geplaatstDoor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      geplaatstDoorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'geplaatstDoor',
        value: '',
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      geplaatstDoorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'geplaatstDoor',
        value: '',
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      gewijzigdOpIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'gewijzigdOp',
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      gewijzigdOpIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'gewijzigdOp',
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      gewijzigdOpEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gewijzigdOp',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      gewijzigdOpGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gewijzigdOp',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      gewijzigdOpLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gewijzigdOp',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      gewijzigdOpBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gewijzigdOp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      grootteEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'grootte',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      grootteGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'grootte',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      grootteLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'grootte',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      grootteBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'grootte',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
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

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
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

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
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

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
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

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
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

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
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

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
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

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
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

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
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

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      moduleSoortEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moduleSoort',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      moduleSoortGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'moduleSoort',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      moduleSoortLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'moduleSoort',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      moduleSoortBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'moduleSoort',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      naamEqualTo(
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

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      naamGreaterThan(
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

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      naamLessThan(
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

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      naamBetween(
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

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      naamStartsWith(
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

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      naamEndsWith(
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

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      naamContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'naam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      naamMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'naam',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      naamIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'naam',
        value: '',
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      naamIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'naam',
        value: '',
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      parentIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentId',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      parentIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'parentId',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      parentIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'parentId',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      parentIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'parentId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      privilegeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'privilege',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      privilegeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'privilege',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      privilegeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'privilege',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      privilegeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'privilege',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      referentieEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'referentie',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      referentieGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'referentie',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      referentieLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'referentie',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      referentieBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'referentie',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      typeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      typeGreaterThan(
    int value, {
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

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      typeLessThan(
    int value, {
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

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      typeBetween(
    int lower,
    int upper, {
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

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      uniqueIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uniqueId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      uniqueIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uniqueId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      uniqueIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uniqueId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      uniqueIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uniqueId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      uniqueIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uniqueId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      uniqueIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uniqueId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      uniqueIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uniqueId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      uniqueIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uniqueId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      uniqueIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uniqueId',
        value: '',
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      uniqueIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uniqueId',
        value: '',
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      uriIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'uri',
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      uriIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'uri',
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      uriEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      uriGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      uriLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      uriBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uri',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      uriStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      uriEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      uriContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      uriMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uri',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      uriIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uri',
        value: '',
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      uriIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uri',
        value: '',
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      uuidEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
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

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
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

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
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

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      volgnrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'volgnr',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      volgnrGreaterThan(
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

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      volgnrLessThan(
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

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      volgnrBetween(
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

extension ExternalBronSourceQueryObject
    on QueryBuilder<ExternalBronSource, ExternalBronSource, QFilterCondition> {
  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      linksElement(FilterQuery<ExternalResourceLink> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'links');
    });
  }
}

extension ExternalBronSourceQueryLinks
    on QueryBuilder<ExternalBronSource, ExternalBronSource, QFilterCondition> {
  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      profile(FilterQuery<Profile> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'profile');
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      profileIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'profile', 0, true, 0, true);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      bronnen(FilterQuery<Bron> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'bronnen');
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      bronnenLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', length, true, length, true);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      bronnenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', 0, true, 0, true);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      bronnenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', 0, false, 999999, true);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      bronnenLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', 0, true, length, include);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
      bronnenLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', length, include, 999999, true);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterFilterCondition>
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
}

extension ExternalBronSourceQuerySortBy
    on QueryBuilder<ExternalBronSource, ExternalBronSource, QSortBy> {
  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByBronSoort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bronSoort', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByBronSoortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bronSoort', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByContentType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentType', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByContentTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentType', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByFileBlobId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileBlobId', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByFileBlobIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileBlobId', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByGemaaktOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gemaaktOp', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByGemaaktOpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gemaaktOp', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByGeplaatstDoor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geplaatstDoor', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByGeplaatstDoorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geplaatstDoor', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByGewijzigdOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gewijzigdOp', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByGewijzigdOpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gewijzigdOp', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByGrootte() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grootte', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByGrootteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grootte', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByModuleSoort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moduleSoort', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByModuleSoortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moduleSoort', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByNaam() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'naam', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByNaamDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'naam', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByParentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentId', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByParentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentId', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByPrivilege() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privilege', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByPrivilegeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privilege', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByReferentie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referentie', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByReferentieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referentie', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByUniqueId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uniqueId', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByUniqueIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uniqueId', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByUri() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uri', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByUriDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uri', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByVolgnr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volgnr', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      sortByVolgnrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volgnr', Sort.desc);
    });
  }
}

extension ExternalBronSourceQuerySortThenBy
    on QueryBuilder<ExternalBronSource, ExternalBronSource, QSortThenBy> {
  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByBronSoort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bronSoort', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByBronSoortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bronSoort', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByContentType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentType', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByContentTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentType', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByFileBlobId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileBlobId', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByFileBlobIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileBlobId', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByGemaaktOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gemaaktOp', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByGemaaktOpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gemaaktOp', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByGeplaatstDoor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geplaatstDoor', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByGeplaatstDoorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geplaatstDoor', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByGewijzigdOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gewijzigdOp', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByGewijzigdOpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gewijzigdOp', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByGrootte() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grootte', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByGrootteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grootte', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByModuleSoort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moduleSoort', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByModuleSoortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moduleSoort', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByNaam() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'naam', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByNaamDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'naam', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByParentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentId', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByParentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentId', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByPrivilege() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privilege', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByPrivilegeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privilege', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByReferentie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referentie', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByReferentieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referentie', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByUniqueId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uniqueId', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByUniqueIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uniqueId', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByUri() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uri', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByUriDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uri', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByVolgnr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volgnr', Sort.asc);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QAfterSortBy>
      thenByVolgnrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volgnr', Sort.desc);
    });
  }
}

extension ExternalBronSourceQueryWhereDistinct
    on QueryBuilder<ExternalBronSource, ExternalBronSource, QDistinct> {
  QueryBuilder<ExternalBronSource, ExternalBronSource, QDistinct>
      distinctByBronSoort() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bronSoort');
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QDistinct>
      distinctByContentType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contentType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QDistinct>
      distinctByFileBlobId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fileBlobId');
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QDistinct>
      distinctByGemaaktOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gemaaktOp');
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QDistinct>
      distinctByGeplaatstDoor({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'geplaatstDoor',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QDistinct>
      distinctByGewijzigdOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gewijzigdOp');
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QDistinct>
      distinctByGrootte() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'grootte');
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QDistinct>
      distinctById() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id');
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QDistinct>
      distinctByModuleSoort() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'moduleSoort');
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QDistinct>
      distinctByNaam({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'naam', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QDistinct>
      distinctByParentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parentId');
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QDistinct>
      distinctByPrivilege() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'privilege');
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QDistinct>
      distinctByReferentie() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'referentie');
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QDistinct>
      distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QDistinct>
      distinctByUniqueId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uniqueId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QDistinct> distinctByUri(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uri', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExternalBronSource, ExternalBronSource, QDistinct>
      distinctByVolgnr() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'volgnr');
    });
  }
}

extension ExternalBronSourceQueryProperty
    on QueryBuilder<ExternalBronSource, ExternalBronSource, QQueryProperty> {
  QueryBuilder<ExternalBronSource, int, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }

  QueryBuilder<ExternalBronSource, int, QQueryOperations> bronSoortProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bronSoort');
    });
  }

  QueryBuilder<ExternalBronSource, String, QQueryOperations>
      contentTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contentType');
    });
  }

  QueryBuilder<ExternalBronSource, int, QQueryOperations> fileBlobIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fileBlobId');
    });
  }

  QueryBuilder<ExternalBronSource, DateTime?, QQueryOperations>
      gemaaktOpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gemaaktOp');
    });
  }

  QueryBuilder<ExternalBronSource, String?, QQueryOperations>
      geplaatstDoorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'geplaatstDoor');
    });
  }

  QueryBuilder<ExternalBronSource, DateTime?, QQueryOperations>
      gewijzigdOpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gewijzigdOp');
    });
  }

  QueryBuilder<ExternalBronSource, int, QQueryOperations> grootteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'grootte');
    });
  }

  QueryBuilder<ExternalBronSource, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ExternalBronSource, List<ExternalResourceLink>, QQueryOperations>
      linksProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'links');
    });
  }

  QueryBuilder<ExternalBronSource, int, QQueryOperations>
      moduleSoortProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'moduleSoort');
    });
  }

  QueryBuilder<ExternalBronSource, String, QQueryOperations> naamProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'naam');
    });
  }

  QueryBuilder<ExternalBronSource, int, QQueryOperations> parentIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parentId');
    });
  }

  QueryBuilder<ExternalBronSource, int, QQueryOperations> privilegeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'privilege');
    });
  }

  QueryBuilder<ExternalBronSource, int, QQueryOperations> referentieProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'referentie');
    });
  }

  QueryBuilder<ExternalBronSource, int, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<ExternalBronSource, String, QQueryOperations>
      uniqueIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uniqueId');
    });
  }

  QueryBuilder<ExternalBronSource, String?, QQueryOperations> uriProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uri');
    });
  }

  QueryBuilder<ExternalBronSource, int, QQueryOperations> volgnrProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'volgnr');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ExternalResourceLinkSchema = Schema(
  name: r'ExternalResourceLink',
  id: 4962676544799881327,
  properties: {
    r'href': PropertySchema(
      id: 0,
      name: r'href',
      type: IsarType.string,
    ),
    r'rel': PropertySchema(
      id: 1,
      name: r'rel',
      type: IsarType.string,
    )
  },
  estimateSize: _externalResourceLinkEstimateSize,
  serialize: _externalResourceLinkSerialize,
  deserialize: _externalResourceLinkDeserialize,
  deserializeProp: _externalResourceLinkDeserializeProp,
);

int _externalResourceLinkEstimateSize(
  ExternalResourceLink object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.href.length * 3;
  bytesCount += 3 + object.rel.length * 3;
  return bytesCount;
}

void _externalResourceLinkSerialize(
  ExternalResourceLink object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.href);
  writer.writeString(offsets[1], object.rel);
}

ExternalResourceLink _externalResourceLinkDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ExternalResourceLink(
    href: reader.readStringOrNull(offsets[0]) ?? "",
    rel: reader.readStringOrNull(offsets[1]) ?? "",
  );
  return object;
}

P _externalResourceLinkDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? "") as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ExternalResourceLinkQueryFilter on QueryBuilder<ExternalResourceLink,
    ExternalResourceLink, QFilterCondition> {
  QueryBuilder<ExternalResourceLink, ExternalResourceLink,
      QAfterFilterCondition> hrefEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'href',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalResourceLink, ExternalResourceLink,
      QAfterFilterCondition> hrefGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'href',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalResourceLink, ExternalResourceLink,
      QAfterFilterCondition> hrefLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'href',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalResourceLink, ExternalResourceLink,
      QAfterFilterCondition> hrefBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'href',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalResourceLink, ExternalResourceLink,
      QAfterFilterCondition> hrefStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'href',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalResourceLink, ExternalResourceLink,
      QAfterFilterCondition> hrefEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'href',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalResourceLink, ExternalResourceLink,
          QAfterFilterCondition>
      hrefContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'href',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalResourceLink, ExternalResourceLink,
          QAfterFilterCondition>
      hrefMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'href',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalResourceLink, ExternalResourceLink,
      QAfterFilterCondition> hrefIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'href',
        value: '',
      ));
    });
  }

  QueryBuilder<ExternalResourceLink, ExternalResourceLink,
      QAfterFilterCondition> hrefIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'href',
        value: '',
      ));
    });
  }

  QueryBuilder<ExternalResourceLink, ExternalResourceLink,
      QAfterFilterCondition> relEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalResourceLink, ExternalResourceLink,
      QAfterFilterCondition> relGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalResourceLink, ExternalResourceLink,
      QAfterFilterCondition> relLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalResourceLink, ExternalResourceLink,
      QAfterFilterCondition> relBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalResourceLink, ExternalResourceLink,
      QAfterFilterCondition> relStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalResourceLink, ExternalResourceLink,
      QAfterFilterCondition> relEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalResourceLink, ExternalResourceLink,
          QAfterFilterCondition>
      relContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalResourceLink, ExternalResourceLink,
          QAfterFilterCondition>
      relMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalResourceLink, ExternalResourceLink,
      QAfterFilterCondition> relIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rel',
        value: '',
      ));
    });
  }

  QueryBuilder<ExternalResourceLink, ExternalResourceLink,
      QAfterFilterCondition> relIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rel',
        value: '',
      ));
    });
  }
}

extension ExternalResourceLinkQueryObject on QueryBuilder<ExternalResourceLink,
    ExternalResourceLink, QFilterCondition> {}
