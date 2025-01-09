// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activities.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetActivityCollection on Isar {
  IsarCollection<Activity> get activitys => this.collection();
}

const ActivitySchema = CollectionSchema(
  name: r'Activity',
  id: -6099828696840999229,
  properties: {
    r'aantalInschrijvingen': PropertySchema(
      id: 0,
      name: r'aantalInschrijvingen',
      type: IsarType.long,
    ),
    r'canSignUp': PropertySchema(
      id: 1,
      name: r'canSignUp',
      type: IsarType.bool,
    ),
    r'details': PropertySchema(
      id: 2,
      name: r'details',
      type: IsarType.string,
    ),
    r'eindeInschrijfdatum': PropertySchema(
      id: 3,
      name: r'eindeInschrijfdatum',
      type: IsarType.dateTime,
    ),
    r'elementsLink': PropertySchema(
      id: 4,
      name: r'elementsLink',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 5,
      name: r'id',
      type: IsarType.long,
    ),
    r'maximumAantalInschrijvingenPerActiviteit': PropertySchema(
      id: 6,
      name: r'maximumAantalInschrijvingenPerActiviteit',
      type: IsarType.long,
    ),
    r'minimumAantalInschrijvingenPerActiviteit': PropertySchema(
      id: 7,
      name: r'minimumAantalInschrijvingenPerActiviteit',
      type: IsarType.long,
    ),
    r'startInschrijfdatum': PropertySchema(
      id: 8,
      name: r'startInschrijfdatum',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(
      id: 9,
      name: r'status',
      type: IsarType.long,
    ),
    r'titel': PropertySchema(
      id: 10,
      name: r'titel',
      type: IsarType.string,
    ),
    r'toegangstype': PropertySchema(
      id: 11,
      name: r'toegangstype',
      type: IsarType.long,
    ),
    r'zichtbaarTotEnMet': PropertySchema(
      id: 12,
      name: r'zichtbaarTotEnMet',
      type: IsarType.dateTime,
    ),
    r'zichtbaarVanaf': PropertySchema(
      id: 13,
      name: r'zichtbaarVanaf',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _activityEstimateSize,
  serialize: _activitySerialize,
  deserialize: _activityDeserialize,
  deserializeProp: _activityDeserializeProp,
  idName: r'uuid',
  indexes: {},
  links: {
    r'profile': LinkSchema(
      id: 4805668339318004593,
      name: r'profile',
      target: r'Profile',
      single: true,
      linkName: r'activities',
    ),
    r'elements': LinkSchema(
      id: 6376710330748214384,
      name: r'elements',
      target: r'ActivityElement',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _activityGetId,
  getLinks: _activityGetLinks,
  attach: _activityAttach,
  version: '3.1.0+1',
);

int _activityEstimateSize(
  Activity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.details;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.elementsLink.length * 3;
  bytesCount += 3 + object.titel.length * 3;
  return bytesCount;
}

void _activitySerialize(
  Activity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.aantalInschrijvingen);
  writer.writeBool(offsets[1], object.canSignUp);
  writer.writeString(offsets[2], object.details);
  writer.writeDateTime(offsets[3], object.eindeInschrijfdatum);
  writer.writeString(offsets[4], object.elementsLink);
  writer.writeLong(offsets[5], object.id);
  writer.writeLong(offsets[6], object.maximumAantalInschrijvingenPerActiviteit);
  writer.writeLong(offsets[7], object.minimumAantalInschrijvingenPerActiviteit);
  writer.writeDateTime(offsets[8], object.startInschrijfdatum);
  writer.writeLong(offsets[9], object.status);
  writer.writeString(offsets[10], object.titel);
  writer.writeLong(offsets[11], object.toegangstype);
  writer.writeDateTime(offsets[12], object.zichtbaarTotEnMet);
  writer.writeDateTime(offsets[13], object.zichtbaarVanaf);
}

Activity _activityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Activity(
    aantalInschrijvingen: reader.readLong(offsets[0]),
    details: reader.readStringOrNull(offsets[2]),
    eindeInschrijfdatum: reader.readDateTime(offsets[3]),
    elementsLink: reader.readString(offsets[4]),
    id: reader.readLong(offsets[5]),
    maximumAantalInschrijvingenPerActiviteit: reader.readLong(offsets[6]),
    minimumAantalInschrijvingenPerActiviteit: reader.readLong(offsets[7]),
    startInschrijfdatum: reader.readDateTime(offsets[8]),
    status: reader.readLong(offsets[9]),
    titel: reader.readString(offsets[10]),
    toegangstype: reader.readLong(offsets[11]),
    zichtbaarTotEnMet: reader.readDateTime(offsets[12]),
    zichtbaarVanaf: reader.readDateTime(offsets[13]),
  );
  return object;
}

P _activityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readDateTime(offset)) as P;
    case 13:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _activityGetId(Activity object) {
  return object.uuid;
}

List<IsarLinkBase<dynamic>> _activityGetLinks(Activity object) {
  return [object.profile, object.elements];
}

void _activityAttach(IsarCollection<dynamic> col, Id id, Activity object) {
  object.profile.attach(col, col.isar.collection<Profile>(), r'profile', id);
  object.elements
      .attach(col, col.isar.collection<ActivityElement>(), r'elements', id);
}

extension ActivityQueryWhereSort on QueryBuilder<Activity, Activity, QWhere> {
  QueryBuilder<Activity, Activity, QAfterWhere> anyUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ActivityQueryWhere on QueryBuilder<Activity, Activity, QWhereClause> {
  QueryBuilder<Activity, Activity, QAfterWhereClause> uuidEqualTo(Id uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: uuid,
        upper: uuid,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterWhereClause> uuidNotEqualTo(Id uuid) {
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

  QueryBuilder<Activity, Activity, QAfterWhereClause> uuidGreaterThan(Id uuid,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: uuid, includeLower: include),
      );
    });
  }

  QueryBuilder<Activity, Activity, QAfterWhereClause> uuidLessThan(Id uuid,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: uuid, includeUpper: include),
      );
    });
  }

  QueryBuilder<Activity, Activity, QAfterWhereClause> uuidBetween(
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

extension ActivityQueryFilter
    on QueryBuilder<Activity, Activity, QFilterCondition> {
  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      aantalInschrijvingenEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aantalInschrijvingen',
        value: value,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      aantalInschrijvingenGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'aantalInschrijvingen',
        value: value,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      aantalInschrijvingenLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'aantalInschrijvingen',
        value: value,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      aantalInschrijvingenBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'aantalInschrijvingen',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> canSignUpEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'canSignUp',
        value: value,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> detailsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'details',
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> detailsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'details',
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> detailsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'details',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> detailsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'details',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> detailsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'details',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> detailsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'details',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> detailsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'details',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> detailsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'details',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> detailsContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'details',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> detailsMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'details',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> detailsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'details',
        value: '',
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> detailsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'details',
        value: '',
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      eindeInschrijfdatumEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eindeInschrijfdatum',
        value: value,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      eindeInschrijfdatumGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eindeInschrijfdatum',
        value: value,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      eindeInschrijfdatumLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eindeInschrijfdatum',
        value: value,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      eindeInschrijfdatumBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eindeInschrijfdatum',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> elementsLinkEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'elementsLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      elementsLinkGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'elementsLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> elementsLinkLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'elementsLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> elementsLinkBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'elementsLink',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      elementsLinkStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'elementsLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> elementsLinkEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'elementsLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> elementsLinkContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'elementsLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> elementsLinkMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'elementsLink',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      elementsLinkIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'elementsLink',
        value: '',
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      elementsLinkIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'elementsLink',
        value: '',
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Activity, Activity, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Activity, Activity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      maximumAantalInschrijvingenPerActiviteitEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maximumAantalInschrijvingenPerActiviteit',
        value: value,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      maximumAantalInschrijvingenPerActiviteitGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maximumAantalInschrijvingenPerActiviteit',
        value: value,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      maximumAantalInschrijvingenPerActiviteitLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maximumAantalInschrijvingenPerActiviteit',
        value: value,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      maximumAantalInschrijvingenPerActiviteitBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maximumAantalInschrijvingenPerActiviteit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      minimumAantalInschrijvingenPerActiviteitEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'minimumAantalInschrijvingenPerActiviteit',
        value: value,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      minimumAantalInschrijvingenPerActiviteitGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'minimumAantalInschrijvingenPerActiviteit',
        value: value,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      minimumAantalInschrijvingenPerActiviteitLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'minimumAantalInschrijvingenPerActiviteit',
        value: value,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      minimumAantalInschrijvingenPerActiviteitBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'minimumAantalInschrijvingenPerActiviteit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      startInschrijfdatumEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startInschrijfdatum',
        value: value,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      startInschrijfdatumGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startInschrijfdatum',
        value: value,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      startInschrijfdatumLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startInschrijfdatum',
        value: value,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      startInschrijfdatumBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startInschrijfdatum',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> statusEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> statusGreaterThan(
    int value, {
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

  QueryBuilder<Activity, Activity, QAfterFilterCondition> statusLessThan(
    int value, {
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

  QueryBuilder<Activity, Activity, QAfterFilterCondition> statusBetween(
    int lower,
    int upper, {
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

  QueryBuilder<Activity, Activity, QAfterFilterCondition> titelEqualTo(
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

  QueryBuilder<Activity, Activity, QAfterFilterCondition> titelGreaterThan(
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

  QueryBuilder<Activity, Activity, QAfterFilterCondition> titelLessThan(
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

  QueryBuilder<Activity, Activity, QAfterFilterCondition> titelBetween(
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

  QueryBuilder<Activity, Activity, QAfterFilterCondition> titelStartsWith(
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

  QueryBuilder<Activity, Activity, QAfterFilterCondition> titelEndsWith(
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

  QueryBuilder<Activity, Activity, QAfterFilterCondition> titelContains(
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

  QueryBuilder<Activity, Activity, QAfterFilterCondition> titelMatches(
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

  QueryBuilder<Activity, Activity, QAfterFilterCondition> titelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titel',
        value: '',
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> titelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'titel',
        value: '',
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> toegangstypeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'toegangstype',
        value: value,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      toegangstypeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'toegangstype',
        value: value,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> toegangstypeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'toegangstype',
        value: value,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> toegangstypeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'toegangstype',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> uuidEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> uuidGreaterThan(
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

  QueryBuilder<Activity, Activity, QAfterFilterCondition> uuidLessThan(
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

  QueryBuilder<Activity, Activity, QAfterFilterCondition> uuidBetween(
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

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      zichtbaarTotEnMetEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'zichtbaarTotEnMet',
        value: value,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      zichtbaarTotEnMetGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'zichtbaarTotEnMet',
        value: value,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      zichtbaarTotEnMetLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'zichtbaarTotEnMet',
        value: value,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      zichtbaarTotEnMetBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'zichtbaarTotEnMet',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> zichtbaarVanafEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'zichtbaarVanaf',
        value: value,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      zichtbaarVanafGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'zichtbaarVanaf',
        value: value,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      zichtbaarVanafLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'zichtbaarVanaf',
        value: value,
      ));
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> zichtbaarVanafBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'zichtbaarVanaf',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ActivityQueryObject
    on QueryBuilder<Activity, Activity, QFilterCondition> {}

extension ActivityQueryLinks
    on QueryBuilder<Activity, Activity, QFilterCondition> {
  QueryBuilder<Activity, Activity, QAfterFilterCondition> profile(
      FilterQuery<Profile> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'profile');
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> profileIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'profile', 0, true, 0, true);
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> elements(
      FilterQuery<ActivityElement> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'elements');
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> elementsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'elements', length, true, length, true);
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> elementsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'elements', 0, true, 0, true);
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> elementsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'elements', 0, false, 999999, true);
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      elementsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'elements', 0, true, length, include);
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition>
      elementsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'elements', length, include, 999999, true);
    });
  }

  QueryBuilder<Activity, Activity, QAfterFilterCondition> elementsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'elements', lower, includeLower, upper, includeUpper);
    });
  }
}

extension ActivityQuerySortBy on QueryBuilder<Activity, Activity, QSortBy> {
  QueryBuilder<Activity, Activity, QAfterSortBy> sortByAantalInschrijvingen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aantalInschrijvingen', Sort.asc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy>
      sortByAantalInschrijvingenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aantalInschrijvingen', Sort.desc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> sortByCanSignUp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canSignUp', Sort.asc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> sortByCanSignUpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canSignUp', Sort.desc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> sortByDetails() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'details', Sort.asc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> sortByDetailsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'details', Sort.desc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> sortByEindeInschrijfdatum() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eindeInschrijfdatum', Sort.asc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy>
      sortByEindeInschrijfdatumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eindeInschrijfdatum', Sort.desc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> sortByElementsLink() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'elementsLink', Sort.asc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> sortByElementsLinkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'elementsLink', Sort.desc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy>
      sortByMaximumAantalInschrijvingenPerActiviteit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
          r'maximumAantalInschrijvingenPerActiviteit', Sort.asc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy>
      sortByMaximumAantalInschrijvingenPerActiviteitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
          r'maximumAantalInschrijvingenPerActiviteit', Sort.desc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy>
      sortByMinimumAantalInschrijvingenPerActiviteit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
          r'minimumAantalInschrijvingenPerActiviteit', Sort.asc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy>
      sortByMinimumAantalInschrijvingenPerActiviteitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
          r'minimumAantalInschrijvingenPerActiviteit', Sort.desc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> sortByStartInschrijfdatum() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startInschrijfdatum', Sort.asc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy>
      sortByStartInschrijfdatumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startInschrijfdatum', Sort.desc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> sortByTitel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titel', Sort.asc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> sortByTitelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titel', Sort.desc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> sortByToegangstype() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toegangstype', Sort.asc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> sortByToegangstypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toegangstype', Sort.desc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> sortByZichtbaarTotEnMet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zichtbaarTotEnMet', Sort.asc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> sortByZichtbaarTotEnMetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zichtbaarTotEnMet', Sort.desc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> sortByZichtbaarVanaf() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zichtbaarVanaf', Sort.asc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> sortByZichtbaarVanafDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zichtbaarVanaf', Sort.desc);
    });
  }
}

