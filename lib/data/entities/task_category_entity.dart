import 'package:flutter/material.dart';
import 'package:task_par/data/entities/entities.dart';

class TaskCategoryEntity extends BaseEntity {
  final List<TaskCategoryItemEntity> taskCategoryList;

  TaskCategoryEntity({required this.taskCategoryList});
}

class TaskCategoryItemEntity extends BaseEntity {
  final int? id;
  final String title;
  final LinearGradient gradient;
  final Color backgroundColor;
  final Icon icon;

  TaskCategoryItemEntity({
    this.id,
    required this.title,
    required this.gradient,
    required this.backgroundColor,
    required this.icon,
  });

  TaskCategoryItemEntity copyWith({
    int? id,
    String? title,
    LinearGradient? gradient,
    Color? backgroundColor,
    Icon? icon,
  }) {
    return TaskCategoryItemEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      gradient: gradient ?? this.gradient,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      icon: icon ?? this.icon,
    );
  }
}
