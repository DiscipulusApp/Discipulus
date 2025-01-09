// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDiscipulusAccountCollection on Isar {
  IsarCollection<DiscipulusAccount> get discipulusAccounts => this.collection();
}

const DiscipulusAccountSchema = CollectionSchema(
  name: r'Account',
  id: -6646797162501847804,
  properties: {
    r'endPoint': PropertySchema(
      id: 0,
      name: r'endPoint',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 1,
      name: r'id',
      type: IsarType.long,
    ),
    r'permissions': PropertySchema(
      id: 2,
      name: r'permissions',
      type: IsarType.objectList,
      target: r'Permission',
    ),
    r'tokenSet': PropertySchema(
      id: 3,
      name: r'tokenSet',
      type: IsarType.object,
      target: r'TokenSet',
    )
  },
  estimateSize: _discipulusAccountEstimateSize,
  serialize: _discipulusAccountSerialize,
  deserialize: _discipulusAccountDeserialize,
  deserializeProp: _discipulusAccountDeserializeProp,
  idName: r'uuid',
  indexes: {},
  links: {
    r'profiles': LinkSchema(
      id: -502536054333988310,
      name: r'profiles',
      target: r'Profile',
      single: false,
    )
  },
  embeddedSchemas: {
    r'TokenSet': TokenSetSchema,
    r'Permission': PermissionSchema
  },
  getId: _discipulusAccountGetId,
  getLinks: _discipulusAccountGetLinks,
  attach: _discipulusAccountAttach,
  version: '3.1.0+1',
);

int _discipulusAccountEstimateSize(
  DiscipulusAccount object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.endPoint.length * 3;
  bytesCount += 3 + object.permissions.length * 3;
  {
    final offsets = allOffsets[Permission]!;
    for (var i = 0; i < object.permissions.length; i++) {
      final value = object.permissions[i];
      bytesCount += PermissionSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  {
    final value = object.tokenSet;
    if (value != null) {
      bytesCount += 3 +
          TokenSetSchema.estimateSize(value, allOffsets[TokenSet]!, allOffsets);
    }
  }
  return bytesCount;
}

void _discipulusAccountSerialize(
  DiscipulusAccount object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.endPoint);
  writer.writeLong(offsets[1], object.id);
  writer.writeObjectList<Permission>(
    offsets[2],
    allOffsets,
    PermissionSchema.serialize,
    object.permissions,
  );
  writer.writeObject<TokenSet>(
    offsets[3],
    allOffsets,
    TokenSetSchema.serialize,
    object.tokenSet,
  );
}

DiscipulusAccount _discipulusAccountDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DiscipulusAccount(
    endPoint: reader.readString(offsets[0]),
    id: reader.readLong(offsets[1]),
    permissions: reader.readObjectList<Permission>(
          offsets[2],
          PermissionSchema.deserialize,
          allOffsets,
          Permission(),
        ) ??
        const [],
    tokenSet: reader.readObjectOrNull<TokenSet>(
      offsets[3],
      TokenSetSchema.deserialize,
      allOffsets,
    ),
  );
  return object;
}

P _discipulusAccountDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readObjectList<Permission>(
            offset,
            PermissionSchema.deserialize,
            allOffsets,
            Permission(),
          ) ??
          const []) as P;
    case 3:
      return (reader.readObjectOrNull<TokenSet>(
        offset,
        TokenSetSchema.deserialize,
        allOffsets,
      )) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _discipulusAccountGetId(DiscipulusAccount object) {
  return object.uuid;
}

List<IsarLinkBase<dynamic>> _discipulusAccountGetLinks(
    DiscipulusAccount object) {
  return [object.profiles];
}

void _discipulusAccountAttach(
    IsarCollection<dynamic> col, Id id, DiscipulusAccount object) {
  object.profiles.attach(col, col.isar.collection<Profile>(), r'profiles', id);
}

extension DiscipulusAccountQueryWhereSort
    on QueryBuilder<DiscipulusAccount, DiscipulusAccount, QWhere> {
  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterWhere> anyUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DiscipulusAccountQueryWhere
    on QueryBuilder<DiscipulusAccount, DiscipulusAccount, QWhereClause> {
  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterWhereClause>
      uuidEqualTo(Id uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: uuid,
        upper: uuid,
      ));
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterWhereClause>
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

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterWhereClause>
      uuidGreaterThan(Id uuid, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: uuid, includeLower: include),
      );
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterWhereClause>
      uuidLessThan(Id uuid, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: uuid, includeUpper: include),
      );
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterWhereClause>
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

