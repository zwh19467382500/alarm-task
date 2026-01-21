// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_node_regist.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTimeNodeRegistCollection on Isar {
  IsarCollection<TimeNodeRegist> get timeNodeRegists => this.collection();
}

const TimeNodeRegistSchema = CollectionSchema(
  name: r'TimeNodeRegist',
  id: 8347813377513197295,
  properties: {
    r'alarmSystemId': PropertySchema(
      id: 0,
      name: r'alarmSystemId',
      type: IsarType.long,
    ),
    r'exactDateTime': PropertySchema(
      id: 1,
      name: r'exactDateTime',
      type: IsarType.dateTime,
    ),
    r'isHead': PropertySchema(id: 2, name: r'isHead', type: IsarType.bool),
    r'sort': PropertySchema(id: 3, name: r'sort', type: IsarType.long),
  },

  estimateSize: _timeNodeRegistEstimateSize,
  serialize: _timeNodeRegistSerialize,
  deserialize: _timeNodeRegistDeserialize,
  deserializeProp: _timeNodeRegistDeserializeProp,
  idName: r'id',
  indexes: {
    r'alarmSystemId': IndexSchema(
      id: -9220406676414635346,
      name: r'alarmSystemId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'alarmSystemId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {
    r'alarmTask': LinkSchema(
      id: -5150628017241175405,
      name: r'alarmTask',
      target: r'AlarmTask',
      single: true,
    ),
  },
  embeddedSchemas: {},

  getId: _timeNodeRegistGetId,
  getLinks: _timeNodeRegistGetLinks,
  attach: _timeNodeRegistAttach,
  version: '3.3.0-dev.2',
);

int _timeNodeRegistEstimateSize(
  TimeNodeRegist object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _timeNodeRegistSerialize(
  TimeNodeRegist object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.alarmSystemId);
  writer.writeDateTime(offsets[1], object.exactDateTime);
  writer.writeBool(offsets[2], object.isHead);
  writer.writeLong(offsets[3], object.sort);
}

TimeNodeRegist _timeNodeRegistDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TimeNodeRegist(
    alarmSystemId: reader.readLongOrNull(offsets[0]) ?? 0,
    exactDateTime: reader.readDateTime(offsets[1]),
    isHead: reader.readBool(offsets[2]),
    sort: reader.readLong(offsets[3]),
  );
  object.id = id;
  return object;
}

P _timeNodeRegistDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _timeNodeRegistGetId(TimeNodeRegist object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _timeNodeRegistGetLinks(TimeNodeRegist object) {
  return [object.alarmTask];
}

void _timeNodeRegistAttach(
  IsarCollection<dynamic> col,
  Id id,
  TimeNodeRegist object,
) {
  object.id = id;
  object.alarmTask.attach(
    col,
    col.isar.collection<AlarmTask>(),
    r'alarmTask',
    id,
  );
}

extension TimeNodeRegistQueryWhereSort
    on QueryBuilder<TimeNodeRegist, TimeNodeRegist, QWhere> {
  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterWhere> anyAlarmSystemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'alarmSystemId'),
      );
    });
  }
}

