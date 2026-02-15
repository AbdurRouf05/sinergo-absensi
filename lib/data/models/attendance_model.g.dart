// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAttendanceLocalCollection on Isar {
  IsarCollection<AttendanceLocal> get attendanceLocals => this.collection();
}

const AttendanceLocalSchema = CollectionSchema(
  name: r'AttendanceLocal',
  id: 2110290317284990226,
  properties: {
    r'checkInTime': PropertySchema(
      id: 0,
      name: r'checkInTime',
      type: IsarType.dateTime,
    ),
    r'checkOutTime': PropertySchema(
      id: 1,
      name: r'checkOutTime',
      type: IsarType.dateTime,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'deviceIdUsed': PropertySchema(
      id: 3,
      name: r'deviceIdUsed',
      type: IsarType.string,
    ),
    r'ganasNotes': PropertySchema(
      id: 4,
      name: r'ganasNotes',
      type: IsarType.string,
    ),
    r'gpsAccuracy': PropertySchema(
      id: 5,
      name: r'gpsAccuracy',
      type: IsarType.double,
    ),
    r'gpsLat': PropertySchema(
      id: 6,
      name: r'gpsLat',
      type: IsarType.double,
    ),
    r'gpsLong': PropertySchema(
      id: 7,
      name: r'gpsLong',
      type: IsarType.double,
    ),
    r'isGanas': PropertySchema(
      id: 8,
      name: r'isGanas',
      type: IsarType.bool,
    ),
    r'isGanasApproved': PropertySchema(
      id: 9,
      name: r'isGanasApproved',
      type: IsarType.bool,
    ),
    r'isOfflineEntry': PropertySchema(
      id: 10,
      name: r'isOfflineEntry',
      type: IsarType.bool,
    ),
    r'isOvertime': PropertySchema(
      id: 11,
      name: r'isOvertime',
      type: IsarType.bool,
    ),
    r'isOvertimeApproved': PropertySchema(
      id: 12,
      name: r'isOvertimeApproved',
      type: IsarType.bool,
    ),
    r'isSynced': PropertySchema(
      id: 13,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'isWifiVerified': PropertySchema(
      id: 14,
      name: r'isWifiVerified',
      type: IsarType.bool,
    ),
    r'lateMinutes': PropertySchema(
      id: 15,
      name: r'lateMinutes',
      type: IsarType.long,
    ),
    r'lateReason': PropertySchema(
      id: 16,
      name: r'lateReason',
      type: IsarType.string,
    ),
    r'locationId': PropertySchema(
      id: 17,
      name: r'locationId',
      type: IsarType.string,
    ),
    r'odId': PropertySchema(
      id: 18,
      name: r'odId',
      type: IsarType.string,
    ),
    r'outLat': PropertySchema(
      id: 19,
      name: r'outLat',
      type: IsarType.double,
    ),
    r'outLong': PropertySchema(
      id: 20,
      name: r'outLong',
      type: IsarType.double,
    ),
    r'overtimeMinutes': PropertySchema(
      id: 21,
      name: r'overtimeMinutes',
      type: IsarType.long,
    ),
    r'overtimeNote': PropertySchema(
      id: 22,
      name: r'overtimeNote',
      type: IsarType.string,
    ),
    r'photoLocalPath': PropertySchema(
      id: 23,
      name: r'photoLocalPath',
      type: IsarType.string,
    ),
    r'photoOutLocalPath': PropertySchema(
      id: 24,
      name: r'photoOutLocalPath',
      type: IsarType.string,
    ),
    r'photoOutServerUrl': PropertySchema(
      id: 25,
      name: r'photoOutServerUrl',
      type: IsarType.string,
    ),
    r'photoServerUrl': PropertySchema(
      id: 26,
      name: r'photoServerUrl',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 27,
      name: r'status',
      type: IsarType.string,
      enumMap: _AttendanceLocalstatusEnumValueMap,
    ),
    r'syncError': PropertySchema(
      id: 28,
      name: r'syncError',
      type: IsarType.string,
    ),
    r'syncRetryCount': PropertySchema(
      id: 29,
      name: r'syncRetryCount',
      type: IsarType.long,
    ),
    r'syncedAt': PropertySchema(
      id: 30,
      name: r'syncedAt',
      type: IsarType.dateTime,
    ),
    r'updatedAt': PropertySchema(
      id: 31,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'userId': PropertySchema(
      id: 32,
      name: r'userId',
      type: IsarType.string,
    ),
    r'wifiBssidUsed': PropertySchema(
      id: 33,
      name: r'wifiBssidUsed',
      type: IsarType.string,
    ),
    r'wifiSsidName': PropertySchema(
      id: 34,
      name: r'wifiSsidName',
      type: IsarType.string,
    )
  },
  estimateSize: _attendanceLocalEstimateSize,
  serialize: _attendanceLocalSerialize,
  deserialize: _attendanceLocalDeserialize,
  deserializeProp: _attendanceLocalDeserializeProp,
  idName: r'id',
  indexes: {
    r'userId': IndexSchema(
      id: -2005826577402374815,
      name: r'userId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'checkInTime': IndexSchema(
      id: 1992443686853293017,
      name: r'checkInTime',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'checkInTime',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'isOfflineEntry': IndexSchema(
      id: -9136629162410727079,
      name: r'isOfflineEntry',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isOfflineEntry',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'isSynced': IndexSchema(
      id: -39763503327887510,
      name: r'isSynced',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isSynced',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _attendanceLocalGetId,
  getLinks: _attendanceLocalGetLinks,
  attach: _attendanceLocalAttach,
  version: '3.1.0+1',
);

int _attendanceLocalEstimateSize(
  AttendanceLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.deviceIdUsed.length * 3;
  {
    final value = object.ganasNotes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lateReason;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.locationId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.odId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.overtimeNote;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.photoLocalPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.photoOutLocalPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.photoOutServerUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.photoServerUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.status.name.length * 3;
  {
    final value = object.syncError;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.userId.length * 3;
  {
    final value = object.wifiBssidUsed;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.wifiSsidName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _attendanceLocalSerialize(
  AttendanceLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.checkInTime);
  writer.writeDateTime(offsets[1], object.checkOutTime);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.deviceIdUsed);
  writer.writeString(offsets[4], object.ganasNotes);
  writer.writeDouble(offsets[5], object.gpsAccuracy);
  writer.writeDouble(offsets[6], object.gpsLat);
  writer.writeDouble(offsets[7], object.gpsLong);
  writer.writeBool(offsets[8], object.isGanas);
  writer.writeBool(offsets[9], object.isGanasApproved);
  writer.writeBool(offsets[10], object.isOfflineEntry);
  writer.writeBool(offsets[11], object.isOvertime);
  writer.writeBool(offsets[12], object.isOvertimeApproved);
  writer.writeBool(offsets[13], object.isSynced);
  writer.writeBool(offsets[14], object.isWifiVerified);
  writer.writeLong(offsets[15], object.lateMinutes);
  writer.writeString(offsets[16], object.lateReason);
  writer.writeString(offsets[17], object.locationId);
  writer.writeString(offsets[18], object.odId);
  writer.writeDouble(offsets[19], object.outLat);
  writer.writeDouble(offsets[20], object.outLong);
  writer.writeLong(offsets[21], object.overtimeMinutes);
  writer.writeString(offsets[22], object.overtimeNote);
  writer.writeString(offsets[23], object.photoLocalPath);
  writer.writeString(offsets[24], object.photoOutLocalPath);
  writer.writeString(offsets[25], object.photoOutServerUrl);
  writer.writeString(offsets[26], object.photoServerUrl);
  writer.writeString(offsets[27], object.status.name);
  writer.writeString(offsets[28], object.syncError);
  writer.writeLong(offsets[29], object.syncRetryCount);
  writer.writeDateTime(offsets[30], object.syncedAt);
  writer.writeDateTime(offsets[31], object.updatedAt);
  writer.writeString(offsets[32], object.userId);
  writer.writeString(offsets[33], object.wifiBssidUsed);
  writer.writeString(offsets[34], object.wifiSsidName);
}

AttendanceLocal _attendanceLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AttendanceLocal();
  object.checkInTime = reader.readDateTime(offsets[0]);
  object.checkOutTime = reader.readDateTimeOrNull(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.deviceIdUsed = reader.readString(offsets[3]);
  object.ganasNotes = reader.readStringOrNull(offsets[4]);
  object.gpsAccuracy = reader.readDoubleOrNull(offsets[5]);
  object.gpsLat = reader.readDoubleOrNull(offsets[6]);
  object.gpsLong = reader.readDoubleOrNull(offsets[7]);
  object.id = id;
  object.isGanas = reader.readBool(offsets[8]);
  object.isGanasApproved = reader.readBool(offsets[9]);
  object.isOfflineEntry = reader.readBool(offsets[10]);
  object.isOvertime = reader.readBool(offsets[11]);
  object.isOvertimeApproved = reader.readBool(offsets[12]);
  object.isSynced = reader.readBool(offsets[13]);
  object.isWifiVerified = reader.readBool(offsets[14]);
  object.lateMinutes = reader.readLongOrNull(offsets[15]);
  object.lateReason = reader.readStringOrNull(offsets[16]);
  object.locationId = reader.readStringOrNull(offsets[17]);
  object.odId = reader.readStringOrNull(offsets[18]);
  object.outLat = reader.readDoubleOrNull(offsets[19]);
  object.outLong = reader.readDoubleOrNull(offsets[20]);
  object.overtimeMinutes = reader.readLongOrNull(offsets[21]);
  object.overtimeNote = reader.readStringOrNull(offsets[22]);
  object.photoLocalPath = reader.readStringOrNull(offsets[23]);
  object.photoOutLocalPath = reader.readStringOrNull(offsets[24]);
  object.photoOutServerUrl = reader.readStringOrNull(offsets[25]);
  object.photoServerUrl = reader.readStringOrNull(offsets[26]);
  object.status = _AttendanceLocalstatusValueEnumMap[
          reader.readStringOrNull(offsets[27])] ??
      AttendanceStatus.present;
  object.syncError = reader.readStringOrNull(offsets[28]);
  object.syncRetryCount = reader.readLong(offsets[29]);
  object.syncedAt = reader.readDateTimeOrNull(offsets[30]);
  object.updatedAt = reader.readDateTimeOrNull(offsets[31]);
  object.userId = reader.readString(offsets[32]);
  object.wifiBssidUsed = reader.readStringOrNull(offsets[33]);
  object.wifiSsidName = reader.readStringOrNull(offsets[34]);
  return object;
}

P _attendanceLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDoubleOrNull(offset)) as P;
    case 6:
      return (reader.readDoubleOrNull(offset)) as P;
    case 7:
      return (reader.readDoubleOrNull(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readBool(offset)) as P;
    case 14:
      return (reader.readBool(offset)) as P;
    case 15:
      return (reader.readLongOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readDoubleOrNull(offset)) as P;
    case 20:
      return (reader.readDoubleOrNull(offset)) as P;
    case 21:
      return (reader.readLongOrNull(offset)) as P;
    case 22:
      return (reader.readStringOrNull(offset)) as P;
    case 23:
      return (reader.readStringOrNull(offset)) as P;
    case 24:
      return (reader.readStringOrNull(offset)) as P;
    case 25:
      return (reader.readStringOrNull(offset)) as P;
    case 26:
      return (reader.readStringOrNull(offset)) as P;
    case 27:
      return (_AttendanceLocalstatusValueEnumMap[
              reader.readStringOrNull(offset)] ??
          AttendanceStatus.present) as P;
    case 28:
      return (reader.readStringOrNull(offset)) as P;
    case 29:
      return (reader.readLong(offset)) as P;
    case 30:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 31:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 32:
      return (reader.readString(offset)) as P;
    case 33:
      return (reader.readStringOrNull(offset)) as P;
    case 34:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _AttendanceLocalstatusEnumValueMap = {
  r'present': r'present',
  r'late': r'late',
  r'absent': r'absent',
  r'leave': r'leave',
  r'halfDay': r'halfDay',
  r'pendingReview': r'pendingReview',
};
const _AttendanceLocalstatusValueEnumMap = {
  r'present': AttendanceStatus.present,
  r'late': AttendanceStatus.late,
  r'absent': AttendanceStatus.absent,
  r'leave': AttendanceStatus.leave,
  r'halfDay': AttendanceStatus.halfDay,
  r'pendingReview': AttendanceStatus.pendingReview,
};

Id _attendanceLocalGetId(AttendanceLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _attendanceLocalGetLinks(AttendanceLocal object) {
  return [];
}

void _attendanceLocalAttach(
    IsarCollection<dynamic> col, Id id, AttendanceLocal object) {
  object.id = id;
}

extension AttendanceLocalQueryWhereSort
    on QueryBuilder<AttendanceLocal, AttendanceLocal, QWhere> {
  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterWhere> anyCheckInTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'checkInTime'),
      );
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterWhere>
      anyIsOfflineEntry() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isOfflineEntry'),
      );
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterWhere> anyIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isSynced'),
      );
    });
  }
}

extension AttendanceLocalQueryWhere
    on QueryBuilder<AttendanceLocal, AttendanceLocal, QWhereClause> {
  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterWhereClause>
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

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterWhereClause> idBetween(
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

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterWhereClause>
      userIdEqualTo(String userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterWhereClause>
      userIdNotEqualTo(String userId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterWhereClause>
      checkInTimeEqualTo(DateTime checkInTime) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'checkInTime',
        value: [checkInTime],
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterWhereClause>
      checkInTimeNotEqualTo(DateTime checkInTime) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'checkInTime',
              lower: [],
              upper: [checkInTime],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'checkInTime',
              lower: [checkInTime],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'checkInTime',
              lower: [checkInTime],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'checkInTime',
              lower: [],
              upper: [checkInTime],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterWhereClause>
      checkInTimeGreaterThan(
    DateTime checkInTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'checkInTime',
        lower: [checkInTime],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterWhereClause>
      checkInTimeLessThan(
    DateTime checkInTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'checkInTime',
        lower: [],
        upper: [checkInTime],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterWhereClause>
      checkInTimeBetween(
    DateTime lowerCheckInTime,
    DateTime upperCheckInTime, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'checkInTime',
        lower: [lowerCheckInTime],
        includeLower: includeLower,
        upper: [upperCheckInTime],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterWhereClause>
      isOfflineEntryEqualTo(bool isOfflineEntry) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isOfflineEntry',
        value: [isOfflineEntry],
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterWhereClause>
      isOfflineEntryNotEqualTo(bool isOfflineEntry) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isOfflineEntry',
              lower: [],
              upper: [isOfflineEntry],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isOfflineEntry',
              lower: [isOfflineEntry],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isOfflineEntry',
              lower: [isOfflineEntry],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isOfflineEntry',
              lower: [],
              upper: [isOfflineEntry],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterWhereClause>
      isSyncedEqualTo(bool isSynced) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isSynced',
        value: [isSynced],
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterWhereClause>
      isSyncedNotEqualTo(bool isSynced) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSynced',
              lower: [],
              upper: [isSynced],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSynced',
              lower: [isSynced],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSynced',
              lower: [isSynced],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSynced',
              lower: [],
              upper: [isSynced],
              includeUpper: false,
            ));
      }
    });
  }
}

extension AttendanceLocalQueryFilter
    on QueryBuilder<AttendanceLocal, AttendanceLocal, QFilterCondition> {
  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      checkInTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checkInTime',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      checkInTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'checkInTime',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      checkInTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'checkInTime',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      checkInTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'checkInTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      checkOutTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'checkOutTime',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      checkOutTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'checkOutTime',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      checkOutTimeEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checkOutTime',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      checkOutTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'checkOutTime',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      checkOutTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'checkOutTime',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      checkOutTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'checkOutTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
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

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
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

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
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

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      deviceIdUsedEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceIdUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      deviceIdUsedGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deviceIdUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      deviceIdUsedLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deviceIdUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      deviceIdUsedBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deviceIdUsed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      deviceIdUsedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'deviceIdUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      deviceIdUsedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'deviceIdUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      deviceIdUsedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'deviceIdUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      deviceIdUsedMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'deviceIdUsed',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      deviceIdUsedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceIdUsed',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      deviceIdUsedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'deviceIdUsed',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      ganasNotesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ganasNotes',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      ganasNotesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ganasNotes',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      ganasNotesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ganasNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      ganasNotesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ganasNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      ganasNotesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ganasNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      ganasNotesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ganasNotes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      ganasNotesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ganasNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      ganasNotesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ganasNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      ganasNotesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ganasNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      ganasNotesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ganasNotes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      ganasNotesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ganasNotes',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      ganasNotesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ganasNotes',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      gpsAccuracyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'gpsAccuracy',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      gpsAccuracyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'gpsAccuracy',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      gpsAccuracyEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gpsAccuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      gpsAccuracyGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gpsAccuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      gpsAccuracyLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gpsAccuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      gpsAccuracyBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gpsAccuracy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      gpsLatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'gpsLat',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      gpsLatIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'gpsLat',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      gpsLatEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gpsLat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      gpsLatGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gpsLat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      gpsLatLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gpsLat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      gpsLatBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gpsLat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      gpsLongIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'gpsLong',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      gpsLongIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'gpsLong',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      gpsLongEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gpsLong',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      gpsLongGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gpsLong',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      gpsLongLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gpsLong',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      gpsLongBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gpsLong',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
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

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
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

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
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

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      isGanasEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isGanas',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      isGanasApprovedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isGanasApproved',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      isOfflineEntryEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isOfflineEntry',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      isOvertimeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isOvertime',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      isOvertimeApprovedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isOvertimeApproved',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      isWifiVerifiedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isWifiVerified',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      lateMinutesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lateMinutes',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      lateMinutesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lateMinutes',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      lateMinutesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lateMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      lateMinutesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lateMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      lateMinutesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lateMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      lateMinutesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lateMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      lateReasonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lateReason',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      lateReasonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lateReason',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      lateReasonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lateReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      lateReasonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lateReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      lateReasonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lateReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      lateReasonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lateReason',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      lateReasonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lateReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      lateReasonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lateReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      lateReasonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lateReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      lateReasonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lateReason',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      lateReasonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lateReason',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      lateReasonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lateReason',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      locationIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'locationId',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      locationIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'locationId',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      locationIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'locationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      locationIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'locationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      locationIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'locationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      locationIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'locationId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      locationIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'locationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      locationIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'locationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      locationIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'locationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      locationIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'locationId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      locationIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'locationId',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      locationIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'locationId',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      odIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'odId',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      odIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'odId',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
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

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
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

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
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

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
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

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
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

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
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

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      odIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'odId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      odIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'odId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      odIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'odId',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      odIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'odId',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      outLatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'outLat',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      outLatIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'outLat',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      outLatEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'outLat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      outLatGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'outLat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      outLatLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'outLat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      outLatBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'outLat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      outLongIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'outLong',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      outLongIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'outLong',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      outLongEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'outLong',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      outLongGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'outLong',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      outLongLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'outLong',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      outLongBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'outLong',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      overtimeMinutesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'overtimeMinutes',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      overtimeMinutesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'overtimeMinutes',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      overtimeMinutesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'overtimeMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      overtimeMinutesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'overtimeMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      overtimeMinutesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'overtimeMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      overtimeMinutesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'overtimeMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      overtimeNoteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'overtimeNote',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      overtimeNoteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'overtimeNote',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      overtimeNoteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'overtimeNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      overtimeNoteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'overtimeNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      overtimeNoteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'overtimeNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      overtimeNoteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'overtimeNote',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      overtimeNoteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'overtimeNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      overtimeNoteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'overtimeNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      overtimeNoteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'overtimeNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      overtimeNoteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'overtimeNote',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      overtimeNoteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'overtimeNote',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      overtimeNoteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'overtimeNote',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoLocalPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'photoLocalPath',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoLocalPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'photoLocalPath',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoLocalPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'photoLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoLocalPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'photoLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoLocalPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'photoLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoLocalPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'photoLocalPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoLocalPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'photoLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoLocalPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'photoLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoLocalPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'photoLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoLocalPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'photoLocalPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoLocalPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'photoLocalPath',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoLocalPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'photoLocalPath',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoOutLocalPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'photoOutLocalPath',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoOutLocalPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'photoOutLocalPath',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoOutLocalPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'photoOutLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoOutLocalPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'photoOutLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoOutLocalPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'photoOutLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoOutLocalPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'photoOutLocalPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoOutLocalPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'photoOutLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoOutLocalPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'photoOutLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoOutLocalPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'photoOutLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoOutLocalPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'photoOutLocalPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoOutLocalPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'photoOutLocalPath',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoOutLocalPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'photoOutLocalPath',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoOutServerUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'photoOutServerUrl',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoOutServerUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'photoOutServerUrl',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoOutServerUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'photoOutServerUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoOutServerUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'photoOutServerUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoOutServerUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'photoOutServerUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoOutServerUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'photoOutServerUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoOutServerUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'photoOutServerUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoOutServerUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'photoOutServerUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoOutServerUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'photoOutServerUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoOutServerUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'photoOutServerUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoOutServerUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'photoOutServerUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoOutServerUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'photoOutServerUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoServerUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'photoServerUrl',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoServerUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'photoServerUrl',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoServerUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'photoServerUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoServerUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'photoServerUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoServerUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'photoServerUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoServerUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'photoServerUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoServerUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'photoServerUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoServerUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'photoServerUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoServerUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'photoServerUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoServerUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'photoServerUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoServerUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'photoServerUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      photoServerUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'photoServerUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      statusEqualTo(
    AttendanceStatus value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      statusGreaterThan(
    AttendanceStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      statusLessThan(
    AttendanceStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      statusBetween(
    AttendanceStatus lower,
    AttendanceStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      syncErrorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'syncError',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      syncErrorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'syncError',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      syncErrorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      syncErrorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      syncErrorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      syncErrorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncError',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      syncErrorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'syncError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      syncErrorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'syncError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      syncErrorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'syncError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      syncErrorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'syncError',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      syncErrorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncError',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      syncErrorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'syncError',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      syncRetryCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncRetryCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      syncRetryCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncRetryCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      syncRetryCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncRetryCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      syncRetryCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncRetryCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      syncedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'syncedAt',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      syncedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'syncedAt',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      syncedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      syncedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      syncedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      syncedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
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

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
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

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
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

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      userIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      userIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      userIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      wifiBssidUsedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'wifiBssidUsed',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      wifiBssidUsedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'wifiBssidUsed',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      wifiBssidUsedEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wifiBssidUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      wifiBssidUsedGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wifiBssidUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      wifiBssidUsedLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wifiBssidUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      wifiBssidUsedBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wifiBssidUsed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      wifiBssidUsedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'wifiBssidUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      wifiBssidUsedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'wifiBssidUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      wifiBssidUsedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'wifiBssidUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      wifiBssidUsedMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'wifiBssidUsed',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      wifiBssidUsedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wifiBssidUsed',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      wifiBssidUsedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'wifiBssidUsed',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      wifiSsidNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'wifiSsidName',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      wifiSsidNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'wifiSsidName',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      wifiSsidNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wifiSsidName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      wifiSsidNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wifiSsidName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      wifiSsidNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wifiSsidName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      wifiSsidNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wifiSsidName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      wifiSsidNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'wifiSsidName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      wifiSsidNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'wifiSsidName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      wifiSsidNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'wifiSsidName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      wifiSsidNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'wifiSsidName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      wifiSsidNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wifiSsidName',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterFilterCondition>
      wifiSsidNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'wifiSsidName',
        value: '',
      ));
    });
  }
}

extension AttendanceLocalQueryObject
    on QueryBuilder<AttendanceLocal, AttendanceLocal, QFilterCondition> {}

extension AttendanceLocalQueryLinks
    on QueryBuilder<AttendanceLocal, AttendanceLocal, QFilterCondition> {}

extension AttendanceLocalQuerySortBy
    on QueryBuilder<AttendanceLocal, AttendanceLocal, QSortBy> {
  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByCheckInTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkInTime', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByCheckInTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkInTime', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByCheckOutTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkOutTime', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByCheckOutTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkOutTime', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByDeviceIdUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceIdUsed', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByDeviceIdUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceIdUsed', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByGanasNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ganasNotes', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByGanasNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ganasNotes', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByGpsAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gpsAccuracy', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByGpsAccuracyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gpsAccuracy', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy> sortByGpsLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gpsLat', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByGpsLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gpsLat', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy> sortByGpsLong() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gpsLong', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByGpsLongDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gpsLong', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy> sortByIsGanas() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGanas', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByIsGanasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGanas', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByIsGanasApproved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGanasApproved', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByIsGanasApprovedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGanasApproved', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByIsOfflineEntry() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOfflineEntry', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByIsOfflineEntryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOfflineEntry', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByIsOvertime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOvertime', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByIsOvertimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOvertime', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByIsOvertimeApproved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOvertimeApproved', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByIsOvertimeApprovedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOvertimeApproved', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByIsWifiVerified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWifiVerified', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByIsWifiVerifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWifiVerified', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByLateMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lateMinutes', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByLateMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lateMinutes', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByLateReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lateReason', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByLateReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lateReason', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByLocationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationId', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByLocationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationId', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy> sortByOdId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'odId', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByOdIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'odId', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy> sortByOutLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outLat', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByOutLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outLat', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy> sortByOutLong() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outLong', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByOutLongDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outLong', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByOvertimeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overtimeMinutes', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByOvertimeMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overtimeMinutes', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByOvertimeNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overtimeNote', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByOvertimeNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overtimeNote', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByPhotoLocalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoLocalPath', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByPhotoLocalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoLocalPath', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByPhotoOutLocalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoOutLocalPath', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByPhotoOutLocalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoOutLocalPath', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByPhotoOutServerUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoOutServerUrl', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByPhotoOutServerUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoOutServerUrl', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByPhotoServerUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoServerUrl', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByPhotoServerUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoServerUrl', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortBySyncError() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncError', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortBySyncErrorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncError', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortBySyncRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncRetryCount', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortBySyncRetryCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncRetryCount', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortBySyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByWifiBssidUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wifiBssidUsed', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByWifiBssidUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wifiBssidUsed', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByWifiSsidName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wifiSsidName', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      sortByWifiSsidNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wifiSsidName', Sort.desc);
    });
  }
}

