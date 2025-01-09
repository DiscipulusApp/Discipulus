// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBerichtCollection on Isar {
  IsarCollection<Bericht> get berichts => this.collection();
}

const BerichtSchema = CollectionSchema(
  name: r'Bericht',
  id: 8034143366333516240,
  properties: {
    r'afzender': PropertySchema(
      id: 0,
      name: r'afzender',
      type: IsarType.object,
      target: r'Afzender',
    ),
    r'aiSummary': PropertySchema(
      id: 1,
      name: r'aiSummary',
      type: IsarType.string,
    ),
    r'beantwoordOp': PropertySchema(
      id: 2,
      name: r'beantwoordOp',
      type: IsarType.dateTime,
    ),
    r'blindeKopieOntvangers': PropertySchema(
      id: 3,
      name: r'blindeKopieOntvangers',
      type: IsarType.objectList,
      target: r'Ontvanger',
    ),
    r'doorgestuurdOp': PropertySchema(
      id: 4,
      name: r'doorgestuurdOp',
      type: IsarType.dateTime,
    ),
    r'heeftBijlagen': PropertySchema(
      id: 5,
      name: r'heeftBijlagen',
      type: IsarType.bool,
    ),
    r'heeftPrioriteit': PropertySchema(
      id: 6,
      name: r'heeftPrioriteit',
      type: IsarType.bool,
    ),
    r'id': PropertySchema(
      id: 7,
      name: r'id',
      type: IsarType.long,
    ),
    r'inhoud': PropertySchema(
      id: 8,
      name: r'inhoud',
      type: IsarType.string,
    ),
    r'isGelezen': PropertySchema(
      id: 9,
      name: r'isGelezen',
      type: IsarType.bool,
    ),
    r'kopieOntvangers': PropertySchema(
      id: 10,
      name: r'kopieOntvangers',
      type: IsarType.objectList,
      target: r'Ontvanger',
    ),
    r'links': PropertySchema(
      id: 11,
      name: r'links',
      type: IsarType.object,
      target: r'ItemLinks',
    ),
    r'mapId': PropertySchema(
      id: 12,
      name: r'mapId',
      type: IsarType.long,
    ),
    r'onderwerp': PropertySchema(
      id: 13,
      name: r'onderwerp',
      type: IsarType.string,
    ),
    r'ontvangers': PropertySchema(
      id: 14,
      name: r'ontvangers',
      type: IsarType.objectList,
      target: r'Ontvanger',
    ),
    r'rawOnderwerp': PropertySchema(
      id: 15,
      name: r'rawOnderwerp',
      type: IsarType.string,
    ),
    r'verzondenOp': PropertySchema(
      id: 16,
      name: r'verzondenOp',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _berichtEstimateSize,
  serialize: _berichtSerialize,
  deserialize: _berichtDeserialize,
  deserializeProp: _berichtDeserializeProp,
  idName: r'uuid',
  indexes: {},
  links: {
    r'map': LinkSchema(
      id: 4781575100472920183,
      name: r'map',
      target: r'BerichtFolder',
      single: true,
      linkName: r'berichten',
    ),
    r'bronnen': LinkSchema(
      id: -6583518779178913771,
      name: r'bronnen',
      target: r'Bron',
      single: false,
    )
  },
  embeddedSchemas: {
    r'Afzender': AfzenderSchema,
    r'ItemLinks': ItemLinksSchema,
    r'Ontvanger': OntvangerSchema
  },
  getId: _berichtGetId,
  getLinks: _berichtGetLinks,
  attach: _berichtAttach,
  version: '3.1.0+1',
);

int _berichtEstimateSize(
  Bericht object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.afzender;
    if (value != null) {
      bytesCount += 3 +
          AfzenderSchema.estimateSize(value, allOffsets[Afzender]!, allOffsets);
    }
  }
  {
    final value = object.aiSummary;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.blindeKopieOntvangers;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[Ontvanger]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              OntvangerSchema.estimateSize(value, offsets, allOffsets);
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
    final list = object.kopieOntvangers;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[Ontvanger]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              OntvangerSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  bytesCount += 3 +
      ItemLinksSchema.estimateSize(
          object.links, allOffsets[ItemLinks]!, allOffsets);
  {
    final value = object.onderwerp;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.ontvangers;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[Ontvanger]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              OntvangerSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final value = object.rawOnderwerp;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _berichtSerialize(
  Bericht object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObject<Afzender>(
    offsets[0],
    allOffsets,
    AfzenderSchema.serialize,
    object.afzender,
  );
  writer.writeString(offsets[1], object.aiSummary);
  writer.writeDateTime(offsets[2], object.beantwoordOp);
  writer.writeObjectList<Ontvanger>(
    offsets[3],
    allOffsets,
    OntvangerSchema.serialize,
    object.blindeKopieOntvangers,
  );
  writer.writeDateTime(offsets[4], object.doorgestuurdOp);
  writer.writeBool(offsets[5], object.heeftBijlagen);
  writer.writeBool(offsets[6], object.heeftPrioriteit);
  writer.writeLong(offsets[7], object.id);
  writer.writeString(offsets[8], object.inhoud);
  writer.writeBool(offsets[9], object.isGelezen);
  writer.writeObjectList<Ontvanger>(
    offsets[10],
    allOffsets,
    OntvangerSchema.serialize,
    object.kopieOntvangers,
  );
  writer.writeObject<ItemLinks>(
    offsets[11],
    allOffsets,
    ItemLinksSchema.serialize,
    object.links,
  );
  writer.writeLong(offsets[12], object.mapId);
  writer.writeString(offsets[13], object.onderwerp);
  writer.writeObjectList<Ontvanger>(
    offsets[14],
    allOffsets,
    OntvangerSchema.serialize,
    object.ontvangers,
  );
  writer.writeString(offsets[15], object.rawOnderwerp);
  writer.writeDateTime(offsets[16], object.verzondenOp);
}

Bericht _berichtDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Bericht(
    afzender: reader.readObjectOrNull<Afzender>(
      offsets[0],
      AfzenderSchema.deserialize,
      allOffsets,
    ),
    beantwoordOp: reader.readDateTimeOrNull(offsets[2]),
    blindeKopieOntvangers: reader.readObjectList<Ontvanger>(
      offsets[3],
      OntvangerSchema.deserialize,
      allOffsets,
      Ontvanger(),
    ),
    doorgestuurdOp: reader.readDateTimeOrNull(offsets[4]),
    heeftBijlagen: reader.readBool(offsets[5]),
    heeftPrioriteit: reader.readBool(offsets[6]),
    id: reader.readLong(offsets[7]),
    inhoud: reader.readStringOrNull(offsets[8]),
    isGelezen: reader.readBool(offsets[9]),
    kopieOntvangers: reader.readObjectList<Ontvanger>(
      offsets[10],
      OntvangerSchema.deserialize,
      allOffsets,
      Ontvanger(),
    ),
    links: reader.readObjectOrNull<ItemLinks>(
          offsets[11],
          ItemLinksSchema.deserialize,
          allOffsets,
        ) ??
        ItemLinks(),
    mapId: reader.readLong(offsets[12]),
    ontvangers: reader.readObjectList<Ontvanger>(
      offsets[14],
      OntvangerSchema.deserialize,
      allOffsets,
      Ontvanger(),
    ),
    rawOnderwerp: reader.readStringOrNull(offsets[15]),
    verzondenOp: reader.readDateTime(offsets[16]),
  );
  object.aiSummary = reader.readStringOrNull(offsets[1]);
  object.onderwerp = reader.readStringOrNull(offsets[13]);
  return object;
}

P _berichtDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectOrNull<Afzender>(
        offset,
        AfzenderSchema.deserialize,
        allOffsets,
      )) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readObjectList<Ontvanger>(
        offset,
        OntvangerSchema.deserialize,
        allOffsets,
        Ontvanger(),
      )) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readObjectList<Ontvanger>(
        offset,
        OntvangerSchema.deserialize,
        allOffsets,
        Ontvanger(),
      )) as P;
    case 11:
      return (reader.readObjectOrNull<ItemLinks>(
            offset,
            ItemLinksSchema.deserialize,
            allOffsets,
          ) ??
          ItemLinks()) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readObjectList<Ontvanger>(
        offset,
        OntvangerSchema.deserialize,
        allOffsets,
        Ontvanger(),
      )) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _berichtGetId(Bericht object) {
  return object.uuid;
}

