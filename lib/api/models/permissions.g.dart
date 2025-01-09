// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permissions.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const PermissionSchema = Schema(
  name: r'Permission',
  id: 5583744244740860356,
  properties: {
    r'statuses': PropertySchema(
      id: 0,
      name: r'statuses',
      type: IsarType.byteList,
      enumMap: _PermissionstatusesEnumValueMap,
    ),
    r'type': PropertySchema(
      id: 1,
      name: r'type',
      type: IsarType.byte,
      enumMap: _PermissiontypeEnumValueMap,
    )
  },
  estimateSize: _permissionEstimateSize,
  serialize: _permissionSerialize,
  deserialize: _permissionDeserialize,
  deserializeProp: _permissionDeserializeProp,
);

int _permissionEstimateSize(
  Permission object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.statuses.length;
  return bytesCount;
}

void _permissionSerialize(
  Permission object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByteList(
      offsets[0], object.statuses.map((e) => e.index).toList());
  writer.writeByte(offsets[1], object.type.index);
}

Permission _permissionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Permission(
    statuses: reader
            .readByteList(offsets[0])
            ?.map((e) =>
                _PermissionstatusesValueEnumMap[e] ?? PermissionStatus.read)
            .toList() ??
        const [],
    type: _PermissiontypeValueEnumMap[reader.readByteOrNull(offsets[1])] ??
        PermissionType.unknown,
  );
  return object;
}

P _permissionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader
              .readByteList(offset)
              ?.map((e) =>
                  _PermissionstatusesValueEnumMap[e] ?? PermissionStatus.read)
              .toList() ??
          const []) as P;
    case 1:
      return (_PermissiontypeValueEnumMap[reader.readByteOrNull(offset)] ??
          PermissionType.unknown) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _PermissionstatusesEnumValueMap = {
  'read': 0,
  'update': 1,
  'create': 2,
  'delete': 3,
  'unknown': 4,
};
const _PermissionstatusesValueEnumMap = {
  0: PermissionStatus.read,
  1: PermissionStatus.update,
  2: PermissionStatus.create,
  3: PermissionStatus.delete,
  4: PermissionStatus.unknown,
};
const _PermissiontypeEnumValueMap = {
  'cijfers': 0,
  'aanmeldingen': 1,
  'wachtwoordWijzigen': 2,
  'profielEmail': 3,
  'digitaalLesmateriaal': 4,
  'eloOpdracht': 5,
  'studiewijzers': 6,
  'projecten': 7,
  'bronnen': 8,
  'berichten': 9,
  'profiel': 10,
  'profielMobiel': 11,
  'absenties': 12,
  'afspraken': 13,
  'aftekenen': 14,
  'contactpersonen': 15,
  'roosterwijzigingen': 16,
  'kinderen': 17,
  'instellingen': 18,
  'activiteiten': 19,
  'mataHuiswerk': 20,
  'mataWidgets': 21,
  'mataBerichtMappen': 22,
  'mataKinderen': 23,
  'mataDigitaalLesmateriaal': 24,
  'mataEloOpdracht': 25,
  'mataBerichten': 26,
  'mataContactpersonen': 27,
  'mataStudiewijzer': 28,
  'mataProjecten': 29,
  'mataRoosterwijzigingen': 30,
  'ouderavond': 31,
  'mataAftekenen': 32,
  'oauth': 33,
  'leerlingAutorisatie': 34,
  'logboeken': 35,
  'lesperioden': 36,
  'portfolio': 37,
  'persoonsgegevens': 38,
  'lOOfficielePersoonsgegevens': 39,
  'examenresultaten': 40,
  'terugkommaatregelen': 41,
  'leerlingen': 42,
  'vakken': 43,
  'mededelingen': 44,
  'keuzelijsten': 45,
  'administratieveEenheid': 46,
  'contactsoorten': 47,
  'absentiemeldingen': 48,
  'overeenkomsten': 49,
  'toestemmingen': 50,
  'berichtenNotificatie': 51,
  'geboortegegevens': 52,
  'privemail': 53,
  'leerlingFoto': 54,
  'unknown': 55,
};
const _PermissiontypeValueEnumMap = {
  0: PermissionType.cijfers,
  1: PermissionType.aanmeldingen,
  2: PermissionType.wachtwoordWijzigen,
  3: PermissionType.profielEmail,
  4: PermissionType.digitaalLesmateriaal,
  5: PermissionType.eloOpdracht,
  6: PermissionType.studiewijzers,
  7: PermissionType.projecten,
  8: PermissionType.bronnen,
  9: PermissionType.berichten,
  10: PermissionType.profiel,
  11: PermissionType.profielMobiel,
  12: PermissionType.absenties,
  13: PermissionType.afspraken,
  14: PermissionType.aftekenen,
  15: PermissionType.contactpersonen,
  16: PermissionType.roosterwijzigingen,
  17: PermissionType.kinderen,
  18: PermissionType.instellingen,
  19: PermissionType.activiteiten,
  20: PermissionType.mataHuiswerk,
  21: PermissionType.mataWidgets,
  22: PermissionType.mataBerichtMappen,
  23: PermissionType.mataKinderen,
  24: PermissionType.mataDigitaalLesmateriaal,
  25: PermissionType.mataEloOpdracht,
  26: PermissionType.mataBerichten,
  27: PermissionType.mataContactpersonen,
  28: PermissionType.mataStudiewijzer,
  29: PermissionType.mataProjecten,
  30: PermissionType.mataRoosterwijzigingen,
  31: PermissionType.ouderavond,
  32: PermissionType.mataAftekenen,
  33: PermissionType.oauth,
  34: PermissionType.leerlingAutorisatie,
  35: PermissionType.logboeken,
  36: PermissionType.lesperioden,
  37: PermissionType.portfolio,
  38: PermissionType.persoonsgegevens,
  39: PermissionType.lOOfficielePersoonsgegevens,
  40: PermissionType.examenresultaten,
  41: PermissionType.terugkommaatregelen,
  42: PermissionType.leerlingen,
  43: PermissionType.vakken,
  44: PermissionType.mededelingen,
  45: PermissionType.keuzelijsten,
  46: PermissionType.administratieveEenheid,
  47: PermissionType.contactsoorten,
  48: PermissionType.absentiemeldingen,
  49: PermissionType.overeenkomsten,
  50: PermissionType.toestemmingen,
  51: PermissionType.berichtenNotificatie,
  52: PermissionType.geboortegegevens,
  53: PermissionType.privemail,
  54: PermissionType.leerlingFoto,
  55: PermissionType.unknown,
};