extension TimeNodeRegistQueryWhere
    on QueryBuilder<TimeNodeRegist, TimeNodeRegist, QWhereClause> {
  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterWhereClause>
  alarmSystemIdEqualTo(int alarmSystemId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'alarmSystemId',
          value: [alarmSystemId],
        ),
      );
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterWhereClause>
  alarmSystemIdNotEqualTo(int alarmSystemId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'alarmSystemId',
                lower: [],
                upper: [alarmSystemId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'alarmSystemId',
                lower: [alarmSystemId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'alarmSystemId',
                lower: [alarmSystemId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'alarmSystemId',
                lower: [],
                upper: [alarmSystemId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterWhereClause>
  alarmSystemIdGreaterThan(int alarmSystemId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'alarmSystemId',
          lower: [alarmSystemId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterWhereClause>
  alarmSystemIdLessThan(int alarmSystemId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'alarmSystemId',
          lower: [],
          upper: [alarmSystemId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterWhereClause>
  alarmSystemIdBetween(
    int lowerAlarmSystemId,
    int upperAlarmSystemId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'alarmSystemId',
          lower: [lowerAlarmSystemId],
          includeLower: includeLower,
          upper: [upperAlarmSystemId],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension TimeNodeRegistQueryFilter
    on QueryBuilder<TimeNodeRegist, TimeNodeRegist, QFilterCondition> {
  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterFilterCondition>
  alarmSystemIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'alarmSystemId', value: value),
      );
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterFilterCondition>
  alarmSystemIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'alarmSystemId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterFilterCondition>
  alarmSystemIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'alarmSystemId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterFilterCondition>
  alarmSystemIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'alarmSystemId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterFilterCondition>
  exactDateTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'exactDateTime', value: value),
      );
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterFilterCondition>
  exactDateTimeGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'exactDateTime',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterFilterCondition>
  exactDateTimeLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'exactDateTime',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterFilterCondition>
  exactDateTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'exactDateTime',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterFilterCondition>
  isHeadEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isHead', value: value),
      );
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterFilterCondition>
  sortEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sort', value: value),
      );
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterFilterCondition>
  sortGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sort',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterFilterCondition>
  sortLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sort',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterFilterCondition>
  sortBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sort',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension TimeNodeRegistQueryObject
    on QueryBuilder<TimeNodeRegist, TimeNodeRegist, QFilterCondition> {}

extension TimeNodeRegistQueryLinks
    on QueryBuilder<TimeNodeRegist, TimeNodeRegist, QFilterCondition> {
  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterFilterCondition> alarmTask(
    FilterQuery<AlarmTask> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'alarmTask');
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterFilterCondition>
  alarmTaskIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'alarmTask', 0, true, 0, true);
    });
  }
}

extension TimeNodeRegistQuerySortBy
    on QueryBuilder<TimeNodeRegist, TimeNodeRegist, QSortBy> {
  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterSortBy>
  sortByAlarmSystemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmSystemId', Sort.asc);
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterSortBy>
  sortByAlarmSystemIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmSystemId', Sort.desc);
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterSortBy>
  sortByExactDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exactDateTime', Sort.asc);
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterSortBy>
  sortByExactDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exactDateTime', Sort.desc);
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterSortBy> sortByIsHead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isHead', Sort.asc);
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterSortBy>
  sortByIsHeadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isHead', Sort.desc);
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterSortBy> sortBySort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sort', Sort.asc);
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterSortBy> sortBySortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sort', Sort.desc);
    });
  }
}

extension TimeNodeRegistQuerySortThenBy
    on QueryBuilder<TimeNodeRegist, TimeNodeRegist, QSortThenBy> {
  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterSortBy>
  thenByAlarmSystemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmSystemId', Sort.asc);
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterSortBy>
  thenByAlarmSystemIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmSystemId', Sort.desc);
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterSortBy>
  thenByExactDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exactDateTime', Sort.asc);
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterSortBy>
  thenByExactDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exactDateTime', Sort.desc);
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterSortBy> thenByIsHead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isHead', Sort.asc);
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterSortBy>
  thenByIsHeadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isHead', Sort.desc);
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterSortBy> thenBySort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sort', Sort.asc);
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QAfterSortBy> thenBySortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sort', Sort.desc);
    });
  }
}

extension TimeNodeRegistQueryWhereDistinct
    on QueryBuilder<TimeNodeRegist, TimeNodeRegist, QDistinct> {
  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QDistinct>
  distinctByAlarmSystemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'alarmSystemId');
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QDistinct>
  distinctByExactDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exactDateTime');
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QDistinct> distinctByIsHead() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isHead');
    });
  }

  QueryBuilder<TimeNodeRegist, TimeNodeRegist, QDistinct> distinctBySort() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sort');
    });
  }
}

extension TimeNodeRegistQueryProperty
    on QueryBuilder<TimeNodeRegist, TimeNodeRegist, QQueryProperty> {
  QueryBuilder<TimeNodeRegist, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TimeNodeRegist, int, QQueryOperations> alarmSystemIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'alarmSystemId');
    });
  }

  QueryBuilder<TimeNodeRegist, DateTime, QQueryOperations>
  exactDateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exactDateTime');
    });
  }

  QueryBuilder<TimeNodeRegist, bool, QQueryOperations> isHeadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isHead');
    });
  }

  QueryBuilder<TimeNodeRegist, int, QQueryOperations> sortProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sort');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeNodeRegist _$TimeNodeRegistFromJson(Map<String, dynamic> json) =>
    TimeNodeRegist(
      alarmSystemId: (json['alarmSystemId'] as num?)?.toInt() ?? 0,
      sort: (json['sort'] as num).toInt(),
      isHead: json['isHead'] as bool,
      exactDateTime: DateTime.parse(json['exactDateTime'] as String),
    )..id = (json['id'] as num).toInt();

Map<String, dynamic> _$TimeNodeRegistToJson(TimeNodeRegist instance) =>
    <String, dynamic>{
      'id': instance.id,
      'alarmSystemId': instance.alarmSystemId,
      'sort': instance.sort,
      'isHead': instance.isHead,
      'exactDateTime': instance.exactDateTime.toIso8601String(),
    };
