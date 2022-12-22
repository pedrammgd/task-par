
import 'package:flutter/material.dart';
import 'package:task_par/data/entities/task_category_entity.dart';
import 'package:task_par/presentation/utils/app_theme.dart';

class DummyData {
  static TaskCategoryEntity getTaskCategoryEntity() =>
      TaskCategoryEntity(taskCategoryList: [
        TaskCategoryItemEntity(
          backgroundColor: Colors.red,
          icon: Icon(Icons.pending),
          title: "On Going",
          gradient: AppTheme.blueGradient,
        ),
        TaskCategoryItemEntity(
          icon: Icon(Icons.done),
          backgroundColor: Colors.green,
          title: "Done",
          gradient: AppTheme.purpleGradient,
        ),
      ]);
}