extension ActivityQuerySortThenBy
    on QueryBuilder<Activity, Activity, QSortThenBy> {
  QueryBuilder<Activity, Activity, QAfterSortBy> thenByAantalInschrijvingen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aantalInschrijvingen', Sort.asc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy>
      thenByAantalInschrijvingenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aantalInschrijvingen', Sort.desc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> thenByCanSignUp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canSignUp', Sort.asc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> thenByCanSignUpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canSignUp', Sort.desc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> thenByDetails() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'details', Sort.asc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> thenByDetailsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'details', Sort.desc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> thenByEindeInschrijfdatum() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eindeInschrijfdatum', Sort.asc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy>
      thenByEindeInschrijfdatumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eindeInschrijfdatum', Sort.desc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> thenByElementsLink() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'elementsLink', Sort.asc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> thenByElementsLinkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'elementsLink', Sort.desc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy>
      thenByMaximumAantalInschrijvingenPerActiviteit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
          r'maximumAantalInschrijvingenPerActiviteit', Sort.asc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy>
      thenByMaximumAantalInschrijvingenPerActiviteitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
          r'maximumAantalInschrijvingenPerActiviteit', Sort.desc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy>
      thenByMinimumAantalInschrijvingenPerActiviteit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
          r'minimumAantalInschrijvingenPerActiviteit', Sort.asc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy>
      thenByMinimumAantalInschrijvingenPerActiviteitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
          r'minimumAantalInschrijvingenPerActiviteit', Sort.desc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> thenByStartInschrijfdatum() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startInschrijfdatum', Sort.asc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy>
      thenByStartInschrijfdatumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startInschrijfdatum', Sort.desc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> thenByTitel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titel', Sort.asc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> thenByTitelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titel', Sort.desc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> thenByToegangstype() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toegangstype', Sort.asc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> thenByToegangstypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toegangstype', Sort.desc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> thenByZichtbaarTotEnMet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zichtbaarTotEnMet', Sort.asc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> thenByZichtbaarTotEnMetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zichtbaarTotEnMet', Sort.desc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> thenByZichtbaarVanaf() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zichtbaarVanaf', Sort.asc);
    });
  }

  QueryBuilder<Activity, Activity, QAfterSortBy> thenByZichtbaarVanafDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zichtbaarVanaf', Sort.desc);
    });
  }
}