List<IsarLinkBase<dynamic>> _berichtGetLinks(Bericht object) {
  return [object.map, object.bronnen];
}

void _berichtAttach(IsarCollection<dynamic> col, Id id, Bericht object) {
  object.map.attach(col, col.isar.collection<MessagesFolder>(), r'map', id);
  object.bronnen.attach(col, col.isar.collection<Bron>(), r'bronnen', id);
}

extension BerichtQueryWhereSort on QueryBuilder<Bericht, Bericht, QWhere> {
  QueryBuilder<Bericht, Bericht, QAfterWhere> anyUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BerichtQueryWhere on QueryBuilder<Bericht, Bericht, QWhereClause> {
  QueryBuilder<Bericht, Bericht, QAfterWhereClause> uuidEqualTo(Id uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: uuid,
        upper: uuid,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterWhereClause> uuidNotEqualTo(Id uuid) {
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

  QueryBuilder<Bericht, Bericht, QAfterWhereClause> uuidGreaterThan(Id uuid,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: uuid, includeLower: include),
      );
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterWhereClause> uuidLessThan(Id uuid,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: uuid, includeUpper: include),
      );
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterWhereClause> uuidBetween(
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

extension BerichtQueryFilter
    on QueryBuilder<Bericht, Bericht, QFilterCondition> {
  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> afzenderIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'afzender',
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> afzenderIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'afzender',
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> aiSummaryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'aiSummary',
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> aiSummaryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'aiSummary',
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> aiSummaryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aiSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> aiSummaryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'aiSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> aiSummaryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'aiSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> aiSummaryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'aiSummary',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> aiSummaryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'aiSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> aiSummaryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'aiSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> aiSummaryContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'aiSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> aiSummaryMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'aiSummary',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> aiSummaryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aiSummary',
        value: '',
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> aiSummaryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'aiSummary',
        value: '',
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> beantwoordOpIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'beantwoordOp',
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition>
      beantwoordOpIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'beantwoordOp',
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> beantwoordOpEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'beantwoordOp',
        value: value,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> beantwoordOpGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'beantwoordOp',
        value: value,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> beantwoordOpLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'beantwoordOp',
        value: value,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> beantwoordOpBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'beantwoordOp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition>
      blindeKopieOntvangersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'blindeKopieOntvangers',
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition>
      blindeKopieOntvangersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'blindeKopieOntvangers',
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition>
      blindeKopieOntvangersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blindeKopieOntvangers',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition>
      blindeKopieOntvangersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blindeKopieOntvangers',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition>
      blindeKopieOntvangersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blindeKopieOntvangers',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition>
      blindeKopieOntvangersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blindeKopieOntvangers',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition>
      blindeKopieOntvangersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blindeKopieOntvangers',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition>
      blindeKopieOntvangersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blindeKopieOntvangers',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> doorgestuurdOpIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'doorgestuurdOp',
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition>
      doorgestuurdOpIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'doorgestuurdOp',
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> doorgestuurdOpEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'doorgestuurdOp',
        value: value,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition>
      doorgestuurdOpGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'doorgestuurdOp',
        value: value,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> doorgestuurdOpLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'doorgestuurdOp',
        value: value,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> doorgestuurdOpBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'doorgestuurdOp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> heeftBijlagenEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'heeftBijlagen',
        value: value,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> heeftPrioriteitEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'heeftPrioriteit',
        value: value,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> inhoudIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'inhoud',
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> inhoudIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'inhoud',
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> inhoudEqualTo(
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

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> inhoudGreaterThan(
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

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> inhoudLessThan(
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

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> inhoudBetween(
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

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> inhoudStartsWith(
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

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> inhoudEndsWith(
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

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> inhoudContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'inhoud',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> inhoudMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'inhoud',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> inhoudIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'inhoud',
        value: '',
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> inhoudIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'inhoud',
        value: '',
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> isGelezenEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isGelezen',
        value: value,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition>
      kopieOntvangersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'kopieOntvangers',
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition>
      kopieOntvangersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'kopieOntvangers',
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition>
      kopieOntvangersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'kopieOntvangers',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition>
      kopieOntvangersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'kopieOntvangers',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition>
      kopieOntvangersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'kopieOntvangers',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition>
      kopieOntvangersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'kopieOntvangers',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition>
      kopieOntvangersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'kopieOntvangers',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition>
      kopieOntvangersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'kopieOntvangers',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> mapIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mapId',
        value: value,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> mapIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mapId',
        value: value,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> mapIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mapId',
        value: value,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> mapIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mapId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> onderwerpIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'onderwerp',
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> onderwerpIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'onderwerp',
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> onderwerpEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'onderwerp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> onderwerpGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'onderwerp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> onderwerpLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'onderwerp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> onderwerpBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'onderwerp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> onderwerpStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'onderwerp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> onderwerpEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'onderwerp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> onderwerpContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'onderwerp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> onderwerpMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'onderwerp',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> onderwerpIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'onderwerp',
        value: '',
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> onderwerpIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'onderwerp',
        value: '',
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> ontvangersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ontvangers',
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> ontvangersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ontvangers',
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> ontvangersLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ontvangers',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> ontvangersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ontvangers',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> ontvangersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ontvangers',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition>
      ontvangersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ontvangers',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition>
      ontvangersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ontvangers',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> ontvangersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ontvangers',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> rawOnderwerpIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rawOnderwerp',
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition>
      rawOnderwerpIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rawOnderwerp',
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> rawOnderwerpEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawOnderwerp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> rawOnderwerpGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawOnderwerp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> rawOnderwerpLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawOnderwerp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> rawOnderwerpBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawOnderwerp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> rawOnderwerpStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rawOnderwerp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> rawOnderwerpEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rawOnderwerp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> rawOnderwerpContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rawOnderwerp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> rawOnderwerpMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rawOnderwerp',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> rawOnderwerpIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawOnderwerp',
        value: '',
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition>
      rawOnderwerpIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rawOnderwerp',
        value: '',
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> uuidEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> uuidGreaterThan(
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

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> uuidLessThan(
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

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> uuidBetween(
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

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> verzondenOpEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verzondenOp',
        value: value,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> verzondenOpGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'verzondenOp',
        value: value,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> verzondenOpLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'verzondenOp',
        value: value,
      ));
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> verzondenOpBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'verzondenOp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BerichtQueryObject
    on QueryBuilder<Bericht, Bericht, QFilterCondition> {
  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> afzender(
      FilterQuery<Afzender> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'afzender');
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition>
      blindeKopieOntvangersElement(FilterQuery<Ontvanger> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'blindeKopieOntvangers');
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> kopieOntvangersElement(
      FilterQuery<Ontvanger> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'kopieOntvangers');
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> links(
      FilterQuery<ItemLinks> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'links');
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> ontvangersElement(
      FilterQuery<Ontvanger> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'ontvangers');
    });
  }
}

extension BerichtQueryLinks
    on QueryBuilder<Bericht, Bericht, QFilterCondition> {
  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> map(
      FilterQuery<MessagesFolder> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'map');
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> mapIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'map', 0, true, 0, true);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> bronnen(
      FilterQuery<Bron> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'bronnen');
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> bronnenLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', length, true, length, true);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> bronnenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', 0, true, 0, true);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> bronnenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', 0, false, 999999, true);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> bronnenLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', 0, true, length, include);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition>
      bronnenLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bronnen', length, include, 999999, true);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> bronnenLengthBetween(
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

extension BerichtQuerySortBy on QueryBuilder<Bericht, Bericht, QSortBy> {
  QueryBuilder<Bericht, Bericht, QAfterSortBy> sortByAiSummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiSummary', Sort.asc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> sortByAiSummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiSummary', Sort.desc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> sortByBeantwoordOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beantwoordOp', Sort.asc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> sortByBeantwoordOpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beantwoordOp', Sort.desc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> sortByDoorgestuurdOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doorgestuurdOp', Sort.asc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> sortByDoorgestuurdOpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doorgestuurdOp', Sort.desc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> sortByHeeftBijlagen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heeftBijlagen', Sort.asc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> sortByHeeftBijlagenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heeftBijlagen', Sort.desc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> sortByHeeftPrioriteit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heeftPrioriteit', Sort.asc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> sortByHeeftPrioriteitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heeftPrioriteit', Sort.desc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> sortByInhoud() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inhoud', Sort.asc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> sortByInhoudDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inhoud', Sort.desc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> sortByIsGelezen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGelezen', Sort.asc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> sortByIsGelezenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGelezen', Sort.desc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> sortByMapId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mapId', Sort.asc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> sortByMapIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mapId', Sort.desc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> sortByOnderwerp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onderwerp', Sort.asc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> sortByOnderwerpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onderwerp', Sort.desc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> sortByRawOnderwerp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawOnderwerp', Sort.asc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> sortByRawOnderwerpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawOnderwerp', Sort.desc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> sortByVerzondenOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verzondenOp', Sort.asc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> sortByVerzondenOpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verzondenOp', Sort.desc);
    });
  }
}

extension BerichtQuerySortThenBy
    on QueryBuilder<Bericht, Bericht, QSortThenBy> {
  QueryBuilder<Bericht, Bericht, QAfterSortBy> thenByAiSummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiSummary', Sort.asc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> thenByAiSummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiSummary', Sort.desc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> thenByBeantwoordOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beantwoordOp', Sort.asc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> thenByBeantwoordOpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beantwoordOp', Sort.desc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> thenByDoorgestuurdOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doorgestuurdOp', Sort.asc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> thenByDoorgestuurdOpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doorgestuurdOp', Sort.desc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> thenByHeeftBijlagen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heeftBijlagen', Sort.asc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> thenByHeeftBijlagenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heeftBijlagen', Sort.desc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> thenByHeeftPrioriteit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heeftPrioriteit', Sort.asc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> thenByHeeftPrioriteitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heeftPrioriteit', Sort.desc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> thenByInhoud() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inhoud', Sort.asc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> thenByInhoudDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inhoud', Sort.desc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> thenByIsGelezen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGelezen', Sort.asc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> thenByIsGelezenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGelezen', Sort.desc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> thenByMapId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mapId', Sort.asc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> thenByMapIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mapId', Sort.desc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> thenByOnderwerp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onderwerp', Sort.asc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> thenByOnderwerpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onderwerp', Sort.desc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> thenByRawOnderwerp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawOnderwerp', Sort.asc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> thenByRawOnderwerpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawOnderwerp', Sort.desc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> thenByVerzondenOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verzondenOp', Sort.asc);
    });
  }

  QueryBuilder<Bericht, Bericht, QAfterSortBy> thenByVerzondenOpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verzondenOp', Sort.desc);
    });
  }
}