extension DiscipulusAccountQueryFilter
    on QueryBuilder<DiscipulusAccount, DiscipulusAccount, QFilterCondition> {
  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
      endPointEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endPoint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
      endPointGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endPoint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
      endPointLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endPoint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
      endPointBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endPoint',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
      endPointStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'endPoint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
      endPointEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'endPoint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
      endPointContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'endPoint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
      endPointMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'endPoint',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
      endPointIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endPoint',
        value: '',
      ));
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
      endPointIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'endPoint',
        value: '',
      ));
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
      idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
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

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
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

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
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

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
      permissionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'permissions',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
      permissionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'permissions',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
      permissionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'permissions',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
      permissionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'permissions',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
      permissionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'permissions',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
      permissionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'permissions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
      tokenSetIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tokenSet',
      ));
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
      tokenSetIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tokenSet',
      ));
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
      uuidEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
      ));
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
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

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
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

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
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
}

extension DiscipulusAccountQueryObject
    on QueryBuilder<DiscipulusAccount, DiscipulusAccount, QFilterCondition> {
  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
      permissionsElement(FilterQuery<Permission> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'permissions');
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
      tokenSet(FilterQuery<TokenSet> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'tokenSet');
    });
  }
}

extension DiscipulusAccountQueryLinks
    on QueryBuilder<DiscipulusAccount, DiscipulusAccount, QFilterCondition> {
  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
      profiles(FilterQuery<Profile> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'profiles');
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
      profilesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'profiles', length, true, length, true);
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
      profilesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'profiles', 0, true, 0, true);
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
      profilesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'profiles', 0, false, 999999, true);
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
      profilesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'profiles', 0, true, length, include);
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
      profilesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'profiles', length, include, 999999, true);
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterFilterCondition>
      profilesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'profiles', lower, includeLower, upper, includeUpper);
    });
  }
}

extension DiscipulusAccountQuerySortBy
    on QueryBuilder<DiscipulusAccount, DiscipulusAccount, QSortBy> {
  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterSortBy>
      sortByEndPoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endPoint', Sort.asc);
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterSortBy>
      sortByEndPointDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endPoint', Sort.desc);
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension DiscipulusAccountQuerySortThenBy
    on QueryBuilder<DiscipulusAccount, DiscipulusAccount, QSortThenBy> {
  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterSortBy>
      thenByEndPoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endPoint', Sort.asc);
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterSortBy>
      thenByEndPointDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endPoint', Sort.desc);
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterSortBy>
      thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QAfterSortBy>
      thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension DiscipulusAccountQueryWhereDistinct
    on QueryBuilder<DiscipulusAccount, DiscipulusAccount, QDistinct> {
  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QDistinct>
      distinctByEndPoint({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endPoint', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiscipulusAccount, DiscipulusAccount, QDistinct> distinctById() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id');
    });
  }
}

extension DiscipulusAccountQueryProperty
    on QueryBuilder<DiscipulusAccount, DiscipulusAccount, QQueryProperty> {
  QueryBuilder<DiscipulusAccount, int, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }

  QueryBuilder<DiscipulusAccount, String, QQueryOperations> endPointProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endPoint');
    });
  }

  QueryBuilder<DiscipulusAccount, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DiscipulusAccount, List<Permission>, QQueryOperations>
      permissionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'permissions');
    });
  }

  QueryBuilder<DiscipulusAccount, TokenSet?, QQueryOperations>
      tokenSetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tokenSet');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProfileCollection on Isar {
  IsarCollection<Profile> get profiles => this.collection();
}