extension ActivityQueryWhereDistinct
    on QueryBuilder<Activity, Activity, QDistinct> {
  QueryBuilder<Activity, Activity, QDistinct> distinctByAantalInschrijvingen() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'aantalInschrijvingen');
    });
  }

  QueryBuilder<Activity, Activity, QDistinct> distinctByCanSignUp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'canSignUp');
    });
  }

  QueryBuilder<Activity, Activity, QDistinct> distinctByDetails(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'details', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Activity, Activity, QDistinct> distinctByEindeInschrijfdatum() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eindeInschrijfdatum');
    });
  }

  QueryBuilder<Activity, Activity, QDistinct> distinctByElementsLink(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'elementsLink', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Activity, Activity, QDistinct> distinctById() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id');
    });
  }

  QueryBuilder<Activity, Activity, QDistinct>
      distinctByMaximumAantalInschrijvingenPerActiviteit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maximumAantalInschrijvingenPerActiviteit');
    });
  }

  QueryBuilder<Activity, Activity, QDistinct>
      distinctByMinimumAantalInschrijvingenPerActiviteit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'minimumAantalInschrijvingenPerActiviteit');
    });
  }

  QueryBuilder<Activity, Activity, QDistinct> distinctByStartInschrijfdatum() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startInschrijfdatum');
    });
  }

  QueryBuilder<Activity, Activity, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<Activity, Activity, QDistinct> distinctByTitel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'titel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Activity, Activity, QDistinct> distinctByToegangstype() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'toegangstype');
    });
  }

  QueryBuilder<Activity, Activity, QDistinct> distinctByZichtbaarTotEnMet() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'zichtbaarTotEnMet');
    });
  }

  QueryBuilder<Activity, Activity, QDistinct> distinctByZichtbaarVanaf() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'zichtbaarVanaf');
    });
  }
}

