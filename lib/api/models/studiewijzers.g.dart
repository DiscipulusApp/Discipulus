// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'studiewijzers.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStudiewijzerCollection on Isar {
  IsarCollection<Studiewijzer> get studiewijzers => this.collection();
}

const StudiewijzerSchema = CollectionSchema(
  name: r'Studiewijzer',
  id: -5331171569411330920,
  properties: {
    r'customEmojiIcon': PropertySchema(
      id: 0,
      name: r'customEmojiIcon',
      type: IsarType.string,
    ),
    r'customName': PropertySchema(
      id: 1,
      name: r'customName',
      type: IsarType.string,
    ),
    r'groupName': PropertySchema(
      id: 2,
      name: r'groupName',
      type: IsarType.string,
    ),
    r'groupedUUIDS': PropertySchema(
      id: 3,
      name: r'groupedUUIDS',
      type: IsarType.longList,
    ),
    r'id': PropertySchema(
      id: 4,
      name: r'id',
      type: IsarType.long,
    ),
    r'inLeerlingArchief': PropertySchema(
      id: 5,
      name: r'inLeerlingArchief',
      type: IsarType.bool,
    ),
    r'isFavorite': PropertySchema(
      id: 6,
      name: r'isFavorite',
      type: IsarType.bool,
    ),
    r'isZichtbaar': PropertySchema(
      id: 7,
      name: r'isZichtbaar',
      type: IsarType.bool,
    ),
    r'lastUsed': PropertySchema(
      id: 8,
      name: r'lastUsed',
      type: IsarType.dateTime,
    ),
    r'rawTitel': PropertySchema(
      id: 9,
      name: r'rawTitel',
      type: IsarType.string,
    ),
    r'selfUrl': PropertySchema(
      id: 10,
      name: r'selfUrl',
      type: IsarType.string,
    ),
    r'totEnMet': PropertySchema(
      id: 11,
      name: r'totEnMet',
      type: IsarType.dateTime,
    ),
    r'van': PropertySchema(
      id: 12,
      name: r'van',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _studiewijzerEstimateSize,
  serialize: _studiewijzerSerialize,
  deserialize: _studiewijzerDeserialize,
  deserializeProp: _studiewijzerDeserializeProp,
  idName: r'uuid',
  indexes: {},
  links: {
    r'profile': LinkSchema(
      id: 7603317394209178769,
      name: r'profile',
      target: r'Profile',
      single: true,
      linkName: r'studiewijzers',
    ),
    r'onderdelen': LinkSchema(
      id: -2645641574481612550,
      name: r'onderdelen',
      target: r'StudiewijzerOnderdeel',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _studiewijzerGetId,
  getLinks: _studiewijzerGetLinks,
  attach: _studiewijzerAttach,
  version: '3.1.0+1',
);

int _studiewijzerEstimateSize(
  Studiewijzer object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.customEmojiIcon;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.customName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.groupName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.groupedUUIDS.length * 8;
  bytesCount += 3 + object.rawTitel.length * 3;
  {
    final value = object.selfUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _studiewijzerSerialize(
  Studiewijzer object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.customEmojiIcon);
  writer.writeString(offsets[1], object.customName);
  writer.writeString(offsets[2], object.groupName);
  writer.writeLongList(offsets[3], object.groupedUUIDS);
  writer.writeLong(offsets[4], object.id);
  writer.writeBool(offsets[5], object.inLeerlingArchief);
  writer.writeBool(offsets[6], object.isFavorite);
  writer.writeBool(offsets[7], object.isZichtbaar);
  writer.writeDateTime(offsets[8], object.lastUsed);
  writer.writeString(offsets[9], object.rawTitel);
  writer.writeString(offsets[10], object.selfUrl);
  writer.writeDateTime(offsets[11], object.totEnMet);
  writer.writeDateTime(offsets[12], object.van);
}

Studiewijzer _studiewijzerDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Studiewijzer(
    customEmojiIcon: reader.readStringOrNull(offsets[0]),
    id: reader.readLong(offsets[4]),
    inLeerlingArchief: reader.readBool(offsets[5]),
    isZichtbaar: reader.readBoolOrNull(offsets[7]),
    lastUsed: reader.readDateTimeOrNull(offsets[8]),
    rawTitel: reader.readString(offsets[9]),
    selfUrl: reader.readStringOrNull(offsets[10]),
    totEnMet: reader.readDateTime(offsets[11]),
    van: reader.readDateTime(offsets[12]),
  );
  object.customName = reader.readStringOrNull(offsets[1]);
  object.groupName = reader.readStringOrNull(offsets[2]);
  object.groupedUUIDS = reader.readLongList(offsets[3]) ?? [];
  object.isFavorite = reader.readBool(offsets[6]);
  return object;
}

P _studiewijzerDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLongList(offset) ?? []) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBoolOrNull(offset)) as P;
    case 8:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    case 12:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _studiewijzerGetId(Studiewijzer object) {
  return object.uuid;
}

List<IsarLinkBase<dynamic>> _studiewijzerGetLinks(Studiewijzer object) {
  return [object.profile, object.onderdelen];
}

void _studiewijzerAttach(
    IsarCollection<dynamic> col, Id id, Studiewijzer object) {
  object.profile.attach(col, col.isar.collection<Profile>(), r'profile', id);
  object.onderdelen.attach(
      col, col.isar.collection<StudiewijzerOnderdeel>(), r'onderdelen', id);
}

extension StudiewijzerQueryWhereSort
    on QueryBuilder<Studiewijzer, Studiewijzer, QWhere> {
  QueryBuilder<Studiewijzer, Studiewijzer, QAfterWhere> anyUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StudiewijzerQueryWhere
    on QueryBuilder<Studiewijzer, Studiewijzer, QWhereClause> {
  QueryBuilder<Studiewijzer, Studiewijzer, QAfterWhereClause> uuidEqualTo(
      Id uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: uuid,
        upper: uuid,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterWhereClause> uuidNotEqualTo(
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

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterWhereClause> uuidGreaterThan(
      Id uuid,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: uuid, includeLower: include),
      );
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterWhereClause> uuidLessThan(
      Id uuid,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: uuid, includeUpper: include),
      );
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterWhereClause> uuidBetween(
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

extension StudiewijzerQueryFilter
    on QueryBuilder<Studiewijzer, Studiewijzer, QFilterCondition> {
  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      customEmojiIconIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customEmojiIcon',
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      customEmojiIconIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customEmojiIcon',
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      customEmojiIconEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customEmojiIcon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      customEmojiIconGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customEmojiIcon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      customEmojiIconLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customEmojiIcon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      customEmojiIconBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customEmojiIcon',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      customEmojiIconStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customEmojiIcon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      customEmojiIconEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customEmojiIcon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      customEmojiIconContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customEmojiIcon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      customEmojiIconMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customEmojiIcon',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      customEmojiIconIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customEmojiIcon',
        value: '',
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      customEmojiIconIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customEmojiIcon',
        value: '',
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      customNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customName',
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      customNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customName',
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      customNameEqualTo(
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

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      customNameGreaterThan(
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

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      customNameLessThan(
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

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      customNameBetween(
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

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      customNameStartsWith(
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

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      customNameEndsWith(
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

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      customNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      customNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      customNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customName',
        value: '',
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      customNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customName',
        value: '',
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      groupNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'groupName',
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      groupNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'groupName',
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      groupNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      groupNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'groupName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      groupNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'groupName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      groupNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'groupName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      groupNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'groupName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      groupNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'groupName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      groupNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'groupName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      groupNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'groupName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      groupNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupName',
        value: '',
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      groupNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'groupName',
        value: '',
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      groupedUUIDSElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupedUUIDS',
        value: value,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      groupedUUIDSElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'groupedUUIDS',
        value: value,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      groupedUUIDSElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'groupedUUIDS',
        value: value,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      groupedUUIDSElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'groupedUUIDS',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      groupedUUIDSLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'groupedUUIDS',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      groupedUUIDSIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'groupedUUIDS',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      groupedUUIDSIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'groupedUUIDS',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      groupedUUIDSLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'groupedUUIDS',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      groupedUUIDSLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'groupedUUIDS',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      groupedUUIDSLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'groupedUUIDS',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition> idEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      inLeerlingArchiefEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'inLeerlingArchief',
        value: value,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      isFavoriteEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFavorite',
        value: value,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      isZichtbaarIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isZichtbaar',
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      isZichtbaarIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isZichtbaar',
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      isZichtbaarEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isZichtbaar',
        value: value,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      lastUsedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastUsed',
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      lastUsedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastUsed',
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      lastUsedEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUsed',
        value: value,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      lastUsedGreaterThan(
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

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      lastUsedLessThan(
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

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      lastUsedBetween(
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

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      rawTitelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawTitel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      rawTitelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawTitel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      rawTitelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawTitel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      rawTitelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawTitel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      rawTitelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rawTitel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      rawTitelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rawTitel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      rawTitelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rawTitel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      rawTitelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rawTitel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      rawTitelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawTitel',
        value: '',
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      rawTitelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rawTitel',
        value: '',
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      selfUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'selfUrl',
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      selfUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'selfUrl',
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
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

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
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

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
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

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
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

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
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

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
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

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      selfUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'selfUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      selfUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'selfUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      selfUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selfUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      selfUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'selfUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      totEnMetEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totEnMet',
        value: value,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      totEnMetGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totEnMet',
        value: value,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      totEnMetLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totEnMet',
        value: value,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      totEnMetBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totEnMet',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition> uuidEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
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

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition> uuidLessThan(
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

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition> uuidBetween(
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

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition> vanEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'van',
        value: value,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      vanGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'van',
        value: value,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition> vanLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'van',
        value: value,
      ));
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition> vanBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'van',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StudiewijzerQueryObject
    on QueryBuilder<Studiewijzer, Studiewijzer, QFilterCondition> {}

extension StudiewijzerQueryLinks
    on QueryBuilder<Studiewijzer, Studiewijzer, QFilterCondition> {
  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition> profile(
      FilterQuery<Profile> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'profile');
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      profileIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'profile', 0, true, 0, true);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition> onderdelen(
      FilterQuery<StudiewijzerOnderdeel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'onderdelen');
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      onderdelenLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'onderdelen', length, true, length, true);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      onderdelenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'onderdelen', 0, true, 0, true);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      onderdelenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'onderdelen', 0, false, 999999, true);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      onderdelenLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'onderdelen', 0, true, length, include);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      onderdelenLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'onderdelen', length, include, 999999, true);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterFilterCondition>
      onderdelenLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'onderdelen', lower, includeLower, upper, includeUpper);
    });
  }
}

extension StudiewijzerQuerySortBy
    on QueryBuilder<Studiewijzer, Studiewijzer, QSortBy> {
  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy>
      sortByCustomEmojiIcon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customEmojiIcon', Sort.asc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy>
      sortByCustomEmojiIconDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customEmojiIcon', Sort.desc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> sortByCustomName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customName', Sort.asc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy>
      sortByCustomNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customName', Sort.desc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> sortByGroupName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupName', Sort.asc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> sortByGroupNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupName', Sort.desc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy>
      sortByInLeerlingArchief() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inLeerlingArchief', Sort.asc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy>
      sortByInLeerlingArchiefDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inLeerlingArchief', Sort.desc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> sortByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy>
      sortByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> sortByIsZichtbaar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isZichtbaar', Sort.asc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy>
      sortByIsZichtbaarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isZichtbaar', Sort.desc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> sortByLastUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsed', Sort.asc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> sortByLastUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsed', Sort.desc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> sortByRawTitel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawTitel', Sort.asc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> sortByRawTitelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawTitel', Sort.desc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> sortBySelfUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selfUrl', Sort.asc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> sortBySelfUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selfUrl', Sort.desc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> sortByTotEnMet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totEnMet', Sort.asc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> sortByTotEnMetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totEnMet', Sort.desc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> sortByVan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'van', Sort.asc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> sortByVanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'van', Sort.desc);
    });
  }
}

extension StudiewijzerQuerySortThenBy
    on QueryBuilder<Studiewijzer, Studiewijzer, QSortThenBy> {
  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy>
      thenByCustomEmojiIcon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customEmojiIcon', Sort.asc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy>
      thenByCustomEmojiIconDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customEmojiIcon', Sort.desc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> thenByCustomName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customName', Sort.asc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy>
      thenByCustomNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customName', Sort.desc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> thenByGroupName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupName', Sort.asc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> thenByGroupNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupName', Sort.desc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy>
      thenByInLeerlingArchief() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inLeerlingArchief', Sort.asc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy>
      thenByInLeerlingArchiefDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inLeerlingArchief', Sort.desc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> thenByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy>
      thenByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> thenByIsZichtbaar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isZichtbaar', Sort.asc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy>
      thenByIsZichtbaarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isZichtbaar', Sort.desc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> thenByLastUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsed', Sort.asc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> thenByLastUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsed', Sort.desc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> thenByRawTitel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawTitel', Sort.asc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> thenByRawTitelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawTitel', Sort.desc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> thenBySelfUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selfUrl', Sort.asc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> thenBySelfUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selfUrl', Sort.desc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> thenByTotEnMet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totEnMet', Sort.asc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> thenByTotEnMetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totEnMet', Sort.desc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> thenByVan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'van', Sort.asc);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QAfterSortBy> thenByVanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'van', Sort.desc);
    });
  }
}