extension BerichtQueryWhereDistinct
    on QueryBuilder<Bericht, Bericht, QDistinct> {
  QueryBuilder<Bericht, Bericht, QDistinct> distinctByAiSummary(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'aiSummary', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bericht, Bericht, QDistinct> distinctByBeantwoordOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'beantwoordOp');
    });
  }

  QueryBuilder<Bericht, Bericht, QDistinct> distinctByDoorgestuurdOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'doorgestuurdOp');
    });
  }

  QueryBuilder<Bericht, Bericht, QDistinct> distinctByHeeftBijlagen() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'heeftBijlagen');
    });
  }

  QueryBuilder<Bericht, Bericht, QDistinct> distinctByHeeftPrioriteit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'heeftPrioriteit');
    });
  }

  QueryBuilder<Bericht, Bericht, QDistinct> distinctById() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id');
    });
  }

  QueryBuilder<Bericht, Bericht, QDistinct> distinctByInhoud(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'inhoud', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bericht, Bericht, QDistinct> distinctByIsGelezen() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isGelezen');
    });
  }

  QueryBuilder<Bericht, Bericht, QDistinct> distinctByMapId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mapId');
    });
  }

  QueryBuilder<Bericht, Bericht, QDistinct> distinctByOnderwerp(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'onderwerp', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bericht, Bericht, QDistinct> distinctByRawOnderwerp(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rawOnderwerp', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bericht, Bericht, QDistinct> distinctByVerzondenOp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'verzondenOp');
    });
  }
}

