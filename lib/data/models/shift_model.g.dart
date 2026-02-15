// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetShiftLocalCollection on Isar {
  IsarCollection<ShiftLocal> get shiftLocals => this.collection();
}

const ShiftLocalSchema = CollectionSchema(
  name: r'ShiftLocal',
  id: -3169860387316943507,
  properties: {
    r'endTime': PropertySchema(
      id: 0,
      name: r'endTime',
      type: IsarType.string,
    ),
    r'graceMinutes': PropertySchema(
      id: 1,
      name: r'graceMinutes',
      type: IsarType.long,
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.string,
    ),
    r'odId': PropertySchema(
      id: 3,
      name: r'odId',
      type: IsarType.string,
    ),
    r'startTime': PropertySchema(
      id: 4,
      name: r'startTime',
      type: IsarType.string,
    ),
    r'workDays': PropertySchema(
      id: 5,
      name: r'workDays',
      type: IsarType.stringList,
    )
  },
  estimateSize: _shiftLocalEstimateSize,
  serialize: _shiftLocalSerialize,
  deserialize: _shiftLocalDeserialize,
  deserializeProp: _shiftLocalDeserializeProp,
  idName: r'id',
  indexes: {
    r'odId': IndexSchema(
      id: -3963395389739130653,
      name: r'odId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'odId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _shiftLocalGetId,
  getLinks: _shiftLocalGetLinks,
  attach: _shiftLocalAttach,
  version: '3.1.0+1',
);

int _shiftLocalEstimateSize(
  ShiftLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.endTime.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.odId.length * 3;
  bytesCount += 3 + object.startTime.length * 3;
  bytesCount += 3 + object.workDays.length * 3;
  {
    for (var i = 0; i < object.workDays.length; i++) {
      final value = object.workDays[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _shiftLocalSerialize(
  ShiftLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.endTime);
  writer.writeLong(offsets[1], object.graceMinutes);
  writer.writeString(offsets[2], object.name);
  writer.writeString(offsets[3], object.odId);
  writer.writeString(offsets[4], object.startTime);
  writer.writeStringList(offsets[5], object.workDays);
}

ShiftLocal _shiftLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ShiftLocal();
  object.endTime = reader.readString(offsets[0]);
  object.graceMinutes = reader.readLong(offsets[1]);
  object.id = id;
  object.name = reader.readString(offsets[2]);
  object.odId = reader.readString(offsets[3]);
  object.startTime = reader.readString(offsets[4]);
  object.workDays = reader.readStringList(offsets[5]) ?? [];
  return object;
}

P _shiftLocalDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _shiftLocalGetId(ShiftLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _shiftLocalGetLinks(ShiftLocal object) {
  return [];
}

void _shiftLocalAttach(IsarCollection<dynamic> col, Id id, ShiftLocal object) {
  object.id = id;
}

extension ShiftLocalByIndex on IsarCollection<ShiftLocal> {
  Future<ShiftLocal?> getByOdId(String odId) {
    return getByIndex(r'odId', [odId]);
  }

  ShiftLocal? getByOdIdSync(String odId) {
    return getByIndexSync(r'odId', [odId]);
  }

  Future<bool> deleteByOdId(String odId) {
    return deleteByIndex(r'odId', [odId]);
  }

  bool deleteByOdIdSync(String odId) {
    return deleteByIndexSync(r'odId', [odId]);
  }

  Future<List<ShiftLocal?>> getAllByOdId(List<String> odIdValues) {
    final values = odIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'odId', values);
  }

  List<ShiftLocal?> getAllByOdIdSync(List<String> odIdValues) {
    final values = odIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'odId', values);
  }

  Future<int> deleteAllByOdId(List<String> odIdValues) {
    final values = odIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'odId', values);
  }

  int deleteAllByOdIdSync(List<String> odIdValues) {
    final values = odIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'odId', values);
  }

  Future<Id> putByOdId(ShiftLocal object) {
    return putByIndex(r'odId', object);
  }

  Id putByOdIdSync(ShiftLocal object, {bool saveLinks = true}) {
    return putByIndexSync(r'odId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByOdId(List<ShiftLocal> objects) {
    return putAllByIndex(r'odId', objects);
  }

  List<Id> putAllByOdIdSync(List<ShiftLocal> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'odId', objects, saveLinks: saveLinks);
  }
}

extension ShiftLocalQueryWhereSort
    on QueryBuilder<ShiftLocal, ShiftLocal, QWhere> {
  QueryBuilder<ShiftLocal, ShiftLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ShiftLocalQueryWhere
    on QueryBuilder<ShiftLocal, ShiftLocal, QWhereClause> {
  QueryBuilder<ShiftLocal, ShiftLocal, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterWhereClause> idBetween(
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

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterWhereClause> odIdEqualTo(
      String odId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'odId',
        value: [odId],
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterWhereClause> odIdNotEqualTo(
      String odId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'odId',
              lower: [],
              upper: [odId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'odId',
              lower: [odId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'odId',
              lower: [odId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'odId',
              lower: [],
              upper: [odId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ShiftLocalQueryFilter
    on QueryBuilder<ShiftLocal, ShiftLocal, QFilterCondition> {
  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> endTimeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition>
      endTimeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> endTimeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> endTimeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> endTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> endTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> endTimeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> endTimeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'endTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> endTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTime',
        value: '',
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition>
      endTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'endTime',
        value: '',
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition>
      graceMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'graceMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition>
      graceMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'graceMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition>
      graceMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'graceMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition>
      graceMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'graceMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> nameContains(
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

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> odIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'odId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> odIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'odId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> odIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'odId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> odIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'odId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> odIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'odId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> odIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'odId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> odIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'odId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> odIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'odId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> odIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'odId',
        value: '',
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> odIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'odId',
        value: '',
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> startTimeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition>
      startTimeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> startTimeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> startTimeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition>
      startTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> startTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> startTimeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition> startTimeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'startTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition>
      startTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: '',
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition>
      startTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'startTime',
        value: '',
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition>
      workDaysElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workDays',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition>
      workDaysElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'workDays',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition>
      workDaysElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'workDays',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition>
      workDaysElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'workDays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition>
      workDaysElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'workDays',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition>
      workDaysElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'workDays',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition>
      workDaysElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'workDays',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition>
      workDaysElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'workDays',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition>
      workDaysElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workDays',
        value: '',
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition>
      workDaysElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'workDays',
        value: '',
      ));
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition>
      workDaysLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workDays',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition>
      workDaysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workDays',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition>
      workDaysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workDays',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition>
      workDaysLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workDays',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition>
      workDaysLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workDays',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterFilterCondition>
      workDaysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workDays',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension ShiftLocalQueryObject
    on QueryBuilder<ShiftLocal, ShiftLocal, QFilterCondition> {}

extension ShiftLocalQueryLinks
    on QueryBuilder<ShiftLocal, ShiftLocal, QFilterCondition> {}

extension ShiftLocalQuerySortBy
    on QueryBuilder<ShiftLocal, ShiftLocal, QSortBy> {
  QueryBuilder<ShiftLocal, ShiftLocal, QAfterSortBy> sortByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterSortBy> sortByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterSortBy> sortByGraceMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'graceMinutes', Sort.asc);
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterSortBy> sortByGraceMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'graceMinutes', Sort.desc);
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterSortBy> sortByOdId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'odId', Sort.asc);
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterSortBy> sortByOdIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'odId', Sort.desc);
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterSortBy> sortByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterSortBy> sortByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }
}

extension ShiftLocalQuerySortThenBy
    on QueryBuilder<ShiftLocal, ShiftLocal, QSortThenBy> {
  QueryBuilder<ShiftLocal, ShiftLocal, QAfterSortBy> thenByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterSortBy> thenByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterSortBy> thenByGraceMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'graceMinutes', Sort.asc);
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterSortBy> thenByGraceMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'graceMinutes', Sort.desc);
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterSortBy> thenByOdId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'odId', Sort.asc);
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterSortBy> thenByOdIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'odId', Sort.desc);
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterSortBy> thenByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QAfterSortBy> thenByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }
}

extension ShiftLocalQueryWhereDistinct
    on QueryBuilder<ShiftLocal, ShiftLocal, QDistinct> {
  QueryBuilder<ShiftLocal, ShiftLocal, QDistinct> distinctByEndTime(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endTime', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QDistinct> distinctByGraceMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'graceMinutes');
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QDistinct> distinctByOdId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'odId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QDistinct> distinctByStartTime(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTime', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ShiftLocal, ShiftLocal, QDistinct> distinctByWorkDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workDays');
    });
  }
}

extension ShiftLocalQueryProperty
    on QueryBuilder<ShiftLocal, ShiftLocal, QQueryProperty> {
  QueryBuilder<ShiftLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ShiftLocal, String, QQueryOperations> endTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endTime');
    });
  }

  QueryBuilder<ShiftLocal, int, QQueryOperations> graceMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'graceMinutes');
    });
  }

  QueryBuilder<ShiftLocal, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<ShiftLocal, String, QQueryOperations> odIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'odId');
    });
  }

  QueryBuilder<ShiftLocal, String, QQueryOperations> startTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTime');
    });
  }

  QueryBuilder<ShiftLocal, List<String>, QQueryOperations> workDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workDays');
    });
  }
}
