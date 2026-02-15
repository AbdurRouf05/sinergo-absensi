// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dynamic_outpost_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDynamicOutpostLocalCollection on Isar {
  IsarCollection<DynamicOutpostLocal> get dynamicOutpostLocals =>
      this.collection();
}

const DynamicOutpostLocalSchema = CollectionSchema(
  name: r'DynamicOutpostLocal',
  id: -4782865509528010138,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'createdBy': PropertySchema(
      id: 1,
      name: r'createdBy',
      type: IsarType.string,
    ),
    r'expirationTime': PropertySchema(
      id: 2,
      name: r'expirationTime',
      type: IsarType.dateTime,
    ),
    r'isActive': PropertySchema(
      id: 3,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'lat': PropertySchema(
      id: 4,
      name: r'lat',
      type: IsarType.double,
    ),
    r'lng': PropertySchema(
      id: 5,
      name: r'lng',
      type: IsarType.double,
    ),
    r'name': PropertySchema(
      id: 6,
      name: r'name',
      type: IsarType.string,
    ),
    r'odId': PropertySchema(
      id: 7,
      name: r'odId',
      type: IsarType.string,
    ),
    r'radius': PropertySchema(
      id: 8,
      name: r'radius',
      type: IsarType.double,
    )
  },
  estimateSize: _dynamicOutpostLocalEstimateSize,
  serialize: _dynamicOutpostLocalSerialize,
  deserialize: _dynamicOutpostLocalDeserialize,
  deserializeProp: _dynamicOutpostLocalDeserializeProp,
  idName: r'id',
  indexes: {
    r'odId': IndexSchema(
      id: -3963395389739130653,
      name: r'odId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'odId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'lat': IndexSchema(
      id: 3038781890822997334,
      name: r'lat',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'lat',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'lng': IndexSchema(
      id: 428885709538637475,
      name: r'lng',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'lng',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'expirationTime': IndexSchema(
      id: 8159581726421810642,
      name: r'expirationTime',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'expirationTime',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _dynamicOutpostLocalGetId,
  getLinks: _dynamicOutpostLocalGetLinks,
  attach: _dynamicOutpostLocalAttach,
  version: '3.1.0+1',
);

int _dynamicOutpostLocalEstimateSize(
  DynamicOutpostLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.createdBy.length * 3;
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.odId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _dynamicOutpostLocalSerialize(
  DynamicOutpostLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.createdBy);
  writer.writeDateTime(offsets[2], object.expirationTime);
  writer.writeBool(offsets[3], object.isActive);
  writer.writeDouble(offsets[4], object.lat);
  writer.writeDouble(offsets[5], object.lng);
  writer.writeString(offsets[6], object.name);
  writer.writeString(offsets[7], object.odId);
  writer.writeDouble(offsets[8], object.radius);
}

DynamicOutpostLocal _dynamicOutpostLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DynamicOutpostLocal();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.createdBy = reader.readString(offsets[1]);
  object.expirationTime = reader.readDateTime(offsets[2]);
  object.id = id;
  object.isActive = reader.readBool(offsets[3]);
  object.lat = reader.readDouble(offsets[4]);
  object.lng = reader.readDouble(offsets[5]);
  object.name = reader.readString(offsets[6]);
  object.odId = reader.readStringOrNull(offsets[7]);
  object.radius = reader.readDouble(offsets[8]);
  return object;
}

P _dynamicOutpostLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dynamicOutpostLocalGetId(DynamicOutpostLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dynamicOutpostLocalGetLinks(
    DynamicOutpostLocal object) {
  return [];
}

void _dynamicOutpostLocalAttach(
    IsarCollection<dynamic> col, Id id, DynamicOutpostLocal object) {
  object.id = id;
}

extension DynamicOutpostLocalByIndex on IsarCollection<DynamicOutpostLocal> {
  Future<DynamicOutpostLocal?> getByOdId(String? odId) {
    return getByIndex(r'odId', [odId]);
  }

  DynamicOutpostLocal? getByOdIdSync(String? odId) {
    return getByIndexSync(r'odId', [odId]);
  }

  Future<bool> deleteByOdId(String? odId) {
    return deleteByIndex(r'odId', [odId]);
  }

  bool deleteByOdIdSync(String? odId) {
    return deleteByIndexSync(r'odId', [odId]);
  }

  Future<List<DynamicOutpostLocal?>> getAllByOdId(List<String?> odIdValues) {
    final values = odIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'odId', values);
  }

  List<DynamicOutpostLocal?> getAllByOdIdSync(List<String?> odIdValues) {
    final values = odIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'odId', values);
  }

  Future<int> deleteAllByOdId(List<String?> odIdValues) {
    final values = odIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'odId', values);
  }

  int deleteAllByOdIdSync(List<String?> odIdValues) {
    final values = odIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'odId', values);
  }

  Future<Id> putByOdId(DynamicOutpostLocal object) {
    return putByIndex(r'odId', object);
  }

  Id putByOdIdSync(DynamicOutpostLocal object, {bool saveLinks = true}) {
    return putByIndexSync(r'odId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByOdId(List<DynamicOutpostLocal> objects) {
    return putAllByIndex(r'odId', objects);
  }

  List<Id> putAllByOdIdSync(List<DynamicOutpostLocal> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'odId', objects, saveLinks: saveLinks);
  }
}

extension DynamicOutpostLocalQueryWhereSort
    on QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QWhere> {
  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterWhere> anyLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'lat'),
      );
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterWhere> anyLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'lng'),
      );
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterWhere>
      anyExpirationTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'expirationTime'),
      );
    });
  }
}

