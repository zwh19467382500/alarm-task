// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_task.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAlarmTaskCollection on Isar {
  IsarCollection<AlarmTask> get alarmTasks => this.collection();
}

const AlarmTaskSchema = CollectionSchema(
  name: r'AlarmTask',
  id: 68133149143179735,
  properties: {
    r'endTime': PropertySchema(id: 0, name: r'endTime', type: IsarType.string),
    r'isActive': PropertySchema(id: 1, name: r'isActive', type: IsarType.bool),
    r'relativeTimes': PropertySchema(
      id: 2,
      name: r'relativeTimes',
      type: IsarType.longList,
    ),
    r'scheduleType': PropertySchema(
      id: 3,
      name: r'scheduleType',
      type: IsarType.string,
    ),
    r'snoozeEnabled': PropertySchema(
      id: 4,
      name: r'snoozeEnabled',
      type: IsarType.bool,
    ),
    r'soundEnabled': PropertySchema(
      id: 5,
      name: r'soundEnabled',
      type: IsarType.bool,
    ),
    r'startTime': PropertySchema(
      id: 6,
      name: r'startTime',
      type: IsarType.string,
    ),
    r'timeInterval': PropertySchema(
      id: 7,
      name: r'timeInterval',
      type: IsarType.long,
    ),
    r'title': PropertySchema(id: 8, name: r'title', type: IsarType.string),
    r'type': PropertySchema(id: 9, name: r'type', type: IsarType.string),
    r'weekDays': PropertySchema(
      id: 10,
      name: r'weekDays',
      type: IsarType.longList,
    ),
  },

  estimateSize: _alarmTaskEstimateSize,
  serialize: _alarmTaskSerialize,
  deserialize: _alarmTaskDeserialize,
  deserializeProp: _alarmTaskDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'timeNodeRegists': LinkSchema(
      id: 3239624159071688976,
      name: r'timeNodeRegists',
      target: r'TimeNodeRegist',
      single: false,
      linkName: r'alarmTask',
    ),
  },
  embeddedSchemas: {},

  getId: _alarmTaskGetId,
  getLinks: _alarmTaskGetLinks,
  attach: _alarmTaskAttach,
  version: '3.3.0-dev.2',
);

int _alarmTaskEstimateSize(
  AlarmTask object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.endTime;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.relativeTimes.length * 8;
  {
    final value = object.scheduleType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.startTime;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.title;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.type;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.weekDays.length * 8;
  return bytesCount;
}

void _alarmTaskSerialize(
  AlarmTask object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.endTime);
  writer.writeBool(offsets[1], object.isActive);
  writer.writeLongList(offsets[2], object.relativeTimes);
  writer.writeString(offsets[3], object.scheduleType);
  writer.writeBool(offsets[4], object.snoozeEnabled);
  writer.writeBool(offsets[5], object.soundEnabled);
  writer.writeString(offsets[6], object.startTime);
  writer.writeLong(offsets[7], object.timeInterval);
  writer.writeString(offsets[8], object.title);
  writer.writeString(offsets[9], object.type);
  writer.writeLongList(offsets[10], object.weekDays);
}

AlarmTask _alarmTaskDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AlarmTask(
    endTime: reader.readStringOrNull(offsets[0]),
    isActive: reader.readBoolOrNull(offsets[1]) ?? true,
    relativeTimes: reader.readLongList(offsets[2]) ?? [],
    scheduleType: reader.readStringOrNull(offsets[3]),
    snoozeEnabled: reader.readBoolOrNull(offsets[4]) ?? false,
    soundEnabled: reader.readBoolOrNull(offsets[5]) ?? true,
    startTime: reader.readStringOrNull(offsets[6]),
    timeInterval: reader.readLongOrNull(offsets[7]),
    title: reader.readStringOrNull(offsets[8]),
    type: reader.readStringOrNull(offsets[9]),
    weekDays: reader.readLongList(offsets[10]) ?? [],
  );
  object.id = id;
  return object;
}

