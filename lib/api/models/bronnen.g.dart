// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bronnen.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBronCollection on Isar {
  IsarCollection<Bron> get brons => this.collection();
}

const BronSchema = CollectionSchema(
  name: r'Bron',
  id: 7085608176391375741,
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
    r'customName': PropertySchema(
      id: 2,
      name: r'customName',
      type: IsarType.string,
    ),
    r'datum': PropertySchema(
      id: 3,
      name: r'datum',
      type: IsarType.dateTime,
    ),
    r'grootte': PropertySchema(
      id: 4,
      name: r'grootte',
      type: IsarType.long,
    ),
    r'id': PropertySchema(
      id: 5,
      name: r'id',
      type: IsarType.long,
    ),
    r'isDownloading': PropertySchema(
      id: 6,
      name: r'isDownloading',
      type: IsarType.bool,
    ),
    r'isFavorite': PropertySchema(
      id: 7,
      name: r'isFavorite',
      type: IsarType.bool,
    ),
    r'lastUsed': PropertySchema(
      id: 8,
      name: r'lastUsed',
      type: IsarType.dateTime,
    ),
    r'links': PropertySchema(
      id: 9,
      name: r'links',
      type: IsarType.objectList,
      target: r'BronLink',
    ),
    r'parentId': PropertySchema(
      id: 10,
      name: r'parentId',
      type: IsarType.long,
    ),
    r'rawNaam': PropertySchema(
      id: 11,
      name: r'rawNaam',
      type: IsarType.string,
    ),
    r'rawSavedPath': PropertySchema(
      id: 12,
      name: r'rawSavedPath',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 13,
      name: r'status',
      type: IsarType.long,
    )
  },
  estimateSize: _bronEstimateSize,
  serialize: _bronSerialize,
  deserialize: _bronDeserialize,
  deserializeProp: _bronDeserializeProp,
  idName: r'uuid',
  indexes: {},
  links: {
    r'profile': LinkSchema(
      id: 926761761364229238,
      name: r'profile',
      target: r'Profile',
      single: true,
    ),
    r'source': LinkSchema(
      id: -3497391632416373215,
      name: r'source',
      target: r'ExternalBronSource',
      single: true,
      linkName: r'bronnen',
    )
  },
  embeddedSchemas: {r'BronLink': BronLinkSchema},
  getId: _bronGetId,
  getLinks: _bronGetLinks,
  attach: _bronAttach,
  version: '3.1.0+1',
);