extension DynamicOutpostLocalQueryWhere
    on QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QWhereClause> {
  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterWhereClause>
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

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterWhereClause>
      odIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'odId',
        value: [null],
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterWhereClause>
      odIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'odId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterWhereClause>
      odIdEqualTo(String? odId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'odId',
        value: [odId],
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterWhereClause>
      odIdNotEqualTo(String? odId) {
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

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterWhereClause>
      latEqualTo(double lat) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lat',
        value: [lat],
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterWhereClause>
      latNotEqualTo(double lat) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lat',
              lower: [],
              upper: [lat],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lat',
              lower: [lat],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lat',
              lower: [lat],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lat',
              lower: [],
              upper: [lat],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterWhereClause>
      latGreaterThan(
    double lat, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lat',
        lower: [lat],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterWhereClause>
      latLessThan(
    double lat, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lat',
        lower: [],
        upper: [lat],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterWhereClause>
      latBetween(
    double lowerLat,
    double upperLat, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lat',
        lower: [lowerLat],
        includeLower: includeLower,
        upper: [upperLat],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterWhereClause>
      lngEqualTo(double lng) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lng',
        value: [lng],
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterWhereClause>
      lngNotEqualTo(double lng) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lng',
              lower: [],
              upper: [lng],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lng',
              lower: [lng],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lng',
              lower: [lng],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lng',
              lower: [],
              upper: [lng],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterWhereClause>
      lngGreaterThan(
    double lng, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lng',
        lower: [lng],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterWhereClause>
      lngLessThan(
    double lng, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lng',
        lower: [],
        upper: [lng],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterWhereClause>
      lngBetween(
    double lowerLng,
    double upperLng, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lng',
        lower: [lowerLng],
        includeLower: includeLower,
        upper: [upperLng],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterWhereClause>
      expirationTimeEqualTo(DateTime expirationTime) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'expirationTime',
        value: [expirationTime],
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterWhereClause>
      expirationTimeNotEqualTo(DateTime expirationTime) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'expirationTime',
              lower: [],
              upper: [expirationTime],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'expirationTime',
              lower: [expirationTime],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'expirationTime',
              lower: [expirationTime],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'expirationTime',
              lower: [],
              upper: [expirationTime],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterWhereClause>
      expirationTimeGreaterThan(
    DateTime expirationTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'expirationTime',
        lower: [expirationTime],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterWhereClause>
      expirationTimeLessThan(
    DateTime expirationTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'expirationTime',
        lower: [],
        upper: [expirationTime],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterWhereClause>
      expirationTimeBetween(
    DateTime lowerExpirationTime,
    DateTime upperExpirationTime, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'expirationTime',
        lower: [lowerExpirationTime],
        includeLower: includeLower,
        upper: [upperExpirationTime],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DynamicOutpostLocalQueryFilter on QueryBuilder<DynamicOutpostLocal,
    DynamicOutpostLocal, QFilterCondition> {
  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
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

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
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

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
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

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      createdByEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      createdByGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      createdByLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      createdByBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdBy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      createdByStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      createdByEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      createdByContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      createdByMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'createdBy',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      createdByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdBy',
        value: '',
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      createdByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'createdBy',
        value: '',
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      expirationTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expirationTime',
        value: value,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      expirationTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expirationTime',
        value: value,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      expirationTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expirationTime',
        value: value,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      expirationTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expirationTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
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

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
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

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
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

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      latEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      latGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      latLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      latBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      lngEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      lngGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      lngLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      lngBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lng',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      nameEqualTo(
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

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      nameGreaterThan(
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

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      nameLessThan(
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

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      nameBetween(
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

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      nameStartsWith(
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

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      nameEndsWith(
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

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      odIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'odId',
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      odIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'odId',
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      odIdEqualTo(
    String? value, {
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

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      odIdGreaterThan(
    String? value, {
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

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      odIdLessThan(
    String? value, {
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

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      odIdBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      odIdStartsWith(
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

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      odIdEndsWith(
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

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      odIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'odId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      odIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'odId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      odIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'odId',
        value: '',
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      odIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'odId',
        value: '',
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      radiusEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'radius',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      radiusGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'radius',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      radiusLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'radius',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterFilterCondition>
      radiusBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'radius',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension DynamicOutpostLocalQueryObject on QueryBuilder<DynamicOutpostLocal,
    DynamicOutpostLocal, QFilterCondition> {}

extension DynamicOutpostLocalQueryLinks on QueryBuilder<DynamicOutpostLocal,
    DynamicOutpostLocal, QFilterCondition> {}

extension DynamicOutpostLocalQuerySortBy
    on QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QSortBy> {
  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      sortByCreatedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.asc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      sortByCreatedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.desc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      sortByExpirationTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expirationTime', Sort.asc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      sortByExpirationTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expirationTime', Sort.desc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      sortByLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lat', Sort.asc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      sortByLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lat', Sort.desc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      sortByLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lng', Sort.asc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      sortByLngDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lng', Sort.desc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      sortByOdId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'odId', Sort.asc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      sortByOdIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'odId', Sort.desc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      sortByRadius() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'radius', Sort.asc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      sortByRadiusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'radius', Sort.desc);
    });
  }
}

extension DynamicOutpostLocalQuerySortThenBy
    on QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QSortThenBy> {
  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      thenByCreatedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.asc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      thenByCreatedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.desc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      thenByExpirationTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expirationTime', Sort.asc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      thenByExpirationTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expirationTime', Sort.desc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      thenByLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lat', Sort.asc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      thenByLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lat', Sort.desc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      thenByLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lng', Sort.asc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      thenByLngDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lng', Sort.desc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      thenByOdId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'odId', Sort.asc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      thenByOdIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'odId', Sort.desc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      thenByRadius() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'radius', Sort.asc);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QAfterSortBy>
      thenByRadiusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'radius', Sort.desc);
    });
  }
}

extension DynamicOutpostLocalQueryWhereDistinct
    on QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QDistinct> {
  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QDistinct>
      distinctByCreatedBy({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdBy', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QDistinct>
      distinctByExpirationTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expirationTime');
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QDistinct>
      distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QDistinct>
      distinctByLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lat');
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QDistinct>
      distinctByLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lng');
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QDistinct>
      distinctByOdId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'odId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QDistinct>
      distinctByRadius() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'radius');
    });
  }
}

extension DynamicOutpostLocalQueryProperty
    on QueryBuilder<DynamicOutpostLocal, DynamicOutpostLocal, QQueryProperty> {
  QueryBuilder<DynamicOutpostLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DynamicOutpostLocal, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<DynamicOutpostLocal, String, QQueryOperations>
      createdByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdBy');
    });
  }

  QueryBuilder<DynamicOutpostLocal, DateTime, QQueryOperations>
      expirationTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expirationTime');
    });
  }

  QueryBuilder<DynamicOutpostLocal, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<DynamicOutpostLocal, double, QQueryOperations> latProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lat');
    });
  }

  QueryBuilder<DynamicOutpostLocal, double, QQueryOperations> lngProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lng');
    });
  }

  QueryBuilder<DynamicOutpostLocal, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<DynamicOutpostLocal, String?, QQueryOperations> odIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'odId');
    });
  }

  QueryBuilder<DynamicOutpostLocal, double, QQueryOperations> radiusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'radius');
    });
  }
}