const ProfileSchema = CollectionSchema(
  name: r'Profile',
  id: 1266279811925214857,
  properties: {
    r'customBase64ProfilePicture': PropertySchema(
      id: 0,
      name: r'customBase64ProfilePicture',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 1,
      name: r'id',
      type: IsarType.long,
    ),
    r'isOffline': PropertySchema(
      id: 2,
      name: r'isOffline',
      type: IsarType.bool,
    ),
    r'magisterBase64ProfilePicture': PropertySchema(
      id: 3,
      name: r'magisterBase64ProfilePicture',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 4,
      name: r'name',
      type: IsarType.string,
    ),
    r'settings': PropertySchema(
      id: 5,
      name: r'settings',
      type: IsarType.object,
      target: r'ProfileSettings',
    )
  },
  estimateSize: _profileEstimateSize,
  serialize: _profileSerialize,
  deserialize: _profileDeserialize,
  deserializeProp: _profileDeserializeProp,
  idName: r'uuid',
  indexes: {},
  links: {
    r'account': LinkSchema(
      id: -7960386214026814182,
      name: r'account',
      target: r'Account',
      single: true,
      linkName: r'profiles',
    ),
    r'schoolyears': LinkSchema(
      id: -8196411511192332591,
      name: r'schoolyears',
      target: r'Schoolyear',
      single: false,
    ),
    r'calendarEvents': LinkSchema(
      id: -2151958937316835770,
      name: r'calendarEvents',
      target: r'CalendarEvent',
      single: false,
      linkName: r'profile',
    ),
    r'assignments': LinkSchema(
      id: -812164665380889499,
      name: r'assignments',
      target: r'Assignment',
      single: false,
    ),
    r'activities': LinkSchema(
      id: -1804801498518375665,
      name: r'activities',
      target: r'Activity',
      single: false,
    ),
    r'studiewijzers': LinkSchema(
      id: -6285194348244164036,
      name: r'studiewijzers',
      target: r'Studiewijzer',
      single: false,
    ),
    r'externalBronnen': LinkSchema(
      id: 1868707677137969301,
      name: r'externalBronnen',
      target: r'ExternalBronSource',
      single: false,
    ),
    r'berichtMappen': LinkSchema(
      id: -357195621680141418,
      name: r'berichtMappen',
      target: r'BerichtFolder',
      single: false,
    )
  },
  embeddedSchemas: {
    r'ProfileSettings': ProfileSettingsSchema,
    r'Contact': ContactSchema
  },
  getId: _profileGetId,
  getLinks: _profileGetLinks,
  attach: _profileAttach,
  version: '3.1.0+1',
);

int _profileEstimateSize(
  Profile object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.customBase64ProfilePicture;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.magisterBase64ProfilePicture;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 +
      ProfileSettingsSchema.estimateSize(
          object.settings, allOffsets[ProfileSettings]!, allOffsets);
  return bytesCount;
}

void _profileSerialize(
  Profile object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.customBase64ProfilePicture);
  writer.writeLong(offsets[1], object.id);
  writer.writeBool(offsets[2], object.isOffline);
  writer.writeString(offsets[3], object.magisterBase64ProfilePicture);
  writer.writeString(offsets[4], object.name);
  writer.writeObject<ProfileSettings>(
    offsets[5],
    allOffsets,
    ProfileSettingsSchema.serialize,
    object.settings,
  );
}

Profile _profileDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Profile(
    id: reader.readLong(offsets[1]),
    isOffline: reader.readBoolOrNull(offsets[2]) ?? false,
    magisterBase64ProfilePicture: reader.readStringOrNull(offsets[3]),
    name: reader.readString(offsets[4]),
  );
  object.customBase64ProfilePicture = reader.readStringOrNull(offsets[0]);
  object.settings = reader.readObjectOrNull<ProfileSettings>(
        offsets[5],
        ProfileSettingsSchema.deserialize,
        allOffsets,
      ) ??
      ProfileSettings();
  return object;
}

P _profileDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readObjectOrNull<ProfileSettings>(
            offset,
            ProfileSettingsSchema.deserialize,
            allOffsets,
          ) ??
          ProfileSettings()) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _profileGetId(Profile object) {
  return object.uuid;
}

List<IsarLinkBase<dynamic>> _profileGetLinks(Profile object) {
  return [
    object.account,
    object.schoolyears,
    object.calendarEvents,
    object.assignments,
    object.activities,
    object.studiewijzers,
    object.externalBronnen,
    object.berichtMappen
  ];
}

void _profileAttach(IsarCollection<dynamic> col, Id id, Profile object) {
  object.account
      .attach(col, col.isar.collection<DiscipulusAccount>(), r'account', id);
  object.schoolyears
      .attach(col, col.isar.collection<Schoolyear>(), r'schoolyears', id);
  object.calendarEvents
      .attach(col, col.isar.collection<CalendarEvent>(), r'calendarEvents', id);
  object.assignments
      .attach(col, col.isar.collection<Assignment>(), r'assignments', id);
  object.activities
      .attach(col, col.isar.collection<Activity>(), r'activities', id);
  object.studiewijzers
      .attach(col, col.isar.collection<Studiewijzer>(), r'studiewijzers', id);
  object.externalBronnen.attach(
      col, col.isar.collection<ExternalBronSource>(), r'externalBronnen', id);
  object.berichtMappen
      .attach(col, col.isar.collection<MessagesFolder>(), r'berichtMappen', id);
}