extension StudiewijzerQueryWhereDistinct
    on QueryBuilder<Studiewijzer, Studiewijzer, QDistinct> {
  QueryBuilder<Studiewijzer, Studiewijzer, QDistinct> distinctByCustomEmojiIcon(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customEmojiIcon',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QDistinct> distinctByCustomName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QDistinct> distinctByGroupName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QDistinct> distinctByGroupedUUIDS() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupedUUIDS');
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QDistinct> distinctById() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id');
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QDistinct>
      distinctByInLeerlingArchief() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'inLeerlingArchief');
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QDistinct> distinctByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFavorite');
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QDistinct> distinctByIsZichtbaar() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isZichtbaar');
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QDistinct> distinctByLastUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUsed');
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QDistinct> distinctByRawTitel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rawTitel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QDistinct> distinctBySelfUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selfUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QDistinct> distinctByTotEnMet() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totEnMet');
    });
  }

  QueryBuilder<Studiewijzer, Studiewijzer, QDistinct> distinctByVan() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'van');
    });
  }
}

extension StudiewijzerQueryProperty
    on QueryBuilder<Studiewijzer, Studiewijzer, QQueryProperty> {
  QueryBuilder<Studiewijzer, int, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }

  QueryBuilder<Studiewijzer, String?, QQueryOperations>
      customEmojiIconProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customEmojiIcon');
    });
  }

  QueryBuilder<Studiewijzer, String?, QQueryOperations> customNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customName');
    });
  }

  QueryBuilder<Studiewijzer, String?, QQueryOperations> groupNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupName');
    });
  }

  QueryBuilder<Studiewijzer, List<int>, QQueryOperations>
      groupedUUIDSProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupedUUIDS');
    });
  }

  QueryBuilder<Studiewijzer, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Studiewijzer, bool, QQueryOperations>
      inLeerlingArchiefProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'inLeerlingArchief');
    });
  }

  QueryBuilder<Studiewijzer, bool, QQueryOperations> isFavoriteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFavorite');
    });
  }

  QueryBuilder<Studiewijzer, bool?, QQueryOperations> isZichtbaarProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isZichtbaar');
    });
  }

  QueryBuilder<Studiewijzer, DateTime?, QQueryOperations> lastUsedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUsed');
    });
  }

  QueryBuilder<Studiewijzer, String, QQueryOperations> rawTitelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rawTitel');
    });
  }

  QueryBuilder<Studiewijzer, String?, QQueryOperations> selfUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selfUrl');
    });
  }

  QueryBuilder<Studiewijzer, DateTime, QQueryOperations> totEnMetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totEnMet');
    });
  }

  QueryBuilder<Studiewijzer, DateTime, QQueryOperations> vanProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'van');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStudiewijzerOnderdeelCollection on Isar {
  IsarCollection<StudiewijzerOnderdeel> get studiewijzerOnderdeels =>
      this.collection();
}