extension AttendanceLocalQuerySortThenBy
    on QueryBuilder<AttendanceLocal, AttendanceLocal, QSortThenBy> {
  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByCheckInTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkInTime', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByCheckInTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkInTime', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByCheckOutTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkOutTime', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByCheckOutTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkOutTime', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByDeviceIdUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceIdUsed', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByDeviceIdUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceIdUsed', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByGanasNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ganasNotes', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByGanasNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ganasNotes', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByGpsAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gpsAccuracy', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByGpsAccuracyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gpsAccuracy', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy> thenByGpsLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gpsLat', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByGpsLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gpsLat', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy> thenByGpsLong() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gpsLong', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByGpsLongDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gpsLong', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy> thenByIsGanas() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGanas', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByIsGanasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGanas', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByIsGanasApproved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGanasApproved', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByIsGanasApprovedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGanasApproved', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByIsOfflineEntry() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOfflineEntry', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByIsOfflineEntryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOfflineEntry', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByIsOvertime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOvertime', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByIsOvertimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOvertime', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByIsOvertimeApproved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOvertimeApproved', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByIsOvertimeApprovedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOvertimeApproved', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByIsWifiVerified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWifiVerified', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByIsWifiVerifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWifiVerified', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByLateMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lateMinutes', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByLateMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lateMinutes', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByLateReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lateReason', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByLateReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lateReason', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByLocationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationId', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByLocationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationId', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy> thenByOdId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'odId', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByOdIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'odId', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy> thenByOutLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outLat', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByOutLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outLat', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy> thenByOutLong() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outLong', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByOutLongDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outLong', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByOvertimeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overtimeMinutes', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByOvertimeMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overtimeMinutes', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByOvertimeNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overtimeNote', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByOvertimeNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overtimeNote', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByPhotoLocalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoLocalPath', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByPhotoLocalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoLocalPath', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByPhotoOutLocalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoOutLocalPath', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByPhotoOutLocalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoOutLocalPath', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByPhotoOutServerUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoOutServerUrl', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByPhotoOutServerUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoOutServerUrl', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByPhotoServerUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoServerUrl', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByPhotoServerUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoServerUrl', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenBySyncError() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncError', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenBySyncErrorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncError', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenBySyncRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncRetryCount', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenBySyncRetryCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncRetryCount', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenBySyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByWifiBssidUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wifiBssidUsed', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByWifiBssidUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wifiBssidUsed', Sort.desc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByWifiSsidName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wifiSsidName', Sort.asc);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QAfterSortBy>
      thenByWifiSsidNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wifiSsidName', Sort.desc);
    });
  }
}

