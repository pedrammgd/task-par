import 'package:flutter/material.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:task_par/data/data_providers/local/moor_database.dart';
import 'package:task_par/data/entities/category_total_tasks_entity.dart';
import 'package:task_par/data/entities/task_category_entity.dart';
import 'package:task_par/data/entities/task_entity.dart';
import 'package:task_par/data/entities/task_with_category_entity.dart';
import 'package:task_par/data/models/category_total_task.dart';
import 'package:task_par/data/models/task_with_category.dart';

class DataMapper {
  static TaskEntity toTaskEntity(List<Task> tasks) => TaskEntity(
      tasksList: tasks
          .map((item) => TaskItemEntity(
              id: item.id,
              categoryId: item.categoryId,
              title: item.title,
              description: item.description,
              deadline: item.deadline,
              isCompleted: item.isCompleted))
          .toList());

  static TaskItemEntity toTaskItemEntity(Task task) => TaskItemEntity(
      id: task.id,
      categoryId: task.categoryId,
      title: task.title,
      description: task.description,
      deadline: task.deadline,
      isCompleted: task.isCompleted);

  static TaskWithCategoryEntity toTaskWithCategoryEntity(
          List<TaskWithCategory> taskWithCategory) =>
      TaskWithCategoryEntity(
          taskWithCategoryList: taskWithCategory
              .map((item) => TaskWithCategoryItemEntity(
                  taskItemEntity: toTaskItemEntity(item.task),
                  taskCategoryItemEntity:
                      toTaskCategoryItemEntity(item.taskCategory)))
              .toList());

  static CategoryTotalTaskEntity toCategoryTotalTaskEntity(
          List<CategoryTotalTask> categoryTotalTasks) =>
      CategoryTotalTaskEntity(
          categoryTotalTaskList: categoryTotalTasks
              .map((item) => CategoryTotalTaskItemEntity(
                    taskCategoryItemEntity:
                        toTaskCategoryItemEntity(item.category),
                    totalTasks: item.totalTasks,
                  ))
              .toList());

  static TasksCompanion toTask(TaskItemEntity item) => TasksCompanion.insert(
        categoryId: item.categoryId,
        title: item.title,
        description: item.description,
        deadline: Value(item.deadline),
        isCompleted: item.isCompleted,
      );

  static TasksCompanion toUpdatedTask(TaskItemEntity item) =>
      TasksCompanion.insert(
        id: Value(item.id!),
        categoryId: item.categoryId,
        title: item.title,
        description: item.description,
        deadline: Value(item.deadline),
        isCompleted: item.isCompleted,
      );

  static TaskCategoryEntity toTaskCategoryEntity(
          List<TaskCategory> categories) =>
      TaskCategoryEntity(
        taskCategoryList: categories
            .map(
              (item) => TaskCategoryItemEntity(
                icon: Icon(IconData(item.icon, fontFamily: 'MaterialIcons')),
                backgroundColor: Color(item.backgroundColor),
                id: item.id,
                title: item.title,
                gradient: LinearGradient(
                  colors: [
                    Color(item.startColor),
                    Color(item.endColor),
                  ],
                ),
              ),
            )
            .toList(),
      );

  static TaskCategoryItemEntity toTaskCategoryItemEntity(
          TaskCategory category) =>
      TaskCategoryItemEntity(
        icon: Icon(IconData(category.icon, fontFamily: 'MaterialIcons')),
        backgroundColor: Color(category.backgroundColor),
        id: category.id,
        title: category.title,
        gradient: LinearGradient(
          colors: [
            Color(category.startColor),
            Color(category.endColor),
          ],
        ),
      );

  static TaskCategoriesCompanion toCategory(TaskCategoryItemEntity item) =>
      TaskCategoriesCompanion.insert(
        // id: Value(item.id!),
        icon: item.icon.icon!.codePoint,
        backgroundColor: item.backgroundColor.value,
        title: item.title,
        startColor: item.gradient.colors[0].value,
        endColor: item.gradient.colors[1].value,
      );

  static TaskCategoriesCompanion toUpdateCategory(
          TaskCategoryItemEntity item) =>
      TaskCategoriesCompanion.insert(
        id: Value(item.id!),
        icon: item.icon.icon!.codePoint,
        backgroundColor: item.backgroundColor.value,
        title: item.title,
        startColor: item.gradient.colors[0].value,
        endColor: item.gradient.colors[1].value,
      );
}