int _bronEstimateSize(
  Bron object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.contentType.length * 3;
  {
    final value = object.customName;
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
  bytesCount += 3 + object.rawNaam.length * 3;
  {
    final value = object.rawSavedPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _bronSerialize(
  Bron object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.bronSoort);
  writer.writeString(offsets[1], object.contentType);
  writer.writeString(offsets[2], object.customName);
  writer.writeDateTime(offsets[3], object.datum);
  writer.writeLong(offsets[4], object.grootte);
  writer.writeLong(offsets[5], object.id);
  writer.writeBool(offsets[6], object.isDownloading);
  writer.writeBool(offsets[7], object.isFavorite);
  writer.writeDateTime(offsets[8], object.lastUsed);
  writer.writeObjectList<BronLink>(
    offsets[9],
    allOffsets,
    BronLinkSchema.serialize,
    object.links,
  );
  writer.writeLong(offsets[10], object.parentId);
  writer.writeString(offsets[11], object.rawNaam);
  writer.writeString(offsets[12], object.rawSavedPath);
  writer.writeLong(offsets[13], object.status);
}

Bron _bronDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Bron(
    bronSoort: reader.readLong(offsets[0]),
    contentType: reader.readString(offsets[1]),
    datum: reader.readDateTimeOrNull(offsets[3]),
    grootte: reader.readLong(offsets[4]),
    id: reader.readLong(offsets[5]),
    links: reader.readObjectList<BronLink>(
          offsets[9],
          BronLinkSchema.deserialize,
          allOffsets,
          BronLink(),
        ) ??
        [],
    parentId: reader.readLong(offsets[10]),
    rawNaam: reader.readString(offsets[11]),
    status: reader.readLongOrNull(offsets[13]),
  );
  object.customName = reader.readStringOrNull(offsets[2]);
  object.isDownloading = reader.readBool(offsets[6]);
  object.isFavorite = reader.readBool(offsets[7]);
  object.lastUsed = reader.readDateTimeOrNull(offsets[8]);
  object.rawSavedPath = reader.readStringOrNull(offsets[12]);
  return object;
}

P _bronDeserializeProp<P>(
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
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 9:
      return (reader.readObjectList<BronLink>(
            offset,
            BronLinkSchema.deserialize,
            allOffsets,
            BronLink(),
          ) ??
          []) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _bronGetId(Bron object) {
  return object.uuid;
}

List<IsarLinkBase<dynamic>> _bronGetLinks(Bron object) {
  return [object.profile, object.source];
}

void _bronAttach(IsarCollection<dynamic> col, Id id, Bron object) {
  object.profile.attach(col, col.isar.collection<Profile>(), r'profile', id);
  object.source
      .attach(col, col.isar.collection<ExternalBronSource>(), r'source', id);
}

extension BronQueryWhereSort on QueryBuilder<Bron, Bron, QWhere> {
  QueryBuilder<Bron, Bron, QAfterWhere> anyUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BronQueryWhere on QueryBuilder<Bron, Bron, QWhereClause> {
  QueryBuilder<Bron, Bron, QAfterWhereClause> uuidEqualTo(Id uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: uuid,
        upper: uuid,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterWhereClause> uuidNotEqualTo(Id uuid) {
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

  QueryBuilder<Bron, Bron, QAfterWhereClause> uuidGreaterThan(Id uuid,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: uuid, includeLower: include),
      );
    });
  }

  QueryBuilder<Bron, Bron, QAfterWhereClause> uuidLessThan(Id uuid,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: uuid, includeUpper: include),
      );
    });
  }

  QueryBuilder<Bron, Bron, QAfterWhereClause> uuidBetween(
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

extension BronQueryFilter on QueryBuilder<Bron, Bron, QFilterCondition> {
  QueryBuilder<Bron, Bron, QAfterFilterCondition> bronSoortEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bronSoort',
        value: value,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> bronSoortGreaterThan(
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

  QueryBuilder<Bron, Bron, QAfterFilterCondition> bronSoortLessThan(
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

  QueryBuilder<Bron, Bron, QAfterFilterCondition> bronSoortBetween(
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

  QueryBuilder<Bron, Bron, QAfterFilterCondition> contentTypeEqualTo(
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

  QueryBuilder<Bron, Bron, QAfterFilterCondition> contentTypeGreaterThan(
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

  QueryBuilder<Bron, Bron, QAfterFilterCondition> contentTypeLessThan(
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

  QueryBuilder<Bron, Bron, QAfterFilterCondition> contentTypeBetween(
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

  QueryBuilder<Bron, Bron, QAfterFilterCondition> contentTypeStartsWith(
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

  QueryBuilder<Bron, Bron, QAfterFilterCondition> contentTypeEndsWith(
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

  QueryBuilder<Bron, Bron, QAfterFilterCondition> contentTypeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'contentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> contentTypeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'contentType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> contentTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contentType',
        value: '',
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> contentTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'contentType',
        value: '',
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> customNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customName',
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> customNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customName',
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> customNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> customNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> customNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> customNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> customNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> customNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> customNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> customNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> customNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customName',
        value: '',
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> customNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customName',
        value: '',
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> datumIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'datum',
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> datumIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'datum',
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> datumEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'datum',
        value: value,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> datumGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'datum',
        value: value,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> datumLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'datum',
        value: value,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> datumBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'datum',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> grootteEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'grootte',
        value: value,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> grootteGreaterThan(
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

  QueryBuilder<Bron, Bron, QAfterFilterCondition> grootteLessThan(
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

  QueryBuilder<Bron, Bron, QAfterFilterCondition> grootteBetween(
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

  QueryBuilder<Bron, Bron, QAfterFilterCondition> idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Bron, Bron, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Bron, Bron, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Bron, Bron, QAfterFilterCondition> isDownloadingEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDownloading',
        value: value,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> isFavoriteEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFavorite',
        value: value,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> lastUsedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastUsed',
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> lastUsedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastUsed',
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> lastUsedEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUsed',
        value: value,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> lastUsedGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUsed',
        value: value,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> lastUsedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUsed',
        value: value,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> lastUsedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUsed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> linksLengthEqualTo(
      int length) {
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

  QueryBuilder<Bron, Bron, QAfterFilterCondition> linksIsEmpty() {
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

  QueryBuilder<Bron, Bron, QAfterFilterCondition> linksIsNotEmpty() {
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

  QueryBuilder<Bron, Bron, QAfterFilterCondition> linksLengthLessThan(
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

  QueryBuilder<Bron, Bron, QAfterFilterCondition> linksLengthGreaterThan(
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

  QueryBuilder<Bron, Bron, QAfterFilterCondition> linksLengthBetween(
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

  QueryBuilder<Bron, Bron, QAfterFilterCondition> parentIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentId',
        value: value,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> parentIdGreaterThan(
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

  QueryBuilder<Bron, Bron, QAfterFilterCondition> parentIdLessThan(
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

  QueryBuilder<Bron, Bron, QAfterFilterCondition> parentIdBetween(
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

  QueryBuilder<Bron, Bron, QAfterFilterCondition> rawNaamEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawNaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> rawNaamGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawNaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> rawNaamLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawNaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> rawNaamBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawNaam',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> rawNaamStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rawNaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> rawNaamEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rawNaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> rawNaamContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rawNaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> rawNaamMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rawNaam',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> rawNaamIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawNaam',
        value: '',
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> rawNaamIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rawNaam',
        value: '',
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> rawSavedPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rawSavedPath',
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> rawSavedPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rawSavedPath',
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> rawSavedPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawSavedPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> rawSavedPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawSavedPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> rawSavedPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawSavedPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> rawSavedPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawSavedPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> rawSavedPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rawSavedPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> rawSavedPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rawSavedPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> rawSavedPathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rawSavedPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> rawSavedPathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rawSavedPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> rawSavedPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawSavedPath',
        value: '',
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> rawSavedPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rawSavedPath',
        value: '',
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> statusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'status',
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> statusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'status',
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> statusEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> statusGreaterThan(
    int? value, {
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

  QueryBuilder<Bron, Bron, QAfterFilterCondition> statusLessThan(
    int? value, {
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

  QueryBuilder<Bron, Bron, QAfterFilterCondition> statusBetween(
    int? lower,
    int? upper, {
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

  QueryBuilder<Bron, Bron, QAfterFilterCondition> uuidEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
      ));
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> uuidGreaterThan(
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

  QueryBuilder<Bron, Bron, QAfterFilterCondition> uuidLessThan(
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

  QueryBuilder<Bron, Bron, QAfterFilterCondition> uuidBetween(
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

extension BronQueryObject on QueryBuilder<Bron, Bron, QFilterCondition> {
  QueryBuilder<Bron, Bron, QAfterFilterCondition> linksElement(
      FilterQuery<BronLink> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'links');
    });
  }
}

extension BronQueryLinks on QueryBuilder<Bron, Bron, QFilterCondition> {
  QueryBuilder<Bron, Bron, QAfterFilterCondition> profile(
      FilterQuery<Profile> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'profile');
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> profileIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'profile', 0, true, 0, true);
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> source(
      FilterQuery<ExternalBronSource> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'source');
    });
  }

  QueryBuilder<Bron, Bron, QAfterFilterCondition> sourceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'source', 0, true, 0, true);
    });
  }
}

extension BronQuerySortBy on QueryBuilder<Bron, Bron, QSortBy> {
  QueryBuilder<Bron, Bron, QAfterSortBy> sortByBronSoort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bronSoort', Sort.asc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> sortByBronSoortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bronSoort', Sort.desc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> sortByContentType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentType', Sort.asc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> sortByContentTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentType', Sort.desc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> sortByCustomName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customName', Sort.asc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> sortByCustomNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customName', Sort.desc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> sortByDatum() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'datum', Sort.asc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> sortByDatumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'datum', Sort.desc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> sortByGrootte() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grootte', Sort.asc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> sortByGrootteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grootte', Sort.desc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> sortByIsDownloading() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDownloading', Sort.asc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> sortByIsDownloadingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDownloading', Sort.desc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> sortByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> sortByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> sortByLastUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsed', Sort.asc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> sortByLastUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsed', Sort.desc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> sortByParentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentId', Sort.asc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> sortByParentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentId', Sort.desc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> sortByRawNaam() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawNaam', Sort.asc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> sortByRawNaamDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawNaam', Sort.desc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> sortByRawSavedPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawSavedPath', Sort.asc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> sortByRawSavedPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawSavedPath', Sort.desc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension BronQuerySortThenBy on QueryBuilder<Bron, Bron, QSortThenBy> {
  QueryBuilder<Bron, Bron, QAfterSortBy> thenByBronSoort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bronSoort', Sort.asc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> thenByBronSoortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bronSoort', Sort.desc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> thenByContentType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentType', Sort.asc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> thenByContentTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentType', Sort.desc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> thenByCustomName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customName', Sort.asc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> thenByCustomNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customName', Sort.desc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> thenByDatum() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'datum', Sort.asc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> thenByDatumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'datum', Sort.desc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> thenByGrootte() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grootte', Sort.asc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> thenByGrootteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grootte', Sort.desc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> thenByIsDownloading() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDownloading', Sort.asc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> thenByIsDownloadingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDownloading', Sort.desc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> thenByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> thenByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> thenByLastUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsed', Sort.asc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> thenByLastUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsed', Sort.desc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> thenByParentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentId', Sort.asc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> thenByParentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentId', Sort.desc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> thenByRawNaam() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawNaam', Sort.asc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> thenByRawNaamDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawNaam', Sort.desc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> thenByRawSavedPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawSavedPath', Sort.asc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> thenByRawSavedPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawSavedPath', Sort.desc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<Bron, Bron, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension BronQueryWhereDistinct on QueryBuilder<Bron, Bron, QDistinct> {
  QueryBuilder<Bron, Bron, QDistinct> distinctByBronSoort() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bronSoort');
    });
  }

  QueryBuilder<Bron, Bron, QDistinct> distinctByContentType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contentType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bron, Bron, QDistinct> distinctByCustomName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bron, Bron, QDistinct> distinctByDatum() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'datum');
    });
  }

  QueryBuilder<Bron, Bron, QDistinct> distinctByGrootte() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'grootte');
    });
  }

  QueryBuilder<Bron, Bron, QDistinct> distinctById() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id');
    });
  }

  QueryBuilder<Bron, Bron, QDistinct> distinctByIsDownloading() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDownloading');
    });
  }

  QueryBuilder<Bron, Bron, QDistinct> distinctByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFavorite');
    });
  }

  QueryBuilder<Bron, Bron, QDistinct> distinctByLastUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUsed');
    });
  }

  QueryBuilder<Bron, Bron, QDistinct> distinctByParentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parentId');
    });
  }

  QueryBuilder<Bron, Bron, QDistinct> distinctByRawNaam(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rawNaam', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bron, Bron, QDistinct> distinctByRawSavedPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rawSavedPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bron, Bron, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }
}