extension BerichtQueryProperty
    on QueryBuilder<Bericht, Bericht, QQueryProperty> {
  QueryBuilder<Bericht, int, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }

  QueryBuilder<Bericht, Afzender?, QQueryOperations> afzenderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'afzender');
    });
  }

  QueryBuilder<Bericht, String?, QQueryOperations> aiSummaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'aiSummary');
    });
  }

  QueryBuilder<Bericht, DateTime?, QQueryOperations> beantwoordOpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'beantwoordOp');
    });
  }

  QueryBuilder<Bericht, List<Ontvanger>?, QQueryOperations>
      blindeKopieOntvangersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'blindeKopieOntvangers');
    });
  }

  QueryBuilder<Bericht, DateTime?, QQueryOperations> doorgestuurdOpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'doorgestuurdOp');
    });
  }

  QueryBuilder<Bericht, bool, QQueryOperations> heeftBijlagenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'heeftBijlagen');
    });
  }

  QueryBuilder<Bericht, bool, QQueryOperations> heeftPrioriteitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'heeftPrioriteit');
    });
  }

  QueryBuilder<Bericht, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Bericht, String?, QQueryOperations> inhoudProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'inhoud');
    });
  }

  QueryBuilder<Bericht, bool, QQueryOperations> isGelezenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isGelezen');
    });
  }

  QueryBuilder<Bericht, List<Ontvanger>?, QQueryOperations>
      kopieOntvangersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kopieOntvangers');
    });
  }

  QueryBuilder<Bericht, ItemLinks, QQueryOperations> linksProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'links');
    });
  }

  QueryBuilder<Bericht, int, QQueryOperations> mapIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mapId');
    });
  }

  QueryBuilder<Bericht, String?, QQueryOperations> onderwerpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'onderwerp');
    });
  }

  QueryBuilder<Bericht, List<Ontvanger>?, QQueryOperations>
      ontvangersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ontvangers');
    });
  }

  QueryBuilder<Bericht, String?, QQueryOperations> rawOnderwerpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rawOnderwerp');
    });
  }

  QueryBuilder<Bericht, DateTime, QQueryOperations> verzondenOpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'verzondenOp');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMessagesFolderCollection on Isar {
  IsarCollection<MessagesFolder> get messagesFolders => this.collection();
}

const MessagesFolderSchema = CollectionSchema(
  name: r'BerichtFolder',
  id: -7262539142761133581,
  properties: {
    r'aantalOngelezen': PropertySchema(
      id: 0,
      name: r'aantalOngelezen',
      type: IsarType.long,
    ),
    r'berichtenLink': PropertySchema(
      id: 1,
      name: r'berichtenLink',
      type: IsarType.string,
    ),
    r'bovenliggendeId': PropertySchema(
      id: 2,
      name: r'bovenliggendeId',
      type: IsarType.long,
    ),
    r'id': PropertySchema(
      id: 3,
      name: r'id',
      type: IsarType.long,
    ),
    r'naam': PropertySchema(
      id: 4,
      name: r'naam',
      type: IsarType.string,
    )
  },
  estimateSize: _messagesFolderEstimateSize,
  serialize: _messagesFolderSerialize,
  deserialize: _messagesFolderDeserialize,
  deserializeProp: _messagesFolderDeserializeProp,
  idName: r'uuid',
  indexes: {},
  links: {
    r'berichten': LinkSchema(
      id: 432710088560605676,
      name: r'berichten',
      target: r'Bericht',
      single: false,
    ),
    r'profile': LinkSchema(
      id: -4720084540702727719,
      name: r'profile',
      target: r'Profile',
      single: true,
      linkName: r'berichtMappen',
    )
  },
  embeddedSchemas: {},
  getId: _messagesFolderGetId,
  getLinks: _messagesFolderGetLinks,
  attach: _messagesFolderAttach,
  version: '3.1.0+1',
);

int _messagesFolderEstimateSize(
  MessagesFolder object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.berichtenLink.length * 3;
  bytesCount += 3 + object.naam.length * 3;
  return bytesCount;
}

void _messagesFolderSerialize(
  MessagesFolder object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.aantalOngelezen);
  writer.writeString(offsets[1], object.berichtenLink);
  writer.writeLong(offsets[2], object.bovenliggendeId);
  writer.writeLong(offsets[3], object.id);
  writer.writeString(offsets[4], object.naam);
}