extension ProfileQueryWhereSort on QueryBuilder<Profile, Profile, QWhere> {
  QueryBuilder<Profile, Profile, QAfterWhere> anyUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ProfileQueryWhere on QueryBuilder<Profile, Profile, QWhereClause> {
  QueryBuilder<Profile, Profile, QAfterWhereClause> uuidEqualTo(Id uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: uuid,
        upper: uuid,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterWhereClause> uuidNotEqualTo(Id uuid) {
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

  QueryBuilder<Profile, Profile, QAfterWhereClause> uuidGreaterThan(Id uuid,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: uuid, includeLower: include),
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterWhereClause> uuidLessThan(Id uuid,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: uuid, includeUpper: include),
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterWhereClause> uuidBetween(
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

extension ProfileQueryFilter
    on QueryBuilder<Profile, Profile, QFilterCondition> {
  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customBase64ProfilePictureIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customBase64ProfilePicture',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customBase64ProfilePictureIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customBase64ProfilePicture',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customBase64ProfilePictureEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customBase64ProfilePicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customBase64ProfilePictureGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customBase64ProfilePicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customBase64ProfilePictureLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customBase64ProfilePicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customBase64ProfilePictureBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customBase64ProfilePicture',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customBase64ProfilePictureStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customBase64ProfilePicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customBase64ProfilePictureEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customBase64ProfilePicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customBase64ProfilePictureContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customBase64ProfilePicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customBase64ProfilePictureMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customBase64ProfilePicture',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customBase64ProfilePictureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customBase64ProfilePicture',
        value: '',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customBase64ProfilePictureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customBase64ProfilePicture',
        value: '',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Profile, Profile, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Profile, Profile, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Profile, Profile, QAfterFilterCondition> isOfflineEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isOffline',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      magisterBase64ProfilePictureIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'magisterBase64ProfilePicture',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      magisterBase64ProfilePictureIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'magisterBase64ProfilePicture',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      magisterBase64ProfilePictureEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'magisterBase64ProfilePicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      magisterBase64ProfilePictureGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'magisterBase64ProfilePicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      magisterBase64ProfilePictureLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'magisterBase64ProfilePicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      magisterBase64ProfilePictureBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'magisterBase64ProfilePicture',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      magisterBase64ProfilePictureStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'magisterBase64ProfilePicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      magisterBase64ProfilePictureEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'magisterBase64ProfilePicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      magisterBase64ProfilePictureContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'magisterBase64ProfilePicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      magisterBase64ProfilePictureMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'magisterBase64ProfilePicture',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      magisterBase64ProfilePictureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'magisterBase64ProfilePicture',
        value: '',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      magisterBase64ProfilePictureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'magisterBase64ProfilePicture',
        value: '',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> uuidEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> uuidGreaterThan(
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

  QueryBuilder<Profile, Profile, QAfterFilterCondition> uuidLessThan(
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

  QueryBuilder<Profile, Profile, QAfterFilterCondition> uuidBetween(
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

extension ProfileQueryObject
    on QueryBuilder<Profile, Profile, QFilterCondition> {
  QueryBuilder<Profile, Profile, QAfterFilterCondition> settings(
      FilterQuery<ProfileSettings> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'settings');
    });
  }
}

extension ProfileQueryLinks
    on QueryBuilder<Profile, Profile, QFilterCondition> {
  QueryBuilder<Profile, Profile, QAfterFilterCondition> account(
      FilterQuery<DiscipulusAccount> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'account');
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> accountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'account', 0, true, 0, true);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> schoolyears(
      FilterQuery<Schoolyear> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'schoolyears');
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      schoolyearsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'schoolyears', length, true, length, true);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> schoolyearsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'schoolyears', 0, true, 0, true);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      schoolyearsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'schoolyears', 0, false, 999999, true);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      schoolyearsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'schoolyears', 0, true, length, include);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      schoolyearsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'schoolyears', length, include, 999999, true);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      schoolyearsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'schoolyears', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> calendarEvents(
      FilterQuery<CalendarEvent> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'calendarEvents');
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      calendarEventsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'calendarEvents', length, true, length, true);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      calendarEventsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'calendarEvents', 0, true, 0, true);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      calendarEventsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'calendarEvents', 0, false, 999999, true);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      calendarEventsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'calendarEvents', 0, true, length, include);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      calendarEventsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'calendarEvents', length, include, 999999, true);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      calendarEventsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'calendarEvents', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> assignments(
      FilterQuery<Assignment> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'assignments');
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      assignmentsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'assignments', length, true, length, true);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> assignmentsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'assignments', 0, true, 0, true);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      assignmentsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'assignments', 0, false, 999999, true);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      assignmentsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'assignments', 0, true, length, include);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      assignmentsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'assignments', length, include, 999999, true);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      assignmentsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'assignments', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> activities(
      FilterQuery<Activity> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'activities');
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> activitiesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'activities', length, true, length, true);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> activitiesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'activities', 0, true, 0, true);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> activitiesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'activities', 0, false, 999999, true);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      activitiesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'activities', 0, true, length, include);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      activitiesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'activities', length, include, 999999, true);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> activitiesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'activities', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> studiewijzers(
      FilterQuery<Studiewijzer> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'studiewijzers');
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      studiewijzersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'studiewijzers', length, true, length, true);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> studiewijzersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'studiewijzers', 0, true, 0, true);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      studiewijzersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'studiewijzers', 0, false, 999999, true);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      studiewijzersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'studiewijzers', 0, true, length, include);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      studiewijzersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'studiewijzers', length, include, 999999, true);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
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

  QueryBuilder<Profile, Profile, QAfterFilterCondition> externalBronnen(
      FilterQuery<ExternalBronSource> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'externalBronnen');
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      externalBronnenLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'externalBronnen', length, true, length, true);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      externalBronnenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'externalBronnen', 0, true, 0, true);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      externalBronnenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'externalBronnen', 0, false, 999999, true);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      externalBronnenLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'externalBronnen', 0, true, length, include);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      externalBronnenLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'externalBronnen', length, include, 999999, true);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      externalBronnenLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'externalBronnen', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> berichtMappen(
      FilterQuery<MessagesFolder> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'berichtMappen');
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      berichtMappenLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'berichtMappen', length, true, length, true);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> berichtMappenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'berichtMappen', 0, true, 0, true);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      berichtMappenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'berichtMappen', 0, false, 999999, true);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      berichtMappenLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'berichtMappen', 0, true, length, include);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      berichtMappenLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'berichtMappen', length, include, 999999, true);
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      berichtMappenLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'berichtMappen', lower, includeLower, upper, includeUpper);
    });
  }
}

