// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Task extends DataClass implements Insertable<Task> {
  final int id;
  final int categoryId;
  final String title;
  final String description;
  final DateTime? deadline;
  final bool isCompleted;
  Task(
      {required this.id,
      required this.categoryId,
      required this.title,
      required this.description,
      this.deadline,
      required this.isCompleted});
  factory Task.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Task(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      categoryId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}category_id'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      description: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}description'])!,
      deadline: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}deadline']),
      isCompleted: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_completed'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_id'] = Variable<int>(categoryId);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || deadline != null) {
      map['deadline'] = Variable<DateTime?>(deadline);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      title: Value(title),
      description: Value(description),
      deadline: deadline == null && nullToAbsent
          ? const Value.absent()
          : Value(deadline),
      isCompleted: Value(isCompleted),
    );
  }

  factory Task.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      deadline: serializer.fromJson<DateTime?>(json['deadline']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<int>(categoryId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'deadline': serializer.toJson<DateTime?>(deadline),
      'isCompleted': serializer.toJson<bool>(isCompleted),
    };
  }

  Task copyWith(
          {int? id,
          int? categoryId,
          String? title,
          String? description,
          DateTime? deadline,
          bool? isCompleted}) =>
      Task(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        title: title ?? this.title,
        description: description ?? this.description,
        deadline: deadline ?? this.deadline,
        isCompleted: isCompleted ?? this.isCompleted,
      );
  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('deadline: $deadline, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, categoryId, title, description, deadline, isCompleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.title == this.title &&
          other.description == this.description &&
          other.deadline == this.deadline &&
          other.isCompleted == this.isCompleted);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<int> id;
  final Value<int> categoryId;
  final Value<String> title;
  final Value<String> description;
  final Value<DateTime?> deadline;
  final Value<bool> isCompleted;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.deadline = const Value.absent(),
    this.isCompleted = const Value.absent(),
  });
  TasksCompanion.insert({
    this.id = const Value.absent(),
    required int categoryId,
    required String title,
    required String description,
    this.deadline = const Value.absent(),
    required bool isCompleted,
  })  : categoryId = Value(categoryId),
        title = Value(title),
        description = Value(description),
        isCompleted = Value(isCompleted);
  static Insertable<Task> custom({
    Expression<int>? id,
    Expression<int>? categoryId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime?>? deadline,
    Expression<bool>? isCompleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (deadline != null) 'deadline': deadline,
      if (isCompleted != null) 'is_completed': isCompleted,
    });
  }

  TasksCompanion copyWith(
      {Value<int>? id,
      Value<int>? categoryId,
      Value<String>? title,
      Value<String>? description,
      Value<DateTime?>? deadline,
      Value<bool>? isCompleted}) {
    return TasksCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<DateTime?>(deadline.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('deadline: $deadline, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _categoryIdMeta = const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int?> categoryId = GeneratedColumn<int?>(
      'category_id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String?> description = GeneratedColumn<String?>(
      'description', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _deadlineMeta = const VerificationMeta('deadline');
  @override
  late final GeneratedColumn<DateTime?> deadline = GeneratedColumn<DateTime?>(
      'deadline', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool?> isCompleted = GeneratedColumn<bool?>(
      'is_completed', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (is_completed IN (0, 1))');
  @override
  List<GeneratedColumn> get $columns =>
      [id, categoryId, title, description, deadline, isCompleted];
  @override
  String get aliasedName => _alias ?? 'tasks';
  @override
  String get actualTableName => 'tasks';
  @override
  VerificationContext validateIntegrity(Insertable<Task> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('deadline')) {
      context.handle(_deadlineMeta,
          deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta));
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    } else if (isInserting) {
      context.missing(_isCompletedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Task.fromData(data, attachedDatabase,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class TaskCategory extends DataClass implements Insertable<TaskCategory> {
  final int id;
  final String title;
  final int startColor;
  final int endColor;
  final int backgroundColor;
  final int icon;
  TaskCategory(
      {required this.id,
      required this.title,
      required this.startColor,
      required this.endColor,
      required this.backgroundColor,
      required this.icon});
  factory TaskCategory.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return TaskCategory(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      startColor: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}start_color'])!,
      endColor: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}end_color'])!,
      backgroundColor: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}background_color'])!,
      icon: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}icon'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['start_color'] = Variable<int>(startColor);
    map['end_color'] = Variable<int>(endColor);
    map['background_color'] = Variable<int>(backgroundColor);
    map['icon'] = Variable<int>(icon);
    return map;
  }

  TaskCategoriesCompanion toCompanion(bool nullToAbsent) {
    return TaskCategoriesCompanion(
      id: Value(id),
      title: Value(title),
      startColor: Value(startColor),
      endColor: Value(endColor),
      backgroundColor: Value(backgroundColor),
      icon: Value(icon),
    );
  }

  factory TaskCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return TaskCategory(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      startColor: serializer.fromJson<int>(json['startColor']),
      endColor: serializer.fromJson<int>(json['endColor']),
      backgroundColor: serializer.fromJson<int>(json['backgroundColor']),
      icon: serializer.fromJson<int>(json['icon']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'startColor': serializer.toJson<int>(startColor),
      'endColor': serializer.toJson<int>(endColor),
      'backgroundColor': serializer.toJson<int>(backgroundColor),
      'icon': serializer.toJson<int>(icon),
    };
  }

  TaskCategory copyWith(
          {int? id,
          String? title,
          int? startColor,
          int? endColor,
          int? backgroundColor,
          int? icon}) =>
      TaskCategory(
        id: id ?? this.id,
        title: title ?? this.title,
        startColor: startColor ?? this.startColor,
        endColor: endColor ?? this.endColor,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        icon: icon ?? this.icon,
      );
  @override
  String toString() {
    return (StringBuffer('TaskCategory(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('startColor: $startColor, ')
          ..write('endColor: $endColor, ')
          ..write('backgroundColor: $backgroundColor, ')
          ..write('icon: $icon')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, startColor, endColor, backgroundColor, icon);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskCategory &&
          other.id == this.id &&
          other.title == this.title &&
          other.startColor == this.startColor &&
          other.endColor == this.endColor &&
          other.backgroundColor == this.backgroundColor &&
          other.icon == this.icon);
}

class TaskCategoriesCompanion extends UpdateCompanion<TaskCategory> {
  final Value<int> id;
  final Value<String> title;
  final Value<int> startColor;
  final Value<int> endColor;
  final Value<int> backgroundColor;
  final Value<int> icon;
  const TaskCategoriesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.startColor = const Value.absent(),
    this.endColor = const Value.absent(),
    this.backgroundColor = const Value.absent(),
    this.icon = const Value.absent(),
  });
  TaskCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required int startColor,
    required int endColor,
    required int backgroundColor,
    required int icon,
  })  : title = Value(title),
        startColor = Value(startColor),
        endColor = Value(endColor),
        backgroundColor = Value(backgroundColor),
        icon = Value(icon);
  static Insertable<TaskCategory> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<int>? startColor,
    Expression<int>? endColor,
    Expression<int>? backgroundColor,
    Expression<int>? icon,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (startColor != null) 'start_color': startColor,
      if (endColor != null) 'end_color': endColor,
      if (backgroundColor != null) 'background_color': backgroundColor,
      if (icon != null) 'icon': icon,
    });
  }

  TaskCategoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<int>? startColor,
      Value<int>? endColor,
      Value<int>? backgroundColor,
      Value<int>? icon}) {
    return TaskCategoriesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      startColor: startColor ?? this.startColor,
      endColor: endColor ?? this.endColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      icon: icon ?? this.icon,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (startColor.present) {
      map['start_color'] = Variable<int>(startColor.value);
    }
    if (endColor.present) {
      map['end_color'] = Variable<int>(endColor.value);
    }
    if (backgroundColor.present) {
      map['background_color'] = Variable<int>(backgroundColor.value);
    }
    if (icon.present) {
      map['icon'] = Variable<int>(icon.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('startColor: $startColor, ')
          ..write('endColor: $endColor, ')
          ..write('backgroundColor: $backgroundColor, ')
          ..write('icon: $icon')
          ..write(')'))
        .toString();
  }
}