MessagesFolder _messagesFolderDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MessagesFolder(
    aantalOngelezen: reader.readLong(offsets[0]),
    berichtenLink: reader.readString(offsets[1]),
    bovenliggendeId: reader.readLong(offsets[2]),
    id: reader.readLong(offsets[3]),
    naam: reader.readString(offsets[4]),
  );
  return object;
}

P _messagesFolderDeserializeProp<P>(
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
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _messagesFolderGetId(MessagesFolder object) {
  return object.uuid;
}

List<IsarLinkBase<dynamic>> _messagesFolderGetLinks(MessagesFolder object) {
  return [object.berichten, object.profile];
}

void _messagesFolderAttach(
    IsarCollection<dynamic> col, Id id, MessagesFolder object) {
  object.berichten
      .attach(col, col.isar.collection<Bericht>(), r'berichten', id);
  object.profile.attach(col, col.isar.collection<Profile>(), r'profile', id);
}

extension MessagesFolderQueryWhereSort
    on QueryBuilder<MessagesFolder, MessagesFolder, QWhere> {
  QueryBuilder<MessagesFolder, MessagesFolder, QAfterWhere> anyUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MessagesFolderQueryWhere
    on QueryBuilder<MessagesFolder, MessagesFolder, QWhereClause> {
  QueryBuilder<MessagesFolder, MessagesFolder, QAfterWhereClause> uuidEqualTo(
      Id uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: uuid,
        upper: uuid,
      ));
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterWhereClause>
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

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterWhereClause>
      uuidGreaterThan(Id uuid, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: uuid, includeLower: include),
      );
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterWhereClause> uuidLessThan(
      Id uuid,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: uuid, includeUpper: include),
      );
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterWhereClause> uuidBetween(
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

extension MessagesFolderQueryFilter
    on QueryBuilder<MessagesFolder, MessagesFolder, QFilterCondition> {
  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      aantalOngelezenEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aantalOngelezen',
        value: value,
      ));
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      aantalOngelezenGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'aantalOngelezen',
        value: value,
      ));
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      aantalOngelezenLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'aantalOngelezen',
        value: value,
      ));
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      aantalOngelezenBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'aantalOngelezen',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      berichtenLinkEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'berichtenLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      berichtenLinkGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'berichtenLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      berichtenLinkLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'berichtenLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      berichtenLinkBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'berichtenLink',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      berichtenLinkStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'berichtenLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      berichtenLinkEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'berichtenLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      berichtenLinkContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'berichtenLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      berichtenLinkMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'berichtenLink',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      berichtenLinkIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'berichtenLink',
        value: '',
      ));
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      berichtenLinkIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'berichtenLink',
        value: '',
      ));
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      bovenliggendeIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bovenliggendeId',
        value: value,
      ));
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      bovenliggendeIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bovenliggendeId',
        value: value,
      ));
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      bovenliggendeIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bovenliggendeId',
        value: value,
      ));
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      bovenliggendeIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bovenliggendeId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition> idEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
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

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
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

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition> idBetween(
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

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
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

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
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

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
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

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
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

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
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

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
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

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      naamContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'naam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      naamMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'naam',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      naamIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'naam',
        value: '',
      ));
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      naamIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'naam',
        value: '',
      ));
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      uuidEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
      ));
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
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

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
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

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
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

extension MessagesFolderQueryObject
    on QueryBuilder<MessagesFolder, MessagesFolder, QFilterCondition> {}

extension MessagesFolderQueryLinks
    on QueryBuilder<MessagesFolder, MessagesFolder, QFilterCondition> {
  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition> berichten(
      FilterQuery<Bericht> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'berichten');
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      berichtenLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'berichten', length, true, length, true);
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      berichtenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'berichten', 0, true, 0, true);
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      berichtenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'berichten', 0, false, 999999, true);
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      berichtenLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'berichten', 0, true, length, include);
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      berichtenLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'berichten', length, include, 999999, true);
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      berichtenLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'berichten', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition> profile(
      FilterQuery<Profile> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'profile');
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterFilterCondition>
      profileIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'profile', 0, true, 0, true);
    });
  }
}

extension MessagesFolderQuerySortBy
    on QueryBuilder<MessagesFolder, MessagesFolder, QSortBy> {
  QueryBuilder<MessagesFolder, MessagesFolder, QAfterSortBy>
      sortByAantalOngelezen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aantalOngelezen', Sort.asc);
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterSortBy>
      sortByAantalOngelezenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aantalOngelezen', Sort.desc);
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterSortBy>
      sortByBerichtenLink() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'berichtenLink', Sort.asc);
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterSortBy>
      sortByBerichtenLinkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'berichtenLink', Sort.desc);
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterSortBy>
      sortByBovenliggendeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bovenliggendeId', Sort.asc);
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterSortBy>
      sortByBovenliggendeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bovenliggendeId', Sort.desc);
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterSortBy> sortByNaam() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'naam', Sort.asc);
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterSortBy> sortByNaamDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'naam', Sort.desc);
    });
  }
}

extension MessagesFolderQuerySortThenBy
    on QueryBuilder<MessagesFolder, MessagesFolder, QSortThenBy> {
  QueryBuilder<MessagesFolder, MessagesFolder, QAfterSortBy>
      thenByAantalOngelezen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aantalOngelezen', Sort.asc);
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterSortBy>
      thenByAantalOngelezenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aantalOngelezen', Sort.desc);
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterSortBy>
      thenByBerichtenLink() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'berichtenLink', Sort.asc);
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterSortBy>
      thenByBerichtenLinkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'berichtenLink', Sort.desc);
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterSortBy>
      thenByBovenliggendeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bovenliggendeId', Sort.asc);
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterSortBy>
      thenByBovenliggendeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bovenliggendeId', Sort.desc);
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterSortBy> thenByNaam() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'naam', Sort.asc);
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterSortBy> thenByNaamDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'naam', Sort.desc);
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension MessagesFolderQueryWhereDistinct
    on QueryBuilder<MessagesFolder, MessagesFolder, QDistinct> {
  QueryBuilder<MessagesFolder, MessagesFolder, QDistinct>
      distinctByAantalOngelezen() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'aantalOngelezen');
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QDistinct>
      distinctByBerichtenLink({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'berichtenLink',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QDistinct>
      distinctByBovenliggendeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bovenliggendeId');
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QDistinct> distinctById() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id');
    });
  }

  QueryBuilder<MessagesFolder, MessagesFolder, QDistinct> distinctByNaam(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'naam', caseSensitive: caseSensitive);
    });
  }
}