extension ProfileQuerySortBy on QueryBuilder<Profile, Profile, QSortBy> {
  QueryBuilder<Profile, Profile, QAfterSortBy>
      sortByCustomBase64ProfilePicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customBase64ProfilePicture', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      sortByCustomBase64ProfilePictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customBase64ProfilePicture', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByIsOffline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOffline', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByIsOfflineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOffline', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      sortByMagisterBase64ProfilePicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'magisterBase64ProfilePicture', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      sortByMagisterBase64ProfilePictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'magisterBase64ProfilePicture', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension ProfileQuerySortThenBy
    on QueryBuilder<Profile, Profile, QSortThenBy> {
  QueryBuilder<Profile, Profile, QAfterSortBy>
      thenByCustomBase64ProfilePicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customBase64ProfilePicture', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      thenByCustomBase64ProfilePictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customBase64ProfilePicture', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByIsOffline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOffline', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByIsOfflineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOffline', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      thenByMagisterBase64ProfilePicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'magisterBase64ProfilePicture', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      thenByMagisterBase64ProfilePictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'magisterBase64ProfilePicture', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension ProfileQueryWhereDistinct
    on QueryBuilder<Profile, Profile, QDistinct> {
  QueryBuilder<Profile, Profile, QDistinct>
      distinctByCustomBase64ProfilePicture({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customBase64ProfilePicture',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Profile, Profile, QDistinct> distinctById() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id');
    });
  }