P _alarmTaskDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 2:
      return (reader.readLongList(offset) ?? []) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 5:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readLongList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _alarmTaskGetId(AlarmTask object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _alarmTaskGetLinks(AlarmTask object) {
  return [object.timeNodeRegists];
}

void _alarmTaskAttach(IsarCollection<dynamic> col, Id id, AlarmTask object) {
  object.id = id;
  object.timeNodeRegists.attach(
    col,
    col.isar.collection<TimeNodeRegist>(),
    r'timeNodeRegists',
    id,
  );
}

extension AlarmTaskQueryWhereSort
    on QueryBuilder<AlarmTask, AlarmTask, QWhere> {
  QueryBuilder<AlarmTask, AlarmTask, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AlarmTaskQueryWhere
    on QueryBuilder<AlarmTask, AlarmTask, QWhereClause> {
  QueryBuilder<AlarmTask, AlarmTask, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<AlarmTask, AlarmTask, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterWhereClause> idBetween(
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
}

extension AlarmTaskQueryFilter
    on QueryBuilder<AlarmTask, AlarmTask, QFilterCondition> {
  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> endTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'endTime'),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> endTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'endTime'),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> endTimeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'endTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> endTimeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'endTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> endTimeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'endTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> endTimeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'endTime',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> endTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'endTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> endTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'endTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> endTimeContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'endTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> endTimeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'endTime',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> endTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'endTime', value: ''),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  endTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'endTime', value: ''),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> idBetween(
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

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> isActiveEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isActive', value: value),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  relativeTimesElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'relativeTimes', value: value),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  relativeTimesElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'relativeTimes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  relativeTimesElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'relativeTimes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  relativeTimesElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'relativeTimes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  relativeTimesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'relativeTimes', length, true, length, true);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  relativeTimesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'relativeTimes', 0, true, 0, true);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  relativeTimesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'relativeTimes', 0, false, 999999, true);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  relativeTimesLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'relativeTimes', 0, true, length, include);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  relativeTimesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'relativeTimes', length, include, 999999, true);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  relativeTimesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'relativeTimes',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  scheduleTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'scheduleType'),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  scheduleTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'scheduleType'),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> scheduleTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'scheduleType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  scheduleTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'scheduleType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  scheduleTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'scheduleType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> scheduleTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'scheduleType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  scheduleTypeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'scheduleType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  scheduleTypeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'scheduleType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  scheduleTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'scheduleType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> scheduleTypeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'scheduleType',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  scheduleTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'scheduleType', value: ''),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  scheduleTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'scheduleType', value: ''),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  snoozeEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'snoozeEnabled', value: value),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> soundEnabledEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'soundEnabled', value: value),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> startTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'startTime'),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  startTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'startTime'),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> startTimeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'startTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  startTimeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> startTimeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> startTimeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startTime',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> startTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'startTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> startTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'startTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> startTimeContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'startTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> startTimeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'startTime',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> startTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startTime', value: ''),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  startTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'startTime', value: ''),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  timeIntervalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'timeInterval'),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  timeIntervalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'timeInterval'),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> timeIntervalEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'timeInterval', value: value),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  timeIntervalGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'timeInterval',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  timeIntervalLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'timeInterval',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> timeIntervalBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'timeInterval',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'title'),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'title'),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> titleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> titleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> titleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> titleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'title',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> titleContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> titleMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'title',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'type'),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> typeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'type'),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> typeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> typeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> typeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> typeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'type',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> typeContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> typeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'type',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'type', value: ''),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'type', value: ''),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  weekDaysElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'weekDays', value: value),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  weekDaysElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'weekDays',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  weekDaysElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'weekDays',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  weekDaysElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'weekDays',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  weekDaysLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'weekDays', length, true, length, true);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> weekDaysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'weekDays', 0, true, 0, true);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  weekDaysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'weekDays', 0, false, 999999, true);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  weekDaysLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'weekDays', 0, true, length, include);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  weekDaysLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'weekDays', length, include, 999999, true);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  weekDaysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekDays',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension AlarmTaskQueryObject
    on QueryBuilder<AlarmTask, AlarmTask, QFilterCondition> {}