extension AttendanceLocalQueryWhereDistinct
    on QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct> {
  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct>
      distinctByCheckInTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checkInTime');
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct>
      distinctByCheckOutTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checkOutTime');
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct>
      distinctByDeviceIdUsed({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deviceIdUsed', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct>
      distinctByGanasNotes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ganasNotes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct>
      distinctByGpsAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gpsAccuracy');
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct> distinctByGpsLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gpsLat');
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct>
      distinctByGpsLong() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gpsLong');
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct>
      distinctByIsGanas() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isGanas');
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct>
      distinctByIsGanasApproved() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isGanasApproved');
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct>
      distinctByIsOfflineEntry() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isOfflineEntry');
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct>
      distinctByIsOvertime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isOvertime');
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct>
      distinctByIsOvertimeApproved() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isOvertimeApproved');
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct>
      distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct>
      distinctByIsWifiVerified() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isWifiVerified');
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct>
      distinctByLateMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lateMinutes');
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct>
      distinctByLateReason({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lateReason', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct>
      distinctByLocationId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'locationId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct> distinctByOdId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'odId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct> distinctByOutLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'outLat');
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct>
      distinctByOutLong() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'outLong');
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct>
      distinctByOvertimeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'overtimeMinutes');
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct>
      distinctByOvertimeNote({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'overtimeNote', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct>
      distinctByPhotoLocalPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'photoLocalPath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct>
      distinctByPhotoOutLocalPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'photoOutLocalPath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct>
      distinctByPhotoOutServerUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'photoOutServerUrl',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct>
      distinctByPhotoServerUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'photoServerUrl',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct> distinctBySyncError(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncError', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct>
      distinctBySyncRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncRetryCount');
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct>
      distinctBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncedAt');
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct>
      distinctByWifiBssidUsed({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wifiBssidUsed',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceLocal, QDistinct>
      distinctByWifiSsidName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wifiSsidName', caseSensitive: caseSensitive);
    });
  }
}

extension AttendanceLocalQueryProperty
    on QueryBuilder<AttendanceLocal, AttendanceLocal, QQueryProperty> {
  QueryBuilder<AttendanceLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AttendanceLocal, DateTime, QQueryOperations>
      checkInTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checkInTime');
    });
  }

  QueryBuilder<AttendanceLocal, DateTime?, QQueryOperations>
      checkOutTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checkOutTime');
    });
  }

  QueryBuilder<AttendanceLocal, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<AttendanceLocal, String, QQueryOperations>
      deviceIdUsedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deviceIdUsed');
    });
  }

  QueryBuilder<AttendanceLocal, String?, QQueryOperations>
      ganasNotesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ganasNotes');
    });
  }

  QueryBuilder<AttendanceLocal, double?, QQueryOperations>
      gpsAccuracyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gpsAccuracy');
    });
  }

  QueryBuilder<AttendanceLocal, double?, QQueryOperations> gpsLatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gpsLat');
    });
  }

  QueryBuilder<AttendanceLocal, double?, QQueryOperations> gpsLongProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gpsLong');
    });
  }

  QueryBuilder<AttendanceLocal, bool, QQueryOperations> isGanasProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isGanas');
    });
  }

  QueryBuilder<AttendanceLocal, bool, QQueryOperations>
      isGanasApprovedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isGanasApproved');
    });
  }

  QueryBuilder<AttendanceLocal, bool, QQueryOperations>
      isOfflineEntryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isOfflineEntry');
    });
  }

  QueryBuilder<AttendanceLocal, bool, QQueryOperations> isOvertimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isOvertime');
    });
  }

  QueryBuilder<AttendanceLocal, bool, QQueryOperations>
      isOvertimeApprovedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isOvertimeApproved');
    });
  }

  QueryBuilder<AttendanceLocal, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<AttendanceLocal, bool, QQueryOperations>
      isWifiVerifiedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isWifiVerified');
    });
  }

  QueryBuilder<AttendanceLocal, int?, QQueryOperations> lateMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lateMinutes');
    });
  }

  QueryBuilder<AttendanceLocal, String?, QQueryOperations>
      lateReasonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lateReason');
    });
  }

  QueryBuilder<AttendanceLocal, String?, QQueryOperations>
      locationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'locationId');
    });
  }

  QueryBuilder<AttendanceLocal, String?, QQueryOperations> odIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'odId');
    });
  }

  QueryBuilder<AttendanceLocal, double?, QQueryOperations> outLatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'outLat');
    });
  }

  QueryBuilder<AttendanceLocal, double?, QQueryOperations> outLongProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'outLong');
    });
  }

  QueryBuilder<AttendanceLocal, int?, QQueryOperations>
      overtimeMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'overtimeMinutes');
    });
  }

  QueryBuilder<AttendanceLocal, String?, QQueryOperations>
      overtimeNoteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'overtimeNote');
    });
  }

  QueryBuilder<AttendanceLocal, String?, QQueryOperations>
      photoLocalPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'photoLocalPath');
    });
  }

  QueryBuilder<AttendanceLocal, String?, QQueryOperations>
      photoOutLocalPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'photoOutLocalPath');
    });
  }

  QueryBuilder<AttendanceLocal, String?, QQueryOperations>
      photoOutServerUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'photoOutServerUrl');
    });
  }

  QueryBuilder<AttendanceLocal, String?, QQueryOperations>
      photoServerUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'photoServerUrl');
    });
  }

  QueryBuilder<AttendanceLocal, AttendanceStatus, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<AttendanceLocal, String?, QQueryOperations> syncErrorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncError');
    });
  }

  QueryBuilder<AttendanceLocal, int, QQueryOperations>
      syncRetryCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncRetryCount');
    });
  }

  QueryBuilder<AttendanceLocal, DateTime?, QQueryOperations>
      syncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncedAt');
    });
  }

  QueryBuilder<AttendanceLocal, DateTime?, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<AttendanceLocal, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }

  QueryBuilder<AttendanceLocal, String?, QQueryOperations>
      wifiBssidUsedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wifiBssidUsed');
    });
  }

  QueryBuilder<AttendanceLocal, String?, QQueryOperations>
      wifiSsidNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wifiSsidName');
    });
  }
}
