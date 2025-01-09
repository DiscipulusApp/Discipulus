// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subjects.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSubjectCollection on Isar {
  IsarCollection<Subject> get subjects => this.collection();
}

const SubjectSchema = CollectionSchema(
  name: r'Subject',
  id: 7648000959054204885,
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
    r'naam': PropertySchema(
      id: 2,
      name: r'naam',
      type: IsarType.string,
    ),
    r'volgnr': PropertySchema(
      id: 3,
      name: r'volgnr',
      type: IsarType.long,
    )
  },
  estimateSize: _subjectEstimateSize,
  serialize: _subjectSerialize,
  deserialize: _subjectDeserialize,
  deserializeProp: _subjectDeserializeProp,
  idName: r'uuid',
  indexes: {},
  links: {
    r'schoolyear': LinkSchema(
      id: -5631792082346461599,
      name: r'schoolyear',
      target: r'Schoolyear',
      single: true,
      linkName: r'subjects',
    ),
    r'grades': LinkSchema(
      id: 7069119358575831234,
      name: r'grades',
      target: r'Grade',
      single: false,
      linkName: r'subject',
    ),
    r'periods': LinkSchema(
      id: 1049735764157297534,
      name: r'periods',
      target: r'GradePeriod',
      single: false,
      linkName: r'subjects',
    ),
    r'events': LinkSchema(
      id: -248807753626041125,
      name: r'events',
      target: r'CalendarEvent',
      single: false,
      linkName: r'subject',
    )
  },
  embeddedSchemas: {},
  getId: _subjectGetId,
  getLinks: _subjectGetLinks,
  attach: _subjectAttach,
  version: '3.1.0+1',
);

int _subjectEstimateSize(
  Subject object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.afkorting.length * 3;
  bytesCount += 3 + object.naam.length * 3;
  return bytesCount;
}

void _subjectSerialize(
  Subject object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.afkorting);
  writer.writeLong(offsets[1], object.id);
  writer.writeString(offsets[2], object.naam);
  writer.writeLong(offsets[3], object.volgnr);
}

Subject _subjectDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Subject(
    afkorting: reader.readStringOrNull(offsets[0]) ?? "",
    id: reader.readLongOrNull(offsets[1]) ?? 0,
    naam: reader.readStringOrNull(offsets[2]) ?? "",
    volgnr: reader.readLongOrNull(offsets[3]) ?? 0,
  );
  return object;
}