extension ActivityQueryProperty
    on QueryBuilder<Activity, Activity, QQueryProperty> {
  QueryBuilder<Activity, int, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }

  QueryBuilder<Activity, int, QQueryOperations> aantalInschrijvingenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'aantalInschrijvingen');
    });
  }

  QueryBuilder<Activity, bool, QQueryOperations> canSignUpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'canSignUp');
    });
  }

  QueryBuilder<Activity, String?, QQueryOperations> detailsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'details');
    });
  }

  QueryBuilder<Activity, DateTime, QQueryOperations>
      eindeInschrijfdatumProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eindeInschrijfdatum');
    });
  }

  QueryBuilder<Activity, String, QQueryOperations> elementsLinkProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'elementsLink');
    });
  }

  QueryBuilder<Activity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Activity, int, QQueryOperations>
      maximumAantalInschrijvingenPerActiviteitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maximumAantalInschrijvingenPerActiviteit');
    });
  }

  QueryBuilder<Activity, int, QQueryOperations>
      minimumAantalInschrijvingenPerActiviteitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'minimumAantalInschrijvingenPerActiviteit');
    });
  }

  QueryBuilder<Activity, DateTime, QQueryOperations>
      startInschrijfdatumProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startInschrijfdatum');
    });
  }

  QueryBuilder<Activity, int, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<Activity, String, QQueryOperations> titelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'titel');
    });
  }

  QueryBuilder<Activity, int, QQueryOperations> toegangstypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'toegangstype');
    });
  }

  QueryBuilder<Activity, DateTime, QQueryOperations>
      zichtbaarTotEnMetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'zichtbaarTotEnMet');
    });
  }

  QueryBuilder<Activity, DateTime, QQueryOperations> zichtbaarVanafProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'zichtbaarVanaf');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetActivityElementCollection on Isar {
  IsarCollection<ActivityElement> get activityElements => this.collection();
}

