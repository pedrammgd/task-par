import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:shamsi_date/extensions.dart';
import 'package:task_par/data/entities/task_category_entity.dart';
import 'package:task_par/data/entities/task_entity.dart';
import 'package:task_par/data/entities/task_with_category_entity.dart';
import 'package:task_par/logic/blocs/task/task_bloc.dart';
import 'package:task_par/logic/blocs/task_category/task_category_bloc.dart';
import 'package:task_par/presentation/utils/app_theme.dart';
import 'package:task_par/presentation/utils/helper.dart';
import 'package:task_par/presentation/widgets/state_widgets.dart';
import 'package:task_par/presentation/widgets/task_sheet.dart';

class TaskItemWidget extends StatefulWidget {
  final TaskItemEntity task;
  final TaskCategoryItemEntity category;
  final Animation<double> animation;

  // final List<String>? itemPopUp;

  const TaskItemWidget({
    Key? key,
    required this.task,
    required this.category,
    required this.animation,
    // this.itemPopUp,
  }) : super(key: key);

  @override
  State<TaskItemWidget> createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends State<TaskItemWidget> {
  @override
  Widget build(BuildContext context) {
    final brightness =
        ThemeData.estimateBrightnessForColor(widget.category.backgroundColor);
    final backColorBri =
        brightness == Brightness.light ? Colors.black : Colors.white;
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0,
        end: 1,
      ).animate(widget.animation),
      child: GestureDetector(
        onTap: () => _onTapCard(widget.task, widget.category),
        child: Container(
          // padding: EdgeInsets.all(24),
          margin: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            // color: Colors.orange.shade300,
            color: Colors.white,
            boxShadow: AppTheme.getShadow(widget.category.backgroundColor),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 24, 0),
                      child: Text(widget.task.title,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.headline4),
                    )),
                    // Padding(
                    //   padding: const EdgeInsets.all(12.0),
                    //   child: Icon(Icons.more_vert),
                    // )
                    _morePopup()
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (widget.task.description.isNotEmpty) ...[
                        SizedBox(
                          height: 8,
                        ),
                        Text(widget.task.description,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.text4),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              color: widget.task.deadline == null
                                  ? Colors.red
                                  : null),
                          SizedBox(width: 8),
                          Text(
                              widget.task.deadline != null
                                  ? Helper.formatDataJalaliHeader(
                                      widget.task.deadline!.toJalali())
                                  : 'بدون ددلاین !',
                              style: AppTheme.text3.copyWith(
                                  color: widget.task.deadline == null
                                      ? Colors.red
                                      : null)),
                          SizedBox(
                            width: 20,
                          ),
                          if (widget.task.deadline != null)
                            Text(
                              '${widget.task.deadline!.minute} : ${widget.task.deadline!.hour} ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: widget.category.backgroundColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(widget.category.title,
                                style: AppTheme.text3
                                    .copyWith(color: backColorBri)),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: (widget.task.isCompleted
                                      ? AppTheme.greenPastel
                                      : AppTheme.yellowOrange)
                                  .withOpacity(0.6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                                widget.task.isCompleted
                                    ? 'انجام شده'
                                    : 'در حال انجام',
                                style: AppTheme.text3),
                          ),
                          Spacer(),
                          Icon(
                            IconData(widget.category.icon.icon!.codePoint,
                                fontFamily: 'MaterialIcons'),
                            color: widget.category.backgroundColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _morePopup() => PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, size: 22),
        iconSize: 20,
        elevation: 10,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
        onSelected: (value) {
          switch (value) {
            case 'ویرایش':
              _onTapCard(widget.task, widget.category);
              break;
            case 'حذف':
              _deleteTask(widget.task, widget.category);
              break;

            case 'انتقال به انجام شده ها':
              completeOrInProgressTask(widget.task, true);
              break;
            case 'بازگشت به در حال انجام':
              completeOrInProgressTask(widget.task, false);
              break;
          }
        },
        itemBuilder: (context) => [
          'ویرایش',
          'حذف',
          widget.task.isCompleted
              ? 'بازگشت به در حال انجام'
              : 'انتقال به انجام شده ها',
        ]
            .map((e) => PopupMenuItem<String>(
                  value: e,
                  child: Text(
                    e,
                    style: TextStyle(color: e == 'حذف' ? Colors.red : null),
                  ),
                ))
            .toList(),
      );

  void _onTapCard(TaskItemEntity task, TaskCategoryItemEntity category) {
    context.read<TaskCategoryBloc>().add(GetTaskCategory());
    showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      enableDrag: true,
      topRadius: Radius.circular(20),
      backgroundColor: Colors.transparent,
      builder: (context) => TaskSheet(
          isEditing: true,
          task: TaskWithCategoryItemEntity(
            taskItemEntity: task,
            taskCategoryItemEntity: category,
          )),
    );
  }

  void _deleteTask(
      TaskItemEntity task, TaskCategoryItemEntity taskCategoryItemEntity) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("حذف تسک", style: AppTheme.headline3),
            Icon(
                IconData(taskCategoryItemEntity.icon.icon!.codePoint,
                    fontFamily: 'MaterialIcons'),
                color: taskCategoryItemEntity.backgroundColor),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GarbageWidget(),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'آیا از حذف',
                  style: AppTheme.text1,
                ),
                Flexible(
                  child: Text(
                    ' ${task.title}',
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.text1.copyWith(color: Colors.red),
                  ),
                ),
                Text(
                  ' مطمعن هستید',
                  style: AppTheme.text1,
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'بیخیال',
                style: AppTheme.text1,
              )),
          TextButton(
            onPressed: () {
              context.read<TaskBloc>().add(DeleteTask(id: task.id!));
              Helper.showCustomSnackBar(
                context,
                content: ' تسک ${task.title} با موفقیت حذف شد ',
              );
              Navigator.pop(context);
            },
            child: Text(
              'حذف',
              style: AppTheme.text1.copyWith(color: Colors.red),
            ),
          ),
        ],
        insetPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
      ),
    ).then((isDelete) {
      if (isDelete != null && isDelete) {
        Navigator.pop(context);
      }
    });
  }

  void completeOrInProgressTask(TaskItemEntity taskItem, bool isCompleted) {
    TaskItemEntity taskItemEntity = TaskItemEntity(
      id: taskItem.id,
      title: taskItem.title,
      description: taskItem.description,
      categoryId: taskItem.categoryId,
      isCompleted: isCompleted,
    );
    if (taskItem.deadline != null) {
      final DateTime savedDeadline = DateTime(
        taskItem.deadline!.year,
        taskItem.deadline!.month,
        taskItem.deadline!.day,
        taskItem.deadline != null
            ? taskItem.deadline!.hour
            : DateTime.now().hour,
        taskItem.deadline != null
            ? taskItem.deadline!.minute
            : DateTime.now().minute,
      );

      taskItemEntity = TaskItemEntity(
        id: taskItem.id,
        title: taskItem.title,
        description: taskItem.description,
        categoryId: taskItem.categoryId,
        deadline: savedDeadline.toLocal(),
        isCompleted: isCompleted,
      );
    }
    context.read<TaskBloc>().add(UpdateTask(taskItemEntity: taskItemEntity));
    Helper.showCustomSnackBar(
      context,
      content: isCompleted ? 'انتقال به انجام شده' : 'بازگشت به درحال انجام',
    );
  }
}
