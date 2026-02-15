// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'office_location_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOfficeLocationLocalCollection on Isar {
  IsarCollection<OfficeLocationLocal> get officeLocationLocals =>
      this.collection();
}

const OfficeLocationLocalSchema = CollectionSchema(
  name: r'OfficeLocationLocal',
  id: 6525411840555720422,
  properties: {
    r'allowedWifiBssids': PropertySchema(
      id: 0,
      name: r'allowedWifiBssids',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'isActive': PropertySchema(
      id: 2,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'lastSyncAt': PropertySchema(
      id: 3,
      name: r'lastSyncAt',
      type: IsarType.dateTime,
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
    ),
    r'updatedAt': PropertySchema(
      id: 9,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _officeLocationLocalEstimateSize,
  serialize: _officeLocationLocalSerialize,
  deserialize: _officeLocationLocalDeserialize,
  deserializeProp: _officeLocationLocalDeserializeProp,
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
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _officeLocationLocalGetId,
  getLinks: _officeLocationLocalGetLinks,
  attach: _officeLocationLocalAttach,
  version: '3.1.0+1',
);

int _officeLocationLocalEstimateSize(
  OfficeLocationLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.allowedWifiBssids;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.odId.length * 3;
  return bytesCount;
}

void _officeLocationLocalSerialize(
  OfficeLocationLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.allowedWifiBssids);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeBool(offsets[2], object.isActive);
  writer.writeDateTime(offsets[3], object.lastSyncAt);
  writer.writeDouble(offsets[4], object.lat);
  writer.writeDouble(offsets[5], object.lng);
  writer.writeString(offsets[6], object.name);
  writer.writeString(offsets[7], object.odId);
  writer.writeDouble(offsets[8], object.radius);
  writer.writeDateTime(offsets[9], object.updatedAt);
}

OfficeLocationLocal _officeLocationLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OfficeLocationLocal();
  object.allowedWifiBssids = reader.readStringOrNull(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.id = id;
  object.isActive = reader.readBool(offsets[2]);
  object.lastSyncAt = reader.readDateTimeOrNull(offsets[3]);
  object.lat = reader.readDouble(offsets[4]);
  object.lng = reader.readDouble(offsets[5]);
  object.name = reader.readString(offsets[6]);
  object.odId = reader.readString(offsets[7]);
  object.radius = reader.readDouble(offsets[8]);
  object.updatedAt = reader.readDateTimeOrNull(offsets[9]);
  return object;
}

P _officeLocationLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _officeLocationLocalGetId(OfficeLocationLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _officeLocationLocalGetLinks(
    OfficeLocationLocal object) {
  return [];
}

void _officeLocationLocalAttach(
    IsarCollection<dynamic> col, Id id, OfficeLocationLocal object) {
  object.id = id;
}

extension OfficeLocationLocalByIndex on IsarCollection<OfficeLocationLocal> {
  Future<OfficeLocationLocal?> getByOdId(String odId) {
    return getByIndex(r'odId', [odId]);
  }

  OfficeLocationLocal? getByOdIdSync(String odId) {
    return getByIndexSync(r'odId', [odId]);
  }

  Future<bool> deleteByOdId(String odId) {
    return deleteByIndex(r'odId', [odId]);
  }

  bool deleteByOdIdSync(String odId) {
    return deleteByIndexSync(r'odId', [odId]);
  }

  Future<List<OfficeLocationLocal?>> getAllByOdId(List<String> odIdValues) {
    final values = odIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'odId', values);
  }

  List<OfficeLocationLocal?> getAllByOdIdSync(List<String> odIdValues) {
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

  Future<Id> putByOdId(OfficeLocationLocal object) {
    return putByIndex(r'odId', object);
  }

  Id putByOdIdSync(OfficeLocationLocal object, {bool saveLinks = true}) {
    return putByIndexSync(r'odId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByOdId(List<OfficeLocationLocal> objects) {
    return putAllByIndex(r'odId', objects);
  }

  List<Id> putAllByOdIdSync(List<OfficeLocationLocal> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'odId', objects, saveLinks: saveLinks);
  }
}

extension OfficeLocationLocalQueryWhereSort
    on QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QWhere> {
  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterWhere> anyLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'lat'),
      );
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterWhere> anyLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'lng'),
      );
    });
  }
}