const ActivityElementSchema = CollectionSchema(
  name: r'ActivityElement',
  id: 6947257109433350710,
  properties: {
    r'aantalPlaatsenBeschikbaar': PropertySchema(
      id: 0,
      name: r'aantalPlaatsenBeschikbaar',
      type: IsarType.long,
    ),
    r'activiteitId': PropertySchema(
      id: 1,
      name: r'activiteitId',
      type: IsarType.long,
    ),
    r'canSignUp': PropertySchema(
      id: 2,
      name: r'canSignUp',
      type: IsarType.bool,
    ),
    r'details': PropertySchema(
      id: 3,
      name: r'details',
      type: IsarType.string,
    ),
    r'eindeInschrijfdatum': PropertySchema(
      id: 4,
      name: r'eindeInschrijfdatum',
      type: IsarType.dateTime,
    ),
    r'id': PropertySchema(
      id: 5,
      name: r'id',
      type: IsarType.long,
    ),
    r'isIngeschreven': PropertySchema(
      id: 6,
      name: r'isIngeschreven',
      type: IsarType.bool,
    ),
    r'isOpInTeSchrijven': PropertySchema(
      id: 7,
      name: r'isOpInTeSchrijven',
      type: IsarType.bool,
    ),
    r'isVerplichtIngeschreven': PropertySchema(
      id: 8,
      name: r'isVerplichtIngeschreven',
      type: IsarType.bool,
    ),
    r'kleurstelling': PropertySchema(
      id: 9,
      name: r'kleurstelling',
      type: IsarType.long,
    ),
    r'maxAantalDeelnemers': PropertySchema(
      id: 10,
      name: r'maxAantalDeelnemers',
      type: IsarType.long,
    ),
    r'minAantalDeelnemers': PropertySchema(
      id: 11,
      name: r'minAantalDeelnemers',
      type: IsarType.long,
    ),
    r'selfLink': PropertySchema(
      id: 12,
      name: r'selfLink',
      type: IsarType.string,
    ),
    r'startInschrijfdatum': PropertySchema(
      id: 13,
      name: r'startInschrijfdatum',
      type: IsarType.dateTime,
    ),
    r'subscriptionLink': PropertySchema(
      id: 14,
      name: r'subscriptionLink',
      type: IsarType.string,
    ),
    r'titel': PropertySchema(
      id: 15,
      name: r'titel',
      type: IsarType.string,
    ),
    r'volgnummer': PropertySchema(
      id: 16,
      name: r'volgnummer',
      type: IsarType.long,
    )
  },
  estimateSize: _activityElementEstimateSize,
  serialize: _activityElementSerialize,
  deserialize: _activityElementDeserialize,
  deserializeProp: _activityElementDeserializeProp,
  idName: r'uuid',
  indexes: {},
  links: {
    r'activity': LinkSchema(
      id: -2935873133687134745,
      name: r'activity',
      target: r'Activity',
      single: true,
      linkName: r'elements',
    ),
    r'bronnen': LinkSchema(
      id: -4269207179778633101,
      name: r'bronnen',
      target: r'Bron',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _activityElementGetId,
  getLinks: _activityElementGetLinks,
  attach: _activityElementAttach,
  version: '3.1.0+1',
);

int _activityElementEstimateSize(
  ActivityElement object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.details;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.selfLink.length * 3;
  bytesCount += 3 + object.subscriptionLink.length * 3;
  bytesCount += 3 + object.titel.length * 3;
  return bytesCount;
}

void _activityElementSerialize(
  ActivityElement object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.aantalPlaatsenBeschikbaar);
  writer.writeLong(offsets[1], object.activiteitId);
  writer.writeBool(offsets[2], object.canSignUp);
  writer.writeString(offsets[3], object.details);
  writer.writeDateTime(offsets[4], object.eindeInschrijfdatum);
  writer.writeLong(offsets[5], object.id);
  writer.writeBool(offsets[6], object.isIngeschreven);
  writer.writeBool(offsets[7], object.isOpInTeSchrijven);
  writer.writeBool(offsets[8], object.isVerplichtIngeschreven);
  writer.writeLong(offsets[9], object.kleurstelling);
  writer.writeLong(offsets[10], object.maxAantalDeelnemers);
  writer.writeLong(offsets[11], object.minAantalDeelnemers);
  writer.writeString(offsets[12], object.selfLink);
  writer.writeDateTime(offsets[13], object.startInschrijfdatum);
  writer.writeString(offsets[14], object.subscriptionLink);
  writer.writeString(offsets[15], object.titel);
  writer.writeLong(offsets[16], object.volgnummer);
}

ActivityElement _activityElementDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ActivityElement(
    aantalPlaatsenBeschikbaar: reader.readLong(offsets[0]),
    activiteitId: reader.readLong(offsets[1]),
    details: reader.readStringOrNull(offsets[3]),
    eindeInschrijfdatum: reader.readDateTime(offsets[4]),
    id: reader.readLong(offsets[5]),
    isIngeschreven: reader.readBool(offsets[6]),
    isOpInTeSchrijven: reader.readBool(offsets[7]),
    isVerplichtIngeschreven: reader.readBool(offsets[8]),
    kleurstelling: reader.readLong(offsets[9]),
    maxAantalDeelnemers: reader.readLong(offsets[10]),
    minAantalDeelnemers: reader.readLong(offsets[11]),
    selfLink: reader.readString(offsets[12]),
    startInschrijfdatum: reader.readDateTime(offsets[13]),
    subscriptionLink: reader.readString(offsets[14]),
    titel: reader.readString(offsets[15]),
    volgnummer: reader.readLong(offsets[16]),
  );
  return object;
}