extension BronQueryProperty on QueryBuilder<Bron, Bron, QQueryProperty> {
  QueryBuilder<Bron, int, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }

  QueryBuilder<Bron, int, QQueryOperations> bronSoortProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bronSoort');
    });
  }

  QueryBuilder<Bron, String, QQueryOperations> contentTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contentType');
    });
  }

  QueryBuilder<Bron, String?, QQueryOperations> customNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customName');
    });
  }

  QueryBuilder<Bron, DateTime?, QQueryOperations> datumProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'datum');
    });
  }

  QueryBuilder<Bron, int, QQueryOperations> grootteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'grootte');
    });
  }

  QueryBuilder<Bron, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Bron, bool, QQueryOperations> isDownloadingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDownloading');
    });
  }

  QueryBuilder<Bron, bool, QQueryOperations> isFavoriteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFavorite');
    });
  }

  QueryBuilder<Bron, DateTime?, QQueryOperations> lastUsedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUsed');
    });
  }

  QueryBuilder<Bron, List<BronLink>, QQueryOperations> linksProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'links');
    });
  }

  QueryBuilder<Bron, int, QQueryOperations> parentIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parentId');
    });
  }

  QueryBuilder<Bron, String, QQueryOperations> rawNaamProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rawNaam');
    });
  }

  QueryBuilder<Bron, String?, QQueryOperations> rawSavedPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rawSavedPath');
    });
  }

  QueryBuilder<Bron, int?, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const BronLinkSchema = Schema(
  name: r'BronLink',
  id: -2670441456341330705,
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
  estimateSize: _bronLinkEstimateSize,
  serialize: _bronLinkSerialize,
  deserialize: _bronLinkDeserialize,
  deserializeProp: _bronLinkDeserializeProp,
);

