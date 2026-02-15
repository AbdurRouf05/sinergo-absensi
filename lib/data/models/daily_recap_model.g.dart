// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_recap_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDailyRecapLocalCollection on Isar {
  IsarCollection<DailyRecapLocal> get dailyRecapLocals => this.collection();
}

const DailyRecapLocalSchema = CollectionSchema(
  name: r'DailyRecapLocal',
  id: 3281624296378251398,
  properties: {
    r'absentEmployeeNames': PropertySchema(
      id: 0,
      name: r'absentEmployeeNames',
      type: IsarType.stringList,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'date': PropertySchema(
      id: 2,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'totalAbsent': PropertySchema(
      id: 3,
      name: r'totalAbsent',
      type: IsarType.long,
    ),
    r'totalLeave': PropertySchema(
      id: 4,
      name: r'totalLeave',
      type: IsarType.long,
    ),
    r'totalPending': PropertySchema(
      id: 5,
      name: r'totalPending',
      type: IsarType.long,
    ),
    r'totalPresent': PropertySchema(
      id: 6,
      name: r'totalPresent',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 7,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _dailyRecapLocalEstimateSize,
  serialize: _dailyRecapLocalSerialize,
  deserialize: _dailyRecapLocalDeserialize,
  deserializeProp: _dailyRecapLocalDeserializeProp,
  idName: r'id',
  indexes: {
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _dailyRecapLocalGetId,
  getLinks: _dailyRecapLocalGetLinks,
  attach: _dailyRecapLocalAttach,
  version: '3.1.0+1',
);

int _dailyRecapLocalEstimateSize(
  DailyRecapLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.absentEmployeeNames.length * 3;
  {
    for (var i = 0; i < object.absentEmployeeNames.length; i++) {
      final value = object.absentEmployeeNames[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _dailyRecapLocalSerialize(
  DailyRecapLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.absentEmployeeNames);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeDateTime(offsets[2], object.date);
  writer.writeLong(offsets[3], object.totalAbsent);
  writer.writeLong(offsets[4], object.totalLeave);
  writer.writeLong(offsets[5], object.totalPending);
  writer.writeLong(offsets[6], object.totalPresent);
  writer.writeDateTime(offsets[7], object.updatedAt);
}

DailyRecapLocal _dailyRecapLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyRecapLocal();
  object.absentEmployeeNames = reader.readStringList(offsets[0]) ?? [];
  object.createdAt = reader.readDateTime(offsets[1]);
  object.date = reader.readDateTime(offsets[2]);
  object.id = id;
  object.totalAbsent = reader.readLong(offsets[3]);
  object.totalLeave = reader.readLong(offsets[4]);
  object.totalPending = reader.readLong(offsets[5]);
  object.totalPresent = reader.readLong(offsets[6]);
  object.updatedAt = reader.readDateTime(offsets[7]);
  return object;
}

P _dailyRecapLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset) ?? []) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dailyRecapLocalGetId(DailyRecapLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dailyRecapLocalGetLinks(DailyRecapLocal object) {
  return [];
}

void _dailyRecapLocalAttach(
    IsarCollection<dynamic> col, Id id, DailyRecapLocal object) {
  object.id = id;
}

extension DailyRecapLocalByIndex on IsarCollection<DailyRecapLocal> {
  Future<DailyRecapLocal?> getByDate(DateTime date) {
    return getByIndex(r'date', [date]);
  }

  DailyRecapLocal? getByDateSync(DateTime date) {
    return getByIndexSync(r'date', [date]);
  }

  Future<bool> deleteByDate(DateTime date) {
    return deleteByIndex(r'date', [date]);
  }

  bool deleteByDateSync(DateTime date) {
    return deleteByIndexSync(r'date', [date]);
  }

  Future<List<DailyRecapLocal?>> getAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndex(r'date', values);
  }

  List<DailyRecapLocal?> getAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'date', values);
  }

  Future<int> deleteAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'date', values);
  }

  int deleteAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'date', values);
  }

  Future<Id> putByDate(DailyRecapLocal object) {
    return putByIndex(r'date', object);
  }

  Id putByDateSync(DailyRecapLocal object, {bool saveLinks = true}) {
    return putByIndexSync(r'date', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDate(List<DailyRecapLocal> objects) {
    return putAllByIndex(r'date', objects);
  }

  List<Id> putAllByDateSync(List<DailyRecapLocal> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'date', objects, saveLinks: saveLinks);
  }
}