P _activityElementDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readDateTime(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _activityElementGetId(ActivityElement object) {
  return object.uuid;
}

List<IsarLinkBase<dynamic>> _activityElementGetLinks(ActivityElement object) {
  return [object.activity, object.bronnen];
}

void _activityElementAttach(
    IsarCollection<dynamic> col, Id id, ActivityElement object) {
  object.activity.attach(col, col.isar.collection<Activity>(), r'activity', id);
  object.bronnen.attach(col, col.isar.collection<Bron>(), r'bronnen', id);
}

extension ActivityElementQueryWhereSort
    on QueryBuilder<ActivityElement, ActivityElement, QWhere> {
  QueryBuilder<ActivityElement, ActivityElement, QAfterWhere> anyUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ActivityElementQueryWhere
    on QueryBuilder<ActivityElement, ActivityElement, QWhereClause> {
  QueryBuilder<ActivityElement, ActivityElement, QAfterWhereClause> uuidEqualTo(
      Id uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: uuid,
        upper: uuid,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterWhereClause>
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

  QueryBuilder<ActivityElement, ActivityElement, QAfterWhereClause>
      uuidGreaterThan(Id uuid, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: uuid, includeLower: include),
      );
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterWhereClause>
      uuidLessThan(Id uuid, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: uuid, includeUpper: include),
      );
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterWhereClause> uuidBetween(
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

extension ActivityElementQueryFilter
    on QueryBuilder<ActivityElement, ActivityElement, QFilterCondition> {
  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      aantalPlaatsenBeschikbaarEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aantalPlaatsenBeschikbaar',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      aantalPlaatsenBeschikbaarGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'aantalPlaatsenBeschikbaar',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      aantalPlaatsenBeschikbaarLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'aantalPlaatsenBeschikbaar',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      aantalPlaatsenBeschikbaarBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'aantalPlaatsenBeschikbaar',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      activiteitIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activiteitId',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      activiteitIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activiteitId',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      activiteitIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activiteitId',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      activiteitIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activiteitId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      canSignUpEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'canSignUp',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      detailsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'details',
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      detailsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'details',
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      detailsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'details',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      detailsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'details',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      detailsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'details',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      detailsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'details',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      detailsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'details',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      detailsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'details',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      detailsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'details',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      detailsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'details',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      detailsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'details',
        value: '',
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      detailsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'details',
        value: '',
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      eindeInschrijfdatumEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eindeInschrijfdatum',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      eindeInschrijfdatumGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eindeInschrijfdatum',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      eindeInschrijfdatumLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eindeInschrijfdatum',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      eindeInschrijfdatumBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eindeInschrijfdatum',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
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

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
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

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
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

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      isIngeschrevenEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isIngeschreven',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      isOpInTeSchrijvenEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isOpInTeSchrijven',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      isVerplichtIngeschrevenEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isVerplichtIngeschreven',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      kleurstellingEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kleurstelling',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      kleurstellingGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'kleurstelling',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      kleurstellingLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'kleurstelling',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      kleurstellingBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'kleurstelling',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      maxAantalDeelnemersEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxAantalDeelnemers',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      maxAantalDeelnemersGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxAantalDeelnemers',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      maxAantalDeelnemersLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxAantalDeelnemers',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      maxAantalDeelnemersBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxAantalDeelnemers',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      minAantalDeelnemersEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'minAantalDeelnemers',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      minAantalDeelnemersGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'minAantalDeelnemers',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      minAantalDeelnemersLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'minAantalDeelnemers',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      minAantalDeelnemersBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'minAantalDeelnemers',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      selfLinkEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selfLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      selfLinkGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selfLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      selfLinkLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selfLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      selfLinkBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selfLink',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      selfLinkStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'selfLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      selfLinkEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'selfLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      selfLinkContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'selfLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      selfLinkMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'selfLink',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      selfLinkIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selfLink',
        value: '',
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      selfLinkIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'selfLink',
        value: '',
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      startInschrijfdatumEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startInschrijfdatum',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      startInschrijfdatumGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startInschrijfdatum',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      startInschrijfdatumLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startInschrijfdatum',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      startInschrijfdatumBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startInschrijfdatum',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      subscriptionLinkEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subscriptionLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      subscriptionLinkGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subscriptionLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      subscriptionLinkLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subscriptionLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      subscriptionLinkBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subscriptionLink',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      subscriptionLinkStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'subscriptionLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      subscriptionLinkEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'subscriptionLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      subscriptionLinkContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'subscriptionLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      subscriptionLinkMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'subscriptionLink',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      subscriptionLinkIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subscriptionLink',
        value: '',
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      subscriptionLinkIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'subscriptionLink',
        value: '',
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      titelEqualTo(
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

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      titelGreaterThan(
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

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      titelLessThan(
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

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      titelBetween(
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

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      titelStartsWith(
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

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      titelEndsWith(
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

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      titelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'titel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      titelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'titel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      titelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titel',
        value: '',
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      titelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'titel',
        value: '',
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      uuidEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
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

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
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

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
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

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      volgnummerEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'volgnummer',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      volgnummerGreaterThan(
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

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      volgnummerLessThan(
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

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      volgnummerBetween(
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

extension ActivityElementQueryObject
    on QueryBuilder<ActivityElement, ActivityElement, QFilterCondition> {}

extension ActivityElementQueryLinks
    on QueryBuilder<ActivityElement, ActivityElement, QFilterCondition> {
  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      activity(FilterQuery<Activity> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'activity');
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      activityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'activity', 0, true, 0, true);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition> bronnen(
      FilterQuery<Bron> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'bronnen');
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      bronnenLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', length, true, length, true);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      bronnenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', 0, true, 0, true);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      bronnenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', 0, false, 999999, true);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      bronnenLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', 0, true, length, include);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
      bronnenLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', length, include, 999999, true);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterFilterCondition>
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

extension ActivityElementQuerySortBy
    on QueryBuilder<ActivityElement, ActivityElement, QSortBy> {
  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortByAantalPlaatsenBeschikbaar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aantalPlaatsenBeschikbaar', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortByAantalPlaatsenBeschikbaarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aantalPlaatsenBeschikbaar', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortByActiviteitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activiteitId', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortByActiviteitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activiteitId', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortByCanSignUp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canSignUp', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortByCanSignUpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canSignUp', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy> sortByDetails() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'details', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortByDetailsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'details', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortByEindeInschrijfdatum() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eindeInschrijfdatum', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortByEindeInschrijfdatumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eindeInschrijfdatum', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortByIsIngeschreven() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isIngeschreven', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortByIsIngeschrevenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isIngeschreven', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortByIsOpInTeSchrijven() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOpInTeSchrijven', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortByIsOpInTeSchrijvenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOpInTeSchrijven', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortByIsVerplichtIngeschreven() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isVerplichtIngeschreven', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortByIsVerplichtIngeschrevenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isVerplichtIngeschreven', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortByKleurstelling() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kleurstelling', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortByKleurstellingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kleurstelling', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortByMaxAantalDeelnemers() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxAantalDeelnemers', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortByMaxAantalDeelnemersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxAantalDeelnemers', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortByMinAantalDeelnemers() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minAantalDeelnemers', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortByMinAantalDeelnemersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minAantalDeelnemers', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortBySelfLink() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selfLink', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortBySelfLinkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selfLink', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortByStartInschrijfdatum() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startInschrijfdatum', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortByStartInschrijfdatumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startInschrijfdatum', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortBySubscriptionLink() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionLink', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortBySubscriptionLinkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionLink', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy> sortByTitel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titel', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortByTitelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titel', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortByVolgnummer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volgnummer', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      sortByVolgnummerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volgnummer', Sort.desc);
    });
  }
}

extension ActivityElementQuerySortThenBy
    on QueryBuilder<ActivityElement, ActivityElement, QSortThenBy> {
  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenByAantalPlaatsenBeschikbaar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aantalPlaatsenBeschikbaar', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenByAantalPlaatsenBeschikbaarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aantalPlaatsenBeschikbaar', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenByActiviteitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activiteitId', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenByActiviteitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activiteitId', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenByCanSignUp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canSignUp', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenByCanSignUpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canSignUp', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy> thenByDetails() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'details', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenByDetailsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'details', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenByEindeInschrijfdatum() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eindeInschrijfdatum', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenByEindeInschrijfdatumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eindeInschrijfdatum', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenByIsIngeschreven() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isIngeschreven', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenByIsIngeschrevenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isIngeschreven', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenByIsOpInTeSchrijven() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOpInTeSchrijven', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenByIsOpInTeSchrijvenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOpInTeSchrijven', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenByIsVerplichtIngeschreven() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isVerplichtIngeschreven', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenByIsVerplichtIngeschrevenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isVerplichtIngeschreven', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenByKleurstelling() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kleurstelling', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenByKleurstellingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kleurstelling', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenByMaxAantalDeelnemers() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxAantalDeelnemers', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenByMaxAantalDeelnemersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxAantalDeelnemers', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenByMinAantalDeelnemers() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minAantalDeelnemers', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenByMinAantalDeelnemersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minAantalDeelnemers', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenBySelfLink() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selfLink', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenBySelfLinkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selfLink', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenByStartInschrijfdatum() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startInschrijfdatum', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenByStartInschrijfdatumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startInschrijfdatum', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenBySubscriptionLink() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionLink', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenBySubscriptionLinkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionLink', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy> thenByTitel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titel', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenByTitelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titel', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenByVolgnummer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volgnummer', Sort.asc);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QAfterSortBy>
      thenByVolgnummerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volgnummer', Sort.desc);
    });
  }
}

extension ActivityElementQueryWhereDistinct
    on QueryBuilder<ActivityElement, ActivityElement, QDistinct> {
  QueryBuilder<ActivityElement, ActivityElement, QDistinct>
      distinctByAantalPlaatsenBeschikbaar() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'aantalPlaatsenBeschikbaar');
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QDistinct>
      distinctByActiviteitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activiteitId');
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QDistinct>
      distinctByCanSignUp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'canSignUp');
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QDistinct> distinctByDetails(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'details', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QDistinct>
      distinctByEindeInschrijfdatum() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eindeInschrijfdatum');
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QDistinct> distinctById() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id');
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QDistinct>
      distinctByIsIngeschreven() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isIngeschreven');
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QDistinct>
      distinctByIsOpInTeSchrijven() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isOpInTeSchrijven');
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QDistinct>
      distinctByIsVerplichtIngeschreven() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isVerplichtIngeschreven');
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QDistinct>
      distinctByKleurstelling() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kleurstelling');
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QDistinct>
      distinctByMaxAantalDeelnemers() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxAantalDeelnemers');
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QDistinct>
      distinctByMinAantalDeelnemers() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'minAantalDeelnemers');
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QDistinct> distinctBySelfLink(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selfLink', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QDistinct>
      distinctByStartInschrijfdatum() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startInschrijfdatum');
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QDistinct>
      distinctBySubscriptionLink({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subscriptionLink',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QDistinct> distinctByTitel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'titel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ActivityElement, ActivityElement, QDistinct>
      distinctByVolgnummer() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'volgnummer');
    });
  }
}

extension ActivityElementQueryProperty
    on QueryBuilder<ActivityElement, ActivityElement, QQueryProperty> {
  QueryBuilder<ActivityElement, int, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }

  QueryBuilder<ActivityElement, int, QQueryOperations>
      aantalPlaatsenBeschikbaarProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'aantalPlaatsenBeschikbaar');
    });
  }

  QueryBuilder<ActivityElement, int, QQueryOperations> activiteitIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activiteitId');
    });
  }

  QueryBuilder<ActivityElement, bool, QQueryOperations> canSignUpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'canSignUp');
    });
  }

  QueryBuilder<ActivityElement, String?, QQueryOperations> detailsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'details');
    });
  }

  QueryBuilder<ActivityElement, DateTime, QQueryOperations>
      eindeInschrijfdatumProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eindeInschrijfdatum');
    });
  }

  QueryBuilder<ActivityElement, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ActivityElement, bool, QQueryOperations>
      isIngeschrevenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isIngeschreven');
    });
  }

  QueryBuilder<ActivityElement, bool, QQueryOperations>
      isOpInTeSchrijvenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isOpInTeSchrijven');
    });
  }

  QueryBuilder<ActivityElement, bool, QQueryOperations>
      isVerplichtIngeschrevenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isVerplichtIngeschreven');
    });
  }

  QueryBuilder<ActivityElement, int, QQueryOperations> kleurstellingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kleurstelling');
    });
  }

  QueryBuilder<ActivityElement, int, QQueryOperations>
      maxAantalDeelnemersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxAantalDeelnemers');
    });
  }

  QueryBuilder<ActivityElement, int, QQueryOperations>
      minAantalDeelnemersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'minAantalDeelnemers');
    });
  }

  QueryBuilder<ActivityElement, String, QQueryOperations> selfLinkProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selfLink');
    });
  }

  QueryBuilder<ActivityElement, DateTime, QQueryOperations>
      startInschrijfdatumProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startInschrijfdatum');
    });
  }

  QueryBuilder<ActivityElement, String, QQueryOperations>
      subscriptionLinkProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subscriptionLink');
    });
  }

  QueryBuilder<ActivityElement, String, QQueryOperations> titelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'titel');
    });
  }

  QueryBuilder<ActivityElement, int, QQueryOperations> volgnummerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'volgnummer');
    });
  }
}