int _bronLinkEstimateSize(
  BronLink object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.href.length * 3;
  bytesCount += 3 + object.rel.length * 3;
  return bytesCount;
}

void _bronLinkSerialize(
  BronLink object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.href);
  writer.writeString(offsets[1], object.rel);
}

BronLink _bronLinkDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BronLink(
    href: reader.readStringOrNull(offsets[0]) ?? "",
    rel: reader.readStringOrNull(offsets[1]) ?? "",
  );
  return object;
}

P _bronLinkDeserializeProp<P>(
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

extension BronLinkQueryFilter
    on QueryBuilder<BronLink, BronLink, QFilterCondition> {
  QueryBuilder<BronLink, BronLink, QAfterFilterCondition> hrefEqualTo(
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

  QueryBuilder<BronLink, BronLink, QAfterFilterCondition> hrefGreaterThan(
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

  QueryBuilder<BronLink, BronLink, QAfterFilterCondition> hrefLessThan(
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

  QueryBuilder<BronLink, BronLink, QAfterFilterCondition> hrefBetween(
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

  QueryBuilder<BronLink, BronLink, QAfterFilterCondition> hrefStartsWith(
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

  QueryBuilder<BronLink, BronLink, QAfterFilterCondition> hrefEndsWith(
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

  QueryBuilder<BronLink, BronLink, QAfterFilterCondition> hrefContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'href',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BronLink, BronLink, QAfterFilterCondition> hrefMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'href',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BronLink, BronLink, QAfterFilterCondition> hrefIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'href',
        value: '',
      ));
    });
  }

  QueryBuilder<BronLink, BronLink, QAfterFilterCondition> hrefIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'href',
        value: '',
      ));
    });
  }

  QueryBuilder<BronLink, BronLink, QAfterFilterCondition> relEqualTo(
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

  QueryBuilder<BronLink, BronLink, QAfterFilterCondition> relGreaterThan(
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

  QueryBuilder<BronLink, BronLink, QAfterFilterCondition> relLessThan(
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

  QueryBuilder<BronLink, BronLink, QAfterFilterCondition> relBetween(
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

  QueryBuilder<BronLink, BronLink, QAfterFilterCondition> relStartsWith(
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

  QueryBuilder<BronLink, BronLink, QAfterFilterCondition> relEndsWith(
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

  QueryBuilder<BronLink, BronLink, QAfterFilterCondition> relContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BronLink, BronLink, QAfterFilterCondition> relMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BronLink, BronLink, QAfterFilterCondition> relIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rel',
        value: '',
      ));
    });
  }

  QueryBuilder<BronLink, BronLink, QAfterFilterCondition> relIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rel',
        value: '',
      ));
    });
  }
}

extension BronLinkQueryObject
    on QueryBuilder<BronLink, BronLink, QFilterCondition> {}