extension DailyRecapLocalQueryWhereSort
    on QueryBuilder<DailyRecapLocal, DailyRecapLocal, QWhere> {
  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension DailyRecapLocalQueryWhere
    on QueryBuilder<DailyRecapLocal, DailyRecapLocal, QWhereClause> {
  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterWhereClause> dateEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterWhereClause>
      dateNotEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterWhereClause>
      dateGreaterThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [date],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterWhereClause>
      dateLessThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [],
        upper: [date],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterWhereClause> dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [lowerDate],
        includeLower: includeLower,
        upper: [upperDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DailyRecapLocalQueryFilter
    on QueryBuilder<DailyRecapLocal, DailyRecapLocal, QFilterCondition> {
  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      absentEmployeeNamesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'absentEmployeeNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      absentEmployeeNamesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'absentEmployeeNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      absentEmployeeNamesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'absentEmployeeNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      absentEmployeeNamesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'absentEmployeeNames',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      absentEmployeeNamesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'absentEmployeeNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      absentEmployeeNamesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'absentEmployeeNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      absentEmployeeNamesElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'absentEmployeeNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      absentEmployeeNamesElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'absentEmployeeNames',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      absentEmployeeNamesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'absentEmployeeNames',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      absentEmployeeNamesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'absentEmployeeNames',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      absentEmployeeNamesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'absentEmployeeNames',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      absentEmployeeNamesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'absentEmployeeNames',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      absentEmployeeNamesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'absentEmployeeNames',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      absentEmployeeNamesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'absentEmployeeNames',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      absentEmployeeNamesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'absentEmployeeNames',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      absentEmployeeNamesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'absentEmployeeNames',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
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

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      idLessThan(
    Id value, {
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

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
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

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      totalAbsentEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalAbsent',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      totalAbsentGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalAbsent',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      totalAbsentLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalAbsent',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      totalAbsentBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalAbsent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      totalLeaveEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalLeave',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      totalLeaveGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalLeave',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      totalLeaveLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalLeave',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      totalLeaveBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalLeave',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      totalPendingEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalPending',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      totalPendingGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalPending',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      totalPendingLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalPending',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      totalPendingBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalPending',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      totalPresentEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalPresent',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      totalPresentGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalPresent',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      totalPresentLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalPresent',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      totalPresentBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalPresent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DailyRecapLocalQueryObject
    on QueryBuilder<DailyRecapLocal, DailyRecapLocal, QFilterCondition> {}

extension DailyRecapLocalQueryLinks
    on QueryBuilder<DailyRecapLocal, DailyRecapLocal, QFilterCondition> {}

extension DailyRecapLocalQuerySortBy
    on QueryBuilder<DailyRecapLocal, DailyRecapLocal, QSortBy> {
  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy>
      sortByTotalAbsent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAbsent', Sort.asc);
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy>
      sortByTotalAbsentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAbsent', Sort.desc);
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy>
      sortByTotalLeave() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalLeave', Sort.asc);
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy>
      sortByTotalLeaveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalLeave', Sort.desc);
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy>
      sortByTotalPending() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPending', Sort.asc);
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy>
      sortByTotalPendingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPending', Sort.desc);
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy>
      sortByTotalPresent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPresent', Sort.asc);
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy>
      sortByTotalPresentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPresent', Sort.desc);
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension DailyRecapLocalQuerySortThenBy
    on QueryBuilder<DailyRecapLocal, DailyRecapLocal, QSortThenBy> {
  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy>
      thenByTotalAbsent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAbsent', Sort.asc);
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy>
      thenByTotalAbsentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAbsent', Sort.desc);
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy>
      thenByTotalLeave() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalLeave', Sort.asc);
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy>
      thenByTotalLeaveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalLeave', Sort.desc);
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy>
      thenByTotalPending() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPending', Sort.asc);
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy>
      thenByTotalPendingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPending', Sort.desc);
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy>
      thenByTotalPresent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPresent', Sort.asc);
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy>
      thenByTotalPresentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPresent', Sort.desc);
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension DailyRecapLocalQueryWhereDistinct
    on QueryBuilder<DailyRecapLocal, DailyRecapLocal, QDistinct> {
  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QDistinct>
      distinctByAbsentEmployeeNames() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'absentEmployeeNames');
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QDistinct>
      distinctByTotalAbsent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalAbsent');
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QDistinct>
      distinctByTotalLeave() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalLeave');
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QDistinct>
      distinctByTotalPending() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalPending');
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QDistinct>
      distinctByTotalPresent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalPresent');
    });
  }

  QueryBuilder<DailyRecapLocal, DailyRecapLocal, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension DailyRecapLocalQueryProperty
    on QueryBuilder<DailyRecapLocal, DailyRecapLocal, QQueryProperty> {
  QueryBuilder<DailyRecapLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DailyRecapLocal, List<String>, QQueryOperations>
      absentEmployeeNamesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'absentEmployeeNames');
    });
  }

  QueryBuilder<DailyRecapLocal, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<DailyRecapLocal, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<DailyRecapLocal, int, QQueryOperations> totalAbsentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalAbsent');
    });
  }

  QueryBuilder<DailyRecapLocal, int, QQueryOperations> totalLeaveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalLeave');
    });
  }

  QueryBuilder<DailyRecapLocal, int, QQueryOperations> totalPendingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalPending');
    });
  }

  QueryBuilder<DailyRecapLocal, int, QQueryOperations> totalPresentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalPresent');
    });
  }

  QueryBuilder<DailyRecapLocal, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