P _subjectDeserializeProp<P>(
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

Id _subjectGetId(Subject object) {
  return object.uuid;
}

List<IsarLinkBase<dynamic>> _subjectGetLinks(Subject object) {
  return [object.schoolyear, object.grades, object.periods, object.events];
}

void _subjectAttach(IsarCollection<dynamic> col, Id id, Subject object) {
  object.schoolyear
      .attach(col, col.isar.collection<Schoolyear>(), r'schoolyear', id);
  object.grades.attach(col, col.isar.collection<Grade>(), r'grades', id);
  object.periods
      .attach(col, col.isar.collection<GradePeriod>(), r'periods', id);
  object.events
      .attach(col, col.isar.collection<CalendarEvent>(), r'events', id);
}

extension SubjectQueryWhereSort on QueryBuilder<Subject, Subject, QWhere> {
  QueryBuilder<Subject, Subject, QAfterWhere> anyUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SubjectQueryWhere on QueryBuilder<Subject, Subject, QWhereClause> {
  QueryBuilder<Subject, Subject, QAfterWhereClause> uuidEqualTo(Id uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: uuid,
        upper: uuid,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterWhereClause> uuidNotEqualTo(Id uuid) {
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

  QueryBuilder<Subject, Subject, QAfterWhereClause> uuidGreaterThan(Id uuid,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: uuid, includeLower: include),
      );
    });
  }

  QueryBuilder<Subject, Subject, QAfterWhereClause> uuidLessThan(Id uuid,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: uuid, includeUpper: include),
      );
    });
  }

  QueryBuilder<Subject, Subject, QAfterWhereClause> uuidBetween(
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

extension SubjectQueryFilter
    on QueryBuilder<Subject, Subject, QFilterCondition> {
  QueryBuilder<Subject, Subject, QAfterFilterCondition> afkortingEqualTo(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> afkortingGreaterThan(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> afkortingLessThan(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> afkortingBetween(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> afkortingStartsWith(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> afkortingEndsWith(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> afkortingContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'afkorting',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> afkortingMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'afkorting',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> afkortingIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'afkorting',
        value: '',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> afkortingIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'afkorting',
        value: '',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> naamEqualTo(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> naamGreaterThan(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> naamLessThan(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> naamBetween(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> naamStartsWith(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> naamEndsWith(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> naamContains(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> naamMatches(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> naamIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'naam',
        value: '',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> naamIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'naam',
        value: '',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> uuidEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> uuidGreaterThan(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> uuidLessThan(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> uuidBetween(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> volgnrEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'volgnr',
        value: value,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> volgnrGreaterThan(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> volgnrLessThan(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> volgnrBetween(
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

extension SubjectQueryObject
    on QueryBuilder<Subject, Subject, QFilterCondition> {}

extension SubjectQueryLinks
    on QueryBuilder<Subject, Subject, QFilterCondition> {
  QueryBuilder<Subject, Subject, QAfterFilterCondition> schoolyear(
      FilterQuery<Schoolyear> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'schoolyear');
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> schoolyearIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'schoolyear', 0, true, 0, true);
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> grades(
      FilterQuery<Grade> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'grades');
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> gradesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'grades', length, true, length, true);
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> gradesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'grades', 0, true, 0, true);
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> gradesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'grades', 0, false, 999999, true);
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> gradesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'grades', 0, true, length, include);
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> gradesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'grades', length, include, 999999, true);
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> gradesLengthBetween(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> periods(
      FilterQuery<GradePeriod> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'periods');
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> periodsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'periods', length, true, length, true);
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> periodsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'periods', 0, true, 0, true);
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> periodsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'periods', 0, false, 999999, true);
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> periodsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'periods', 0, true, length, include);
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition>
      periodsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'periods', length, include, 999999, true);
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> periodsLengthBetween(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> events(
      FilterQuery<CalendarEvent> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'events');
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> eventsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'events', length, true, length, true);
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> eventsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'events', 0, true, 0, true);
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> eventsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'events', 0, false, 999999, true);
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> eventsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'events', 0, true, length, include);
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> eventsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'events', length, include, 999999, true);
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> eventsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'events', lower, includeLower, upper, includeUpper);
    });
  }
}

extension SubjectQuerySortBy on QueryBuilder<Subject, Subject, QSortBy> {
  QueryBuilder<Subject, Subject, QAfterSortBy> sortByAfkorting() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'afkorting', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByAfkortingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'afkorting', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByNaam() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'naam', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByNaamDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'naam', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByVolgnr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volgnr', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByVolgnrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volgnr', Sort.desc);
    });
  }
}

extension SubjectQuerySortThenBy
    on QueryBuilder<Subject, Subject, QSortThenBy> {
  QueryBuilder<Subject, Subject, QAfterSortBy> thenByAfkorting() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'afkorting', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByAfkortingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'afkorting', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByNaam() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'naam', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByNaamDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'naam', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByVolgnr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volgnr', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByVolgnrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volgnr', Sort.desc);
    });
  }
}

extension SubjectQueryWhereDistinct
    on QueryBuilder<Subject, Subject, QDistinct> {
  QueryBuilder<Subject, Subject, QDistinct> distinctByAfkorting(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'afkorting', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Subject, Subject, QDistinct> distinctById() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id');
    });
  }

  QueryBuilder<Subject, Subject, QDistinct> distinctByNaam(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'naam', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Subject, Subject, QDistinct> distinctByVolgnr() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'volgnr');
    });
  }
}

extension SubjectQueryProperty
    on QueryBuilder<Subject, Subject, QQueryProperty> {
  QueryBuilder<Subject, int, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }

  QueryBuilder<Subject, String, QQueryOperations> afkortingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'afkorting');
    });
  }

  QueryBuilder<Subject, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Subject, String, QQueryOperations> naamProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'naam');
    });
  }

  QueryBuilder<Subject, int, QQueryOperations> volgnrProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'volgnr');
    });
  }
}