extension AlarmTaskQueryLinks
    on QueryBuilder<AlarmTask, AlarmTask, QFilterCondition> {
  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition> timeNodeRegists(
    FilterQuery<TimeNodeRegist> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'timeNodeRegists');
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  timeNodeRegistsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'timeNodeRegists', length, true, length, true);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  timeNodeRegistsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'timeNodeRegists', 0, true, 0, true);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  timeNodeRegistsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'timeNodeRegists', 0, false, 999999, true);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  timeNodeRegistsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'timeNodeRegists', 0, true, length, include);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  timeNodeRegistsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
        r'timeNodeRegists',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterFilterCondition>
  timeNodeRegistsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
        r'timeNodeRegists',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension AlarmTaskQuerySortBy on QueryBuilder<AlarmTask, AlarmTask, QSortBy> {
  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> sortByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> sortByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> sortByScheduleType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleType', Sort.asc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> sortByScheduleTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleType', Sort.desc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> sortBySnoozeEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoozeEnabled', Sort.asc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> sortBySnoozeEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoozeEnabled', Sort.desc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> sortBySoundEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'soundEnabled', Sort.asc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> sortBySoundEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'soundEnabled', Sort.desc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> sortByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> sortByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> sortByTimeInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeInterval', Sort.asc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> sortByTimeIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeInterval', Sort.desc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension AlarmTaskQuerySortThenBy
    on QueryBuilder<AlarmTask, AlarmTask, QSortThenBy> {
  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> thenByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> thenByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> thenByScheduleType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleType', Sort.asc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> thenByScheduleTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleType', Sort.desc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> thenBySnoozeEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoozeEnabled', Sort.asc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> thenBySnoozeEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoozeEnabled', Sort.desc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> thenBySoundEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'soundEnabled', Sort.asc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> thenBySoundEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'soundEnabled', Sort.desc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> thenByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> thenByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> thenByTimeInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeInterval', Sort.asc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> thenByTimeIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeInterval', Sort.desc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension AlarmTaskQueryWhereDistinct
    on QueryBuilder<AlarmTask, AlarmTask, QDistinct> {
  QueryBuilder<AlarmTask, AlarmTask, QDistinct> distinctByEndTime({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endTime', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QDistinct> distinctByRelativeTimes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relativeTimes');
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QDistinct> distinctByScheduleType({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduleType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QDistinct> distinctBySnoozeEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'snoozeEnabled');
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QDistinct> distinctBySoundEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'soundEnabled');
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QDistinct> distinctByStartTime({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTime', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QDistinct> distinctByTimeInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeInterval');
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QDistinct> distinctByTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QDistinct> distinctByType({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AlarmTask, AlarmTask, QDistinct> distinctByWeekDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weekDays');
    });
  }
}

extension AlarmTaskQueryProperty
    on QueryBuilder<AlarmTask, AlarmTask, QQueryProperty> {
  QueryBuilder<AlarmTask, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AlarmTask, String?, QQueryOperations> endTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endTime');
    });
  }

  QueryBuilder<AlarmTask, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<AlarmTask, List<int>, QQueryOperations> relativeTimesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relativeTimes');
    });
  }

  QueryBuilder<AlarmTask, String?, QQueryOperations> scheduleTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduleType');
    });
  }

  QueryBuilder<AlarmTask, bool, QQueryOperations> snoozeEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'snoozeEnabled');
    });
  }

  QueryBuilder<AlarmTask, bool, QQueryOperations> soundEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'soundEnabled');
    });
  }

  QueryBuilder<AlarmTask, String?, QQueryOperations> startTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTime');
    });
  }

  QueryBuilder<AlarmTask, int?, QQueryOperations> timeIntervalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeInterval');
    });
  }

  QueryBuilder<AlarmTask, String?, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<AlarmTask, String?, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<AlarmTask, List<int>, QQueryOperations> weekDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weekDays');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlarmTask _$AlarmTaskFromJson(Map<String, dynamic> json) => AlarmTask(
  title: json['title'] as String?,
  type: json['type'] as String?,
  isActive: json['isActive'] as bool? ?? true,
  timeInterval: (json['timeInterval'] as num?)?.toInt(),
  snoozeEnabled: json['snoozeEnabled'] as bool? ?? false,
  soundEnabled: json['soundEnabled'] as bool? ?? true,
  scheduleType: json['scheduleType'] as String?,
  weekDays: (json['weekDays'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  startTime: json['startTime'] as String?,
  endTime: json['endTime'] as String?,
  relativeTimes: (json['relativeTimes'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
)..id = (json['id'] as num).toInt();

Map<String, dynamic> _$AlarmTaskToJson(AlarmTask instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'type': instance.type,
  'isActive': instance.isActive,
  'timeInterval': instance.timeInterval,
  'snoozeEnabled': instance.snoozeEnabled,
  'soundEnabled': instance.soundEnabled,
  'scheduleType': instance.scheduleType,
  'weekDays': instance.weekDays,
  'startTime': instance.startTime,
  'endTime': instance.endTime,
  'relativeTimes': instance.relativeTimes,
};