extension MessagesFolderQueryProperty
    on QueryBuilder<MessagesFolder, MessagesFolder, QQueryProperty> {
  QueryBuilder<MessagesFolder, int, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }

  QueryBuilder<MessagesFolder, int, QQueryOperations>
      aantalOngelezenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'aantalOngelezen');
    });
  }

  QueryBuilder<MessagesFolder, String, QQueryOperations>
      berichtenLinkProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'berichtenLink');
    });
  }

  QueryBuilder<MessagesFolder, int, QQueryOperations>
      bovenliggendeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bovenliggendeId');
    });
  }

  QueryBuilder<MessagesFolder, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MessagesFolder, String, QQueryOperations> naamProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'naam');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const AfzenderSchema = Schema(
  name: r'Afzender',
  id: 469968178623850746,
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
  estimateSize: _afzenderEstimateSize,
  serialize: _afzenderSerialize,
  deserialize: _afzenderDeserialize,
  deserializeProp: _afzenderDeserializeProp,
);

int _afzenderEstimateSize(
  Afzender object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.naam.length * 3;
  return bytesCount;
}

void _afzenderSerialize(
  Afzender object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.id);
  writer.writeString(offsets[1], object.naam);
}

Afzender _afzenderDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Afzender(
    id: reader.readLongOrNull(offsets[0]) ?? 0,
    naam: reader.readStringOrNull(offsets[1]) ?? "",
  );
  return object;
}

P _afzenderDeserializeProp<P>(
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

extension AfzenderQueryFilter
    on QueryBuilder<Afzender, Afzender, QFilterCondition> {
  QueryBuilder<Afzender, Afzender, QAfterFilterCondition> idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Afzender, Afzender, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Afzender, Afzender, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Afzender, Afzender, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Afzender, Afzender, QAfterFilterCondition> naamEqualTo(
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

  QueryBuilder<Afzender, Afzender, QAfterFilterCondition> naamGreaterThan(
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

  QueryBuilder<Afzender, Afzender, QAfterFilterCondition> naamLessThan(
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

  QueryBuilder<Afzender, Afzender, QAfterFilterCondition> naamBetween(
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

  QueryBuilder<Afzender, Afzender, QAfterFilterCondition> naamStartsWith(
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

  QueryBuilder<Afzender, Afzender, QAfterFilterCondition> naamEndsWith(
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

  QueryBuilder<Afzender, Afzender, QAfterFilterCondition> naamContains(
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

  QueryBuilder<Afzender, Afzender, QAfterFilterCondition> naamMatches(
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

  QueryBuilder<Afzender, Afzender, QAfterFilterCondition> naamIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'naam',
        value: '',
      ));
    });
  }

  QueryBuilder<Afzender, Afzender, QAfterFilterCondition> naamIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'naam',
        value: '',
      ));
    });
  }
}

extension AfzenderQueryObject
    on QueryBuilder<Afzender, Afzender, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ItemLinksSchema = Schema(
  name: r'ItemLinks',
  id: -6585801451387787126,
  properties: {
    r'bijlagen': PropertySchema(
      id: 0,
      name: r'bijlagen',
      type: IsarType.string,
    ),
    r'map': PropertySchema(
      id: 1,
      name: r'map',
      type: IsarType.string,
    ),
    r'self': PropertySchema(
      id: 2,
      name: r'self',
      type: IsarType.string,
    )
  },
  estimateSize: _itemLinksEstimateSize,
  serialize: _itemLinksSerialize,
  deserialize: _itemLinksDeserialize,
  deserializeProp: _itemLinksDeserializeProp,
);

int _itemLinksEstimateSize(
  ItemLinks object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.bijlagen;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.map.length * 3;
  bytesCount += 3 + object.self.length * 3;
  return bytesCount;
}

void _itemLinksSerialize(
  ItemLinks object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.bijlagen);
  writer.writeString(offsets[1], object.map);
  writer.writeString(offsets[2], object.self);
}

ItemLinks _itemLinksDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ItemLinks(
    bijlagen: reader.readStringOrNull(offsets[0]),
    map: reader.readStringOrNull(offsets[1]) ?? "",
    self: reader.readStringOrNull(offsets[2]) ?? "",
  );
  return object;
}

P _itemLinksDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? "") as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ItemLinksQueryFilter
    on QueryBuilder<ItemLinks, ItemLinks, QFilterCondition> {
  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> bijlagenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bijlagen',
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition>
      bijlagenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bijlagen',
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> bijlagenEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bijlagen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> bijlagenGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bijlagen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> bijlagenLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bijlagen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> bijlagenBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bijlagen',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> bijlagenStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bijlagen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> bijlagenEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bijlagen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> bijlagenContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bijlagen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> bijlagenMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bijlagen',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> bijlagenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bijlagen',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition>
      bijlagenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bijlagen',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> mapEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'map',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> mapGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'map',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> mapLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'map',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> mapBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'map',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> mapStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'map',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> mapEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'map',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> mapContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'map',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> mapMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'map',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> mapIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'map',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> mapIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'map',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> selfEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'self',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> selfGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'self',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> selfLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'self',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> selfBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'self',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> selfStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'self',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> selfEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'self',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> selfContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'self',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> selfMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'self',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> selfIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'self',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemLinks, ItemLinks, QAfterFilterCondition> selfIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'self',
        value: '',
      ));
    });
  }
}

extension ItemLinksQueryObject
    on QueryBuilder<ItemLinks, ItemLinks, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const OntvangerSchema = Schema(
  name: r'Ontvanger',
  id: -4341706745789138068,
  properties: {
    r'id': PropertySchema(
      id: 0,
      name: r'id',
      type: IsarType.long,
    ),
    r'mailGroep': PropertySchema(
      id: 1,
      name: r'mailGroep',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 2,
      name: r'type',
      type: IsarType.string,
    ),
    r'weergavenaam': PropertySchema(
      id: 3,
      name: r'weergavenaam',
      type: IsarType.string,
    )
  },
  estimateSize: _ontvangerEstimateSize,
  serialize: _ontvangerSerialize,
  deserialize: _ontvangerDeserialize,
  deserializeProp: _ontvangerDeserializeProp,
);

