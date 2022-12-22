
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shamsi_date/extensions.dart';
import 'package:task_par/data/entities/task_category_entity.dart';
import 'package:task_par/data/entities/task_entity.dart';
import 'package:task_par/presentation/utils/app_theme.dart';
import 'package:task_par/presentation/utils/helper.dart';

class TaskItemWidget extends StatelessWidget {
  final TaskItemEntity task;
  final TaskCategoryItemEntity category;
  final Animation<double> animation;
  final Function(String)? onSelectedPopUp;
  final List<String>? itemPopUp;
  final void Function()? onTapCard;

  const TaskItemWidget({
    Key? key,
    required this.task,
    required this.category,
    required this.animation,
    this.onSelectedPopUp,
    this.itemPopUp,
    this.onTapCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0,
        end: 1,
      ).animate(animation),
      child: GestureDetector(
        onTap: onTapCard,
        child: Container(
          // padding: EdgeInsets.all(24),
          margin: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            // color: Colors.orange.shade300,
            color: Colors.white,
            boxShadow: AppTheme.getShadow(category.backgroundColor),
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
                      child: Text(task.title,
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
                      if (task.description.isNotEmpty) ...[
                        SizedBox(
                          height: 8,
                        ),
                        Text(task.description,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.text4),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              color: task.deadline == null ? Colors.red : null),
                          SizedBox(width: 8),
                          Text(
                              task.deadline != null
                                  ? Helper.formatDataJalaliHeader(
                                      task.deadline!.toJalali())
                                  : 'بدون ددلاین !',
                              style: AppTheme.text3.copyWith(
                                  color: task.deadline == null
                                      ? Colors.red
                                      : null)),
                          SizedBox(
                            width: 20,
                          ),
                          if (task.deadline != null)
                            Text(
                              '${task.deadline!.minute} : ${task.deadline!.hour} ',
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
                              color: category.backgroundColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(category.title, style: AppTheme.text3),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: (task.isCompleted
                                      ? AppTheme.greenPastel
                                      : AppTheme.yellowOrange)
                                  .withOpacity(0.6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                                task.isCompleted ? 'انجام شده' : 'در حال انجام',
                                style: AppTheme.text3),
                          ),
                          Spacer(),
                          Icon(
                            IconData(category.icon.icon!.codePoint,
                                fontFamily: 'MaterialIcons'),
                            color: category.backgroundColor,
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
        onSelected: onSelectedPopUp,
        itemBuilder: (context) => itemPopUp!
            .map((e) => PopupMenuItem<String>(
                  value: e,
                  child: Text(
                    e,
                    style: TextStyle(color: e == 'حذف' ? Colors.red : null),
                  ),
                ))
            .toList(),
      );
}