const StudiewijzerOnderdeelSchema = CollectionSchema(
  name: r'StudiewijzerOnderdeel',
  id: -5317857074036543243,
  properties: {
    r'id': PropertySchema(
      id: 0,
      name: r'id',
      type: IsarType.long,
    ),
    r'isZichtbaar': PropertySchema(
      id: 1,
      name: r'isZichtbaar',
      type: IsarType.bool,
    ),
    r'kleur': PropertySchema(
      id: 2,
      name: r'kleur',
      type: IsarType.long,
    ),
    r'links': PropertySchema(
      id: 3,
      name: r'links',
      type: IsarType.objectList,
      target: r'BronLink',
    ),
    r'omschrijving': PropertySchema(
      id: 4,
      name: r'omschrijving',
      type: IsarType.string,
    ),
    r'omschrijvingShort': PropertySchema(
      id: 5,
      name: r'omschrijvingShort',
      type: IsarType.string,
    ),
    r'selfUrl': PropertySchema(
      id: 6,
      name: r'selfUrl',
      type: IsarType.string,
    ),
    r'titel': PropertySchema(
      id: 7,
      name: r'titel',
      type: IsarType.string,
    ),
    r'totEnMet': PropertySchema(
      id: 8,
      name: r'totEnMet',
      type: IsarType.dateTime,
    ),
    r'van': PropertySchema(
      id: 9,
      name: r'van',
      type: IsarType.dateTime,
    ),
    r'volgnummer': PropertySchema(
      id: 10,
      name: r'volgnummer',
      type: IsarType.long,
    )
  },
  estimateSize: _studiewijzerOnderdeelEstimateSize,
  serialize: _studiewijzerOnderdeelSerialize,
  deserialize: _studiewijzerOnderdeelDeserialize,
  deserializeProp: _studiewijzerOnderdeelDeserializeProp,
  idName: r'uuid',
  indexes: {},
  links: {
    r'bronnen': LinkSchema(
      id: -480303031269501197,
      name: r'bronnen',
      target: r'Bron',
      single: false,
    ),
    r'studiewijzer': LinkSchema(
      id: -3046325180649138344,
      name: r'studiewijzer',
      target: r'Studiewijzer',
      single: true,
      linkName: r'onderdelen',
    )
  },
  embeddedSchemas: {r'BronLink': BronLinkSchema},
  getId: _studiewijzerOnderdeelGetId,
  getLinks: _studiewijzerOnderdeelGetLinks,
  attach: _studiewijzerOnderdeelAttach,
  version: '3.1.0+1',
);