int _ontvangerEstimateSize(
  Ontvanger object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.mailGroep;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.type.length * 3;
  bytesCount += 3 + object.weergavenaam.length * 3;
  return bytesCount;
}

void _ontvangerSerialize(
  Ontvanger object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.id);
  writer.writeString(offsets[1], object.mailGroep);
  writer.writeString(offsets[2], object.type);
  writer.writeString(offsets[3], object.weergavenaam);
}

Ontvanger _ontvangerDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Ontvanger(
    id: reader.readLongOrNull(offsets[0]) ?? 0,
    mailGroep: reader.readStringOrNull(offsets[1]),
    type: reader.readStringOrNull(offsets[2]) ?? "",
    weergavenaam: reader.readStringOrNull(offsets[3]) ?? "",
  );
  return object;
}

P _ontvangerDeserializeProp<P>(
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
    case 2:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 3:
      return (reader.readStringOrNull(offset) ?? "") as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension OntvangerQueryFilter
    on QueryBuilder<Ontvanger, Ontvanger, QFilterCondition> {
  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition> idEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition> mailGroepIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mailGroep',
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition>
      mailGroepIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mailGroep',
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition> mailGroepEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mailGroep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition>
      mailGroepGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mailGroep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition> mailGroepLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mailGroep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition> mailGroepBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mailGroep',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition> mailGroepStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mailGroep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition> mailGroepEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mailGroep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition> mailGroepContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mailGroep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition> mailGroepMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mailGroep',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition> mailGroepIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mailGroep',
        value: '',
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition>
      mailGroepIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mailGroep',
        value: '',
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition> typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition> typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition> typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition> typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition> typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition> weergavenaamEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weergavenaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition>
      weergavenaamGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weergavenaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition>
      weergavenaamLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weergavenaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition> weergavenaamBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weergavenaam',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition>
      weergavenaamStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'weergavenaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition>
      weergavenaamEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'weergavenaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition>
      weergavenaamContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'weergavenaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition> weergavenaamMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'weergavenaam',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition>
      weergavenaamIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weergavenaam',
        value: '',
      ));
    });
  }

  QueryBuilder<Ontvanger, Ontvanger, QAfterFilterCondition>
      weergavenaamIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'weergavenaam',
        value: '',
      ));
    });
  }
}

extension OntvangerQueryObject
    on QueryBuilder<Ontvanger, Ontvanger, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const UploadedAttachmentSchema = Schema(
  name: r'UploadedAttachment',
  id: -4383038682009375870,
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
    ),
    r'storageId': PropertySchema(
      id: 2,
      name: r'storageId',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 3,
      name: r'type',
      type: IsarType.string,
    )
  },
  estimateSize: _uploadedAttachmentEstimateSize,
  serialize: _uploadedAttachmentSerialize,
  deserialize: _uploadedAttachmentDeserialize,
  deserializeProp: _uploadedAttachmentDeserializeProp,
);

int _uploadedAttachmentEstimateSize(
  UploadedAttachment object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.naam.length * 3;
  {
    final value = object.storageId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _uploadedAttachmentSerialize(
  UploadedAttachment object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.id);
  writer.writeString(offsets[1], object.naam);
  writer.writeString(offsets[2], object.storageId);
  writer.writeString(offsets[3], object.type);
}

UploadedAttachment _uploadedAttachmentDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UploadedAttachment(
    id: reader.readLongOrNull(offsets[0]) ?? 0,
    naam: reader.readStringOrNull(offsets[1]) ?? "",
    storageId: reader.readStringOrNull(offsets[2]),
    type: reader.readStringOrNull(offsets[3]) ?? "upload",
  );
  return object;
}

P _uploadedAttachmentDeserializeProp<P>(
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
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset) ?? "upload") as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension UploadedAttachmentQueryFilter
    on QueryBuilder<UploadedAttachment, UploadedAttachment, QFilterCondition> {
  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
      idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
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

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
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

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
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

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
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

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
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

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
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

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
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

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
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

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
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

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
      naamContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'naam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
      naamMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'naam',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
      naamIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'naam',
        value: '',
      ));
    });
  }

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
      naamIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'naam',
        value: '',
      ));
    });
  }

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
      storageIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'storageId',
      ));
    });
  }

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
      storageIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'storageId',
      ));
    });
  }

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
      storageIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'storageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
      storageIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'storageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
      storageIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'storageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
      storageIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'storageId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
      storageIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'storageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
      storageIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'storageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
      storageIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'storageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
      storageIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'storageId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
      storageIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'storageId',
        value: '',
      ));
    });
  }

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
      storageIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'storageId',
        value: '',
      ));
    });
  }

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
      typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
      typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
      typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
      typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
      typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
      typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<UploadedAttachment, UploadedAttachment, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension UploadedAttachmentQueryObject
    on QueryBuilder<UploadedAttachment, UploadedAttachment, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ContactSchema = Schema(
  name: r'Contact',
  id: 342568039478732666,
  properties: {
    r'achternaam': PropertySchema(
      id: 0,
      name: r'achternaam',
      type: IsarType.string,
    ),
    r'code': PropertySchema(
      id: 1,
      name: r'code',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 2,
      name: r'id',
      type: IsarType.long,
    ),
    r'klas': PropertySchema(
      id: 3,
      name: r'klas',
      type: IsarType.string,
    ),
    r'roepnaam': PropertySchema(
      id: 4,
      name: r'roepnaam',
      type: IsarType.string,
    ),
    r'tussenvoegsel': PropertySchema(
      id: 5,
      name: r'tussenvoegsel',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 6,
      name: r'type',
      type: IsarType.string,
    ),
    r'voorletters': PropertySchema(
      id: 7,
      name: r'voorletters',
      type: IsarType.string,
    )
  },
  estimateSize: _contactEstimateSize,
  serialize: _contactSerialize,
  deserialize: _contactDeserialize,
  deserializeProp: _contactDeserializeProp,
);