extension OfficeLocationLocalQueryWhere
    on QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QWhereClause> {
  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterWhereClause>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterWhereClause>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterWhereClause>
      odIdEqualTo(String odId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'odId',
        value: [odId],
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterWhereClause>
      odIdNotEqualTo(String odId) {
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterWhereClause>
      latEqualTo(double lat) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lat',
        value: [lat],
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterWhereClause>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterWhereClause>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterWhereClause>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterWhereClause>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterWhereClause>
      lngEqualTo(double lng) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lng',
        value: [lng],
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterWhereClause>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterWhereClause>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterWhereClause>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterWhereClause>
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
}

extension OfficeLocationLocalQueryFilter on QueryBuilder<OfficeLocationLocal,
    OfficeLocationLocal, QFilterCondition> {
  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      allowedWifiBssidsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'allowedWifiBssids',
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      allowedWifiBssidsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'allowedWifiBssids',
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      allowedWifiBssidsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'allowedWifiBssids',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      allowedWifiBssidsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'allowedWifiBssids',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      allowedWifiBssidsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'allowedWifiBssids',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      allowedWifiBssidsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'allowedWifiBssids',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      allowedWifiBssidsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'allowedWifiBssids',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      allowedWifiBssidsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'allowedWifiBssids',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      allowedWifiBssidsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'allowedWifiBssids',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      allowedWifiBssidsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'allowedWifiBssids',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      allowedWifiBssidsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'allowedWifiBssids',
        value: '',
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      allowedWifiBssidsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'allowedWifiBssids',
        value: '',
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      lastSyncAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSyncAt',
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      lastSyncAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSyncAt',
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      lastSyncAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSyncAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      lastSyncAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastSyncAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      lastSyncAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastSyncAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      lastSyncAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastSyncAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      odIdEqualTo(
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      odIdGreaterThan(
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      odIdLessThan(
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      odIdBetween(
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      odIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'odId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      odIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'odId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      odIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'odId',
        value: '',
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      odIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'odId',
        value: '',
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime? value, {
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime? value, {
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

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterFilterCondition>
      updatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
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

extension OfficeLocationLocalQueryObject on QueryBuilder<OfficeLocationLocal,
    OfficeLocationLocal, QFilterCondition> {}

extension OfficeLocationLocalQueryLinks on QueryBuilder<OfficeLocationLocal,
    OfficeLocationLocal, QFilterCondition> {}

extension OfficeLocationLocalQuerySortBy
    on QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QSortBy> {
  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      sortByAllowedWifiBssids() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowedWifiBssids', Sort.asc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      sortByAllowedWifiBssidsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowedWifiBssids', Sort.desc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      sortByLastSyncAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncAt', Sort.asc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      sortByLastSyncAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncAt', Sort.desc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      sortByLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lat', Sort.asc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      sortByLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lat', Sort.desc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      sortByLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lng', Sort.asc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      sortByLngDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lng', Sort.desc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      sortByOdId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'odId', Sort.asc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      sortByOdIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'odId', Sort.desc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      sortByRadius() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'radius', Sort.asc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      sortByRadiusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'radius', Sort.desc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension OfficeLocationLocalQuerySortThenBy
    on QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QSortThenBy> {
  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      thenByAllowedWifiBssids() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowedWifiBssids', Sort.asc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      thenByAllowedWifiBssidsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowedWifiBssids', Sort.desc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      thenByLastSyncAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncAt', Sort.asc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      thenByLastSyncAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncAt', Sort.desc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      thenByLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lat', Sort.asc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      thenByLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lat', Sort.desc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      thenByLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lng', Sort.asc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      thenByLngDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lng', Sort.desc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      thenByOdId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'odId', Sort.asc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      thenByOdIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'odId', Sort.desc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      thenByRadius() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'radius', Sort.asc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      thenByRadiusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'radius', Sort.desc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension OfficeLocationLocalQueryWhereDistinct
    on QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QDistinct> {
  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QDistinct>
      distinctByAllowedWifiBssids({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'allowedWifiBssids',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QDistinct>
      distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QDistinct>
      distinctByLastSyncAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncAt');
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QDistinct>
      distinctByLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lat');
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QDistinct>
      distinctByLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lng');
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QDistinct>
      distinctByOdId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'odId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QDistinct>
      distinctByRadius() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'radius');
    });
  }

  QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension OfficeLocationLocalQueryProperty
    on QueryBuilder<OfficeLocationLocal, OfficeLocationLocal, QQueryProperty> {
  QueryBuilder<OfficeLocationLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OfficeLocationLocal, String?, QQueryOperations>
      allowedWifiBssidsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'allowedWifiBssids');
    });
  }

  QueryBuilder<OfficeLocationLocal, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<OfficeLocationLocal, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<OfficeLocationLocal, DateTime?, QQueryOperations>
      lastSyncAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncAt');
    });
  }

  QueryBuilder<OfficeLocationLocal, double, QQueryOperations> latProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lat');
    });
  }

  QueryBuilder<OfficeLocationLocal, double, QQueryOperations> lngProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lng');
    });
  }

  QueryBuilder<OfficeLocationLocal, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<OfficeLocationLocal, String, QQueryOperations> odIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'odId');
    });
  }

  QueryBuilder<OfficeLocationLocal, double, QQueryOperations> radiusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'radius');
    });
  }

  QueryBuilder<OfficeLocationLocal, DateTime?, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