int _studiewijzerOnderdeelEstimateSize(
  StudiewijzerOnderdeel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.links;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[BronLink]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += BronLinkSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final value = object.omschrijving;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.omschrijvingShort.length * 3;
  bytesCount += 3 + object.selfUrl.length * 3;
  bytesCount += 3 + object.titel.length * 3;
  return bytesCount;
}

void _studiewijzerOnderdeelSerialize(
  StudiewijzerOnderdeel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.id);
  writer.writeBool(offsets[1], object.isZichtbaar);
  writer.writeLong(offsets[2], object.kleur);
  writer.writeObjectList<BronLink>(
    offsets[3],
    allOffsets,
    BronLinkSchema.serialize,
    object.links,
  );
  writer.writeString(offsets[4], object.omschrijving);
  writer.writeString(offsets[5], object.omschrijvingShort);
  writer.writeString(offsets[6], object.selfUrl);
  writer.writeString(offsets[7], object.titel);
  writer.writeDateTime(offsets[8], object.totEnMet);
  writer.writeDateTime(offsets[9], object.van);
  writer.writeLong(offsets[10], object.volgnummer);
}

StudiewijzerOnderdeel _studiewijzerOnderdeelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StudiewijzerOnderdeel(
    id: reader.readLongOrNull(offsets[0]) ?? 0,
    isZichtbaar: reader.readBoolOrNull(offsets[1]) ?? false,
    kleur: reader.readLongOrNull(offsets[2]) ?? 0,
    links: reader.readObjectList<BronLink>(
      offsets[3],
      BronLinkSchema.deserialize,
      allOffsets,
      BronLink(),
    ),
    omschrijvingShort: reader.readStringOrNull(offsets[5]) ?? "",
    selfUrl: reader.readStringOrNull(offsets[6]) ?? "",
    titel: reader.readStringOrNull(offsets[7]) ?? "",
    totEnMet: reader.readDateTimeOrNull(offsets[8]),
    van: reader.readDateTimeOrNull(offsets[9]),
    volgnummer: reader.readLongOrNull(offsets[10]) ?? 0,
  );
  object.omschrijving = reader.readStringOrNull(offsets[4]);
  return object;
}