int _contactEstimateSize(
  Contact object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.achternaam.length * 3;
  {
    final value = object.code;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.klas;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.roepnaam;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.tussenvoegsel;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.type.length * 3;
  bytesCount += 3 + object.voorletters.length * 3;
  return bytesCount;
}

void _contactSerialize(
  Contact object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.achternaam);
  writer.writeString(offsets[1], object.code);
  writer.writeLong(offsets[2], object.id);
  writer.writeString(offsets[3], object.klas);
  writer.writeString(offsets[4], object.roepnaam);
  writer.writeString(offsets[5], object.tussenvoegsel);
  writer.writeString(offsets[6], object.type);
  writer.writeString(offsets[7], object.voorletters);
}

Contact _contactDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Contact(
    achternaam: reader.readStringOrNull(offsets[0]) ?? "",
    code: reader.readStringOrNull(offsets[1]),
    id: reader.readLongOrNull(offsets[2]) ?? 0,
    klas: reader.readStringOrNull(offsets[3]),
    roepnaam: reader.readStringOrNull(offsets[4]),
    tussenvoegsel: reader.readStringOrNull(offsets[5]),
    type: reader.readStringOrNull(offsets[6]) ?? "",
    voorletters: reader.readStringOrNull(offsets[7]) ?? "",
  );
  return object;
}

P _contactDeserializeProp<P>(
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
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 7:
      return (reader.readStringOrNull(offset) ?? "") as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ContactQueryFilter
    on QueryBuilder<Contact, Contact, QFilterCondition> {
  QueryBuilder<Contact, Contact, QAfterFilterCondition> achternaamEqualTo(
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

  QueryBuilder<Contact, Contact, QAfterFilterCondition> achternaamGreaterThan(
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

  QueryBuilder<Contact, Contact, QAfterFilterCondition> achternaamLessThan(
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

  QueryBuilder<Contact, Contact, QAfterFilterCondition> achternaamBetween(
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

  QueryBuilder<Contact, Contact, QAfterFilterCondition> achternaamStartsWith(
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

  QueryBuilder<Contact, Contact, QAfterFilterCondition> achternaamEndsWith(
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

  QueryBuilder<Contact, Contact, QAfterFilterCondition> achternaamContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'achternaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> achternaamMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'achternaam',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> achternaamIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'achternaam',
        value: '',
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> achternaamIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'achternaam',
        value: '',
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> codeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'code',
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> codeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'code',
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> codeEqualTo(
    String? value, {
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

  QueryBuilder<Contact, Contact, QAfterFilterCondition> codeGreaterThan(
    String? value, {
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

  QueryBuilder<Contact, Contact, QAfterFilterCondition> codeLessThan(
    String? value, {
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

  QueryBuilder<Contact, Contact, QAfterFilterCondition> codeBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<Contact, Contact, QAfterFilterCondition> codeStartsWith(
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

  QueryBuilder<Contact, Contact, QAfterFilterCondition> codeEndsWith(
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

  QueryBuilder<Contact, Contact, QAfterFilterCondition> codeContains(
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

  QueryBuilder<Contact, Contact, QAfterFilterCondition> codeMatches(
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

  QueryBuilder<Contact, Contact, QAfterFilterCondition> codeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'code',
        value: '',
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> codeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'code',
        value: '',
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Contact, Contact, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Contact, Contact, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Contact, Contact, QAfterFilterCondition> klasIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'klas',
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> klasIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'klas',
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> klasEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'klas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> klasGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'klas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> klasLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'klas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> klasBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'klas',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> klasStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'klas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> klasEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'klas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> klasContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'klas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> klasMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'klas',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> klasIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'klas',
        value: '',
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> klasIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'klas',
        value: '',
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> roepnaamIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'roepnaam',
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> roepnaamIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'roepnaam',
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> roepnaamEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'roepnaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> roepnaamGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'roepnaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> roepnaamLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'roepnaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> roepnaamBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'roepnaam',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> roepnaamStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'roepnaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> roepnaamEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'roepnaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> roepnaamContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'roepnaam',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> roepnaamMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'roepnaam',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> roepnaamIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'roepnaam',
        value: '',
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> roepnaamIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'roepnaam',
        value: '',
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> tussenvoegselIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tussenvoegsel',
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition>
      tussenvoegselIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tussenvoegsel',
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> tussenvoegselEqualTo(
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

  QueryBuilder<Contact, Contact, QAfterFilterCondition>
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

  QueryBuilder<Contact, Contact, QAfterFilterCondition> tussenvoegselLessThan(
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

  QueryBuilder<Contact, Contact, QAfterFilterCondition> tussenvoegselBetween(
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

  QueryBuilder<Contact, Contact, QAfterFilterCondition> tussenvoegselStartsWith(
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

  QueryBuilder<Contact, Contact, QAfterFilterCondition> tussenvoegselEndsWith(
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

  QueryBuilder<Contact, Contact, QAfterFilterCondition> tussenvoegselContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tussenvoegsel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> tussenvoegselMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tussenvoegsel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> tussenvoegselIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tussenvoegsel',
        value: '',
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition>
      tussenvoegselIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tussenvoegsel',
        value: '',
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> voorlettersEqualTo(
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

  QueryBuilder<Contact, Contact, QAfterFilterCondition> voorlettersGreaterThan(
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

  QueryBuilder<Contact, Contact, QAfterFilterCondition> voorlettersLessThan(
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

  QueryBuilder<Contact, Contact, QAfterFilterCondition> voorlettersBetween(
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

  QueryBuilder<Contact, Contact, QAfterFilterCondition> voorlettersStartsWith(
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

  QueryBuilder<Contact, Contact, QAfterFilterCondition> voorlettersEndsWith(
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

  QueryBuilder<Contact, Contact, QAfterFilterCondition> voorlettersContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'voorletters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> voorlettersMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'voorletters',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition> voorlettersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'voorletters',
        value: '',
      ));
    });
  }

  QueryBuilder<Contact, Contact, QAfterFilterCondition>
      voorlettersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'voorletters',
        value: '',
      ));
    });
  }
}

extension ContactQueryObject
    on QueryBuilder<Contact, Contact, QFilterCondition> {}