  QueryBuilder<Profile, Profile, QDistinct> distinctByIsOffline() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isOffline');
    });
  }

  QueryBuilder<Profile, Profile, QDistinct>
      distinctByMagisterBase64ProfilePicture({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'magisterBase64ProfilePicture',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Profile, Profile, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension ProfileQueryProperty
    on QueryBuilder<Profile, Profile, QQueryProperty> {
  QueryBuilder<Profile, int, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }

  QueryBuilder<Profile, String?, QQueryOperations>
      customBase64ProfilePictureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customBase64ProfilePicture');
    });
  }

  QueryBuilder<Profile, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Profile, bool, QQueryOperations> isOfflineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isOffline');
    });
  }

  QueryBuilder<Profile, String?, QQueryOperations>
      magisterBase64ProfilePictureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'magisterBase64ProfilePicture');
    });
  }

  QueryBuilder<Profile, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Profile, ProfileSettings, QQueryOperations> settingsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'settings');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const TokenSetSchema = Schema(
  name: r'TokenSet',
  id: -8798478665927999331,
  properties: {
    r'accessToken': PropertySchema(
      id: 0,
      name: r'accessToken',
      type: IsarType.string,
    ),
    r'expiredDate': PropertySchema(
      id: 1,
      name: r'expiredDate',
      type: IsarType.dateTime,
    ),
    r'idToken': PropertySchema(
      id: 2,
      name: r'idToken',
      type: IsarType.string,
    ),
    r'refreshToken': PropertySchema(
      id: 3,
      name: r'refreshToken',
      type: IsarType.string,
    )
  },
  estimateSize: _tokenSetEstimateSize,
  serialize: _tokenSetSerialize,
  deserialize: _tokenSetDeserialize,
  deserializeProp: _tokenSetDeserializeProp,
);

int _tokenSetEstimateSize(
  TokenSet object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.accessToken.length * 3;
  bytesCount += 3 + object.idToken.length * 3;
  {
    final value = object.refreshToken;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _tokenSetSerialize(
  TokenSet object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accessToken);
  writer.writeDateTime(offsets[1], object.expiredDate);
  writer.writeString(offsets[2], object.idToken);
  writer.writeString(offsets[3], object.refreshToken);
}

TokenSet _tokenSetDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TokenSet(
    accessToken: reader.readStringOrNull(offsets[0]) ?? "",
    expiredDate: reader.readDateTimeOrNull(offsets[1]),
    idToken: reader.readStringOrNull(offsets[2]) ?? "",
    refreshToken: reader.readStringOrNull(offsets[3]),
  );
  return object;
}

P _tokenSetDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension TokenSetQueryFilter
    on QueryBuilder<TokenSet, TokenSet, QFilterCondition> {
  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition> accessTokenEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accessToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition>
      accessTokenGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'accessToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition> accessTokenLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'accessToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition> accessTokenBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'accessToken',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition> accessTokenStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'accessToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition> accessTokenEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'accessToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition> accessTokenContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'accessToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition> accessTokenMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'accessToken',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition> accessTokenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accessToken',
        value: '',
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition>
      accessTokenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'accessToken',
        value: '',
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition> expiredDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'expiredDate',
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition>
      expiredDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'expiredDate',
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition> expiredDateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expiredDate',
        value: value,
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition>
      expiredDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expiredDate',
        value: value,
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition> expiredDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expiredDate',
        value: value,
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition> expiredDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expiredDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition> idTokenEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition> idTokenGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition> idTokenLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition> idTokenBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idToken',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition> idTokenStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition> idTokenEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition> idTokenContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition> idTokenMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idToken',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition> idTokenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idToken',
        value: '',
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition> idTokenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idToken',
        value: '',
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition> refreshTokenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'refreshToken',
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition>
      refreshTokenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'refreshToken',
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition> refreshTokenEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'refreshToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition>
      refreshTokenGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'refreshToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition> refreshTokenLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'refreshToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition> refreshTokenBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'refreshToken',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition>
      refreshTokenStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'refreshToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition> refreshTokenEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'refreshToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition> refreshTokenContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'refreshToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition> refreshTokenMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'refreshToken',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition>
      refreshTokenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'refreshToken',
        value: '',
      ));
    });
  }

  QueryBuilder<TokenSet, TokenSet, QAfterFilterCondition>
      refreshTokenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'refreshToken',
        value: '',
      ));
    });
  }
}

extension TokenSetQueryObject
    on QueryBuilder<TokenSet, TokenSet, QFilterCondition> {}