extension PermissionQueryFilter
    on QueryBuilder<Permission, Permission, QFilterCondition> {
  QueryBuilder<Permission, Permission, QAfterFilterCondition>
      statusesElementEqualTo(PermissionStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statuses',
        value: value,
      ));
    });
  }

  QueryBuilder<Permission, Permission, QAfterFilterCondition>
      statusesElementGreaterThan(
    PermissionStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'statuses',
        value: value,
      ));
    });
  }

  QueryBuilder<Permission, Permission, QAfterFilterCondition>
      statusesElementLessThan(
    PermissionStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'statuses',
        value: value,
      ));
    });
  }

  QueryBuilder<Permission, Permission, QAfterFilterCondition>
      statusesElementBetween(
    PermissionStatus lower,
    PermissionStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'statuses',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Permission, Permission, QAfterFilterCondition>
      statusesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'statuses',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Permission, Permission, QAfterFilterCondition>
      statusesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'statuses',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Permission, Permission, QAfterFilterCondition>
      statusesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'statuses',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Permission, Permission, QAfterFilterCondition>
      statusesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'statuses',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Permission, Permission, QAfterFilterCondition>
      statusesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'statuses',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Permission, Permission, QAfterFilterCondition>
      statusesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'statuses',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Permission, Permission, QAfterFilterCondition> typeEqualTo(
      PermissionType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<Permission, Permission, QAfterFilterCondition> typeGreaterThan(
    PermissionType value, {
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

  QueryBuilder<Permission, Permission, QAfterFilterCondition> typeLessThan(
    PermissionType value, {
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

  QueryBuilder<Permission, Permission, QAfterFilterCondition> typeBetween(
    PermissionType lower,
    PermissionType upper, {
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
}

extension PermissionQueryObject
    on QueryBuilder<Permission, Permission, QFilterCondition> {}