class $TaskCategoriesTable extends TaskCategories
    with TableInfo<$TaskCategoriesTable, TaskCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskCategoriesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _startColorMeta = const VerificationMeta('startColor');
  @override
  late final GeneratedColumn<int?> startColor = GeneratedColumn<int?>(
      'start_color', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _endColorMeta = const VerificationMeta('endColor');
  @override
  late final GeneratedColumn<int?> endColor = GeneratedColumn<int?>(
      'end_color', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _backgroundColorMeta =
      const VerificationMeta('backgroundColor');
  @override
  late final GeneratedColumn<int?> backgroundColor = GeneratedColumn<int?>(
      'background_color', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<int?> icon = GeneratedColumn<int?>(
      'icon', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, startColor, endColor, backgroundColor, icon];
  @override
  String get aliasedName => _alias ?? 'task_categories';
  @override
  String get actualTableName => 'task_categories';
  @override
  VerificationContext validateIntegrity(Insertable<TaskCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('start_color')) {
      context.handle(
          _startColorMeta,
          startColor.isAcceptableOrUnknown(
              data['start_color']!, _startColorMeta));
    } else if (isInserting) {
      context.missing(_startColorMeta);
    }
    if (data.containsKey('end_color')) {
      context.handle(_endColorMeta,
          endColor.isAcceptableOrUnknown(data['end_color']!, _endColorMeta));
    } else if (isInserting) {
      context.missing(_endColorMeta);
    }
    if (data.containsKey('background_color')) {
      context.handle(
          _backgroundColorMeta,
          backgroundColor.isAcceptableOrUnknown(
              data['background_color']!, _backgroundColorMeta));
    } else if (isInserting) {
      context.missing(_backgroundColorMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    return TaskCategory.fromData(data, attachedDatabase,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TaskCategoriesTable createAlias(String alias) {
    return $TaskCategoriesTable(attachedDatabase, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $TasksTable tasks = $TasksTable(this);
  late final $TaskCategoriesTable taskCategories = $TaskCategoriesTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [tasks, taskCategories];
}