P _studiewijzerOnderdeelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 2:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 3:
      return (reader.readObjectList<BronLink>(
        offset,
        BronLinkSchema.deserialize,
        allOffsets,
        BronLink(),
      )) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 6:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 7:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 8:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 9:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _studiewijzerOnderdeelGetId(StudiewijzerOnderdeel object) {
  return object.uuid;
}

List<IsarLinkBase<dynamic>> _studiewijzerOnderdeelGetLinks(
    StudiewijzerOnderdeel object) {
  return [object.bronnen, object.studiewijzer];
}

void _studiewijzerOnderdeelAttach(
    IsarCollection<dynamic> col, Id id, StudiewijzerOnderdeel object) {
  object.bronnen.attach(col, col.isar.collection<Bron>(), r'bronnen', id);
  object.studiewijzer
      .attach(col, col.isar.collection<Studiewijzer>(), r'studiewijzer', id);
}

extension StudiewijzerOnderdeelQueryWhereSort
    on QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QWhere> {
  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterWhere>
      anyUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StudiewijzerOnderdeelQueryWhere on QueryBuilder<StudiewijzerOnderdeel,
    StudiewijzerOnderdeel, QWhereClause> {
  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterWhereClause>
      uuidEqualTo(Id uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: uuid,
        upper: uuid,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterWhereClause>
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterWhereClause>
      uuidGreaterThan(Id uuid, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: uuid, includeLower: include),
      );
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterWhereClause>
      uuidLessThan(Id uuid, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: uuid, includeUpper: include),
      );
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterWhereClause>
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

extension StudiewijzerOnderdeelQueryFilter on QueryBuilder<
    StudiewijzerOnderdeel, StudiewijzerOnderdeel, QFilterCondition> {
  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> isZichtbaarEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isZichtbaar',
        value: value,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> kleurEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kleur',
        value: value,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> kleurGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'kleur',
        value: value,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> kleurLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'kleur',
        value: value,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> kleurBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'kleur',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> linksIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'links',
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> linksIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'links',
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> linksLengthEqualTo(int length) {
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> linksIsEmpty() {
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> linksIsNotEmpty() {
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> linksLengthLessThan(
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> linksLengthGreaterThan(
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> linksLengthBetween(
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> omschrijvingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'omschrijving',
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> omschrijvingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'omschrijving',
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> omschrijvingEqualTo(
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> omschrijvingGreaterThan(
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> omschrijvingLessThan(
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> omschrijvingBetween(
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> omschrijvingStartsWith(
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> omschrijvingEndsWith(
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
          QAfterFilterCondition>
      omschrijvingContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'omschrijving',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
          QAfterFilterCondition>
      omschrijvingMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'omschrijving',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> omschrijvingIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'omschrijving',
        value: '',
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> omschrijvingIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'omschrijving',
        value: '',
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> omschrijvingShortEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'omschrijvingShort',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> omschrijvingShortGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'omschrijvingShort',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> omschrijvingShortLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'omschrijvingShort',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> omschrijvingShortBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'omschrijvingShort',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> omschrijvingShortStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'omschrijvingShort',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> omschrijvingShortEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'omschrijvingShort',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
          QAfterFilterCondition>
      omschrijvingShortContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'omschrijvingShort',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
          QAfterFilterCondition>
      omschrijvingShortMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'omschrijvingShort',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> omschrijvingShortIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'omschrijvingShort',
        value: '',
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> omschrijvingShortIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'omschrijvingShort',
        value: '',
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> selfUrlEqualTo(
    String value, {
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> selfUrlGreaterThan(
    String value, {
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> selfUrlLessThan(
    String value, {
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> selfUrlBetween(
    String lower,
    String upper, {
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> selfUrlStartsWith(
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> selfUrlEndsWith(
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
          QAfterFilterCondition>
      selfUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'selfUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
          QAfterFilterCondition>
      selfUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'selfUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> selfUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selfUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> selfUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'selfUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> titelEqualTo(
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> titelGreaterThan(
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> titelLessThan(
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> titelBetween(
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> titelStartsWith(
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> titelEndsWith(
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
          QAfterFilterCondition>
      titelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'titel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
          QAfterFilterCondition>
      titelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'titel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> titelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titel',
        value: '',
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> titelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'titel',
        value: '',
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> totEnMetIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'totEnMet',
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> totEnMetIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'totEnMet',
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> totEnMetEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totEnMet',
        value: value,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> totEnMetGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totEnMet',
        value: value,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> totEnMetLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totEnMet',
        value: value,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> totEnMetBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totEnMet',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> uuidEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> uuidGreaterThan(
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> uuidLessThan(
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> uuidBetween(
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> vanIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'van',
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> vanIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'van',
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> vanEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'van',
        value: value,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> vanGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'van',
        value: value,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> vanLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'van',
        value: value,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> vanBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'van',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> volgnummerEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'volgnummer',
        value: value,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> volgnummerGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'volgnummer',
        value: value,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> volgnummerLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'volgnummer',
        value: value,
      ));
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> volgnummerBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'volgnummer',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StudiewijzerOnderdeelQueryObject on QueryBuilder<
    StudiewijzerOnderdeel, StudiewijzerOnderdeel, QFilterCondition> {
  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> linksElement(FilterQuery<BronLink> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'links');
    });
  }
}

extension StudiewijzerOnderdeelQueryLinks on QueryBuilder<StudiewijzerOnderdeel,
    StudiewijzerOnderdeel, QFilterCondition> {
  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> bronnen(FilterQuery<Bron> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'bronnen');
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> bronnenLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', length, true, length, true);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> bronnenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', 0, true, 0, true);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> bronnenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', 0, false, 999999, true);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> bronnenLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', 0, true, length, include);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> bronnenLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', length, include, 999999, true);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> bronnenLengthBetween(
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

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> studiewijzer(FilterQuery<Studiewijzer> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'studiewijzer');
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel,
      QAfterFilterCondition> studiewijzerIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'studiewijzer', 0, true, 0, true);
    });
  }
}

extension StudiewijzerOnderdeelQuerySortBy
    on QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QSortBy> {
  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      sortByIsZichtbaar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isZichtbaar', Sort.asc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      sortByIsZichtbaarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isZichtbaar', Sort.desc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      sortByKleur() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kleur', Sort.asc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      sortByKleurDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kleur', Sort.desc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      sortByOmschrijving() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'omschrijving', Sort.asc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      sortByOmschrijvingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'omschrijving', Sort.desc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      sortByOmschrijvingShort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'omschrijvingShort', Sort.asc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      sortByOmschrijvingShortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'omschrijvingShort', Sort.desc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      sortBySelfUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selfUrl', Sort.asc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      sortBySelfUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selfUrl', Sort.desc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      sortByTitel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titel', Sort.asc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      sortByTitelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titel', Sort.desc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      sortByTotEnMet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totEnMet', Sort.asc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      sortByTotEnMetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totEnMet', Sort.desc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      sortByVan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'van', Sort.asc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      sortByVanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'van', Sort.desc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      sortByVolgnummer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volgnummer', Sort.asc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      sortByVolgnummerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volgnummer', Sort.desc);
    });
  }
}

extension StudiewijzerOnderdeelQuerySortThenBy
    on QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QSortThenBy> {
  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      thenByIsZichtbaar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isZichtbaar', Sort.asc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      thenByIsZichtbaarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isZichtbaar', Sort.desc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      thenByKleur() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kleur', Sort.asc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      thenByKleurDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kleur', Sort.desc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      thenByOmschrijving() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'omschrijving', Sort.asc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      thenByOmschrijvingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'omschrijving', Sort.desc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      thenByOmschrijvingShort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'omschrijvingShort', Sort.asc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      thenByOmschrijvingShortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'omschrijvingShort', Sort.desc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      thenBySelfUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selfUrl', Sort.asc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      thenBySelfUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selfUrl', Sort.desc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      thenByTitel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titel', Sort.asc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      thenByTitelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titel', Sort.desc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      thenByTotEnMet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totEnMet', Sort.asc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      thenByTotEnMetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totEnMet', Sort.desc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      thenByVan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'van', Sort.asc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      thenByVanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'van', Sort.desc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      thenByVolgnummer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volgnummer', Sort.asc);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QAfterSortBy>
      thenByVolgnummerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volgnummer', Sort.desc);
    });
  }
}

extension StudiewijzerOnderdeelQueryWhereDistinct
    on QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QDistinct> {
  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QDistinct>
      distinctById() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id');
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QDistinct>
      distinctByIsZichtbaar() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isZichtbaar');
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QDistinct>
      distinctByKleur() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kleur');
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QDistinct>
      distinctByOmschrijving({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'omschrijving', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QDistinct>
      distinctByOmschrijvingShort({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'omschrijvingShort',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QDistinct>
      distinctBySelfUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selfUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QDistinct>
      distinctByTitel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'titel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QDistinct>
      distinctByTotEnMet() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totEnMet');
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QDistinct>
      distinctByVan() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'van');
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, StudiewijzerOnderdeel, QDistinct>
      distinctByVolgnummer() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'volgnummer');
    });
  }
}

extension StudiewijzerOnderdeelQueryProperty on QueryBuilder<
    StudiewijzerOnderdeel, StudiewijzerOnderdeel, QQueryProperty> {
  QueryBuilder<StudiewijzerOnderdeel, int, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, bool, QQueryOperations>
      isZichtbaarProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isZichtbaar');
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, int, QQueryOperations> kleurProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kleur');
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, List<BronLink>?, QQueryOperations>
      linksProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'links');
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, String?, QQueryOperations>
      omschrijvingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'omschrijving');
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, String, QQueryOperations>
      omschrijvingShortProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'omschrijvingShort');
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, String, QQueryOperations>
      selfUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selfUrl');
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, String, QQueryOperations>
      titelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'titel');
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, DateTime?, QQueryOperations>
      totEnMetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totEnMet');
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, DateTime?, QQueryOperations>
      vanProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'van');
    });
  }

  QueryBuilder<StudiewijzerOnderdeel, int, QQueryOperations>
      volgnummerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'volgnummer');
    });
  }
}
