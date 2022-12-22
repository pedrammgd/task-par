import 'package:auto_animated/auto_animated.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:task_par/data/entities/task_category_entity.dart';
import 'package:task_par/data/entities/task_with_category_entity.dart';
import 'package:task_par/logic/blocs/task/task_bloc.dart';
import 'package:task_par/logic/blocs/task_category/task_category_bloc.dart';
import 'package:task_par/presentation/routes/argument_bundle.dart';
import 'package:task_par/presentation/utils/app_theme.dart';
import 'package:task_par/presentation/utils/constants.dart';
import 'package:task_par/presentation/utils/extensions.dart';
import 'package:task_par/presentation/utils/helper.dart';
import 'package:task_par/presentation/widgets/category_sheet.dart';
import 'package:task_par/presentation/widgets/custom_value_listenable_builder.dart';
import 'package:task_par/presentation/widgets/state_widgets.dart';
import 'package:task_par/presentation/widgets/task_item_widget.dart';
import 'package:task_par/presentation/widgets/wide_app_bar.dart';

class DetailCategoryTaskPage extends StatefulWidget {
  final ArgumentBundle bundle;

  const DetailCategoryTaskPage({Key? key, required this.bundle})
      : super(key: key);

  @override
  _DetailCategoryTaskPageState createState() => _DetailCategoryTaskPageState();
}

class _DetailCategoryTaskPageState extends State<DetailCategoryTaskPage> {
  late TaskCategoryItemEntity categoryItem =
      widget.bundle.extras[Keys.categoryItem];
  final ValueNotifier<int> totalTasks = ValueNotifier(0);
  final ValueNotifier<int> completeTasks = ValueNotifier(0);
  late int index = widget.bundle.extras[Keys.index];

  @override
  void initState() {
    context.read<TaskBloc>().add(WatchTaskByCategory(id: categoryItem.id!));
    super.initState();
  }

  double percent(int totalTasks, int completeTasks) {
    try {
      final percentValue = completeTasks / totalTasks;
      if (percentValue.isNaN || percentValue.isInfinite) {
        return 0.0;
      }
      return percentValue;
    } catch (_) {
      return 0.0;
    }
  }

  void setCompleteAndTotalValue(
      AsyncSnapshot<TaskWithCategoryEntity> snapshot) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (snapshot.hasData) {
        completeTasks.value = 0;
        totalTasks.value = 0;
        for (TaskWithCategoryItemEntity item
            in snapshot.data!.taskWithCategoryList) {
          if (item.taskCategoryItemEntity.id == categoryItem.id) {
            if (item.taskItemEntity.isCompleted == true) {
              completeTasks.value++;
            }
            totalTasks.value++;
          }
        }
      }
    });
  }

  @override
  void dispose() {
    completeTasks.value = 0;
    totalTasks.value = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness =
        ThemeData.estimateBrightnessForColor(categoryItem.backgroundColor);
    final backColorBri =
        brightness == Brightness.light ? Colors.black : Colors.white;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: () {
          Helper.showBottomSheet(
            context,
            categoryId: categoryItem.id!,
          );
        },
      ),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          WideAppBar(
            color: backColorBri,
            tag: index.toString(),
            title: categoryItem.title,
            actions: [
              if (categoryItem.id != 0 &&
                  categoryItem.id != 1 &&
                  categoryItem.id != 2)
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    size: 22,
                    color: backColorBri,
                  ),
                  iconSize: 20,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  onSelected: (value) {
                    if (value == 'ویرایش') {
                      _onTapAddOrEditCategory(
                          category: categoryItem, isEditing: true);
                    } else {
                      _deleteCategory(taskCategoryItemEntity: categoryItem);
                    }
                  },
                  itemBuilder: (context) => ['ویرایش', 'حذف']
                      .map((e) => PopupMenuItem<String>(
                            value: e,
                            child: Text(
                              e,
                              style: TextStyle(
                                  color: e == 'حذف' ? Colors.red : null),
                            ),
                          ))
                      .toList(),
                ),
            ],
            // gradient: categoryItem.backgroundColor,
            gradient: categoryItem.backgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
                SizedBox(
                  height: 12,
                ),
                ValueListenableBuilder2<int, int>(totalTasks, completeTasks,
                    builder: (context, totalTasks, completeTasks, child) {
                  return Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: LiquidCircularProgressIndicator(
                          value: percent(
                              totalTasks, completeTasks), // Defaults to 0.5.
                          valueColor: AlwaysStoppedAnimation(
                              categoryItem.backgroundColor.withOpacity(
                                  .8)), // Defaults to the current Theme's accentColor.
                          backgroundColor: Colors
                              .white, // Defaults to the current Theme's backgroundColor.
                          borderColor:
                              categoryItem.backgroundColor.withOpacity(.2),
                          borderWidth: 5.0,
                          direction: Axis
                              .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                          center: Text(
                              "${(percent(totalTasks, completeTasks) * 100).toInt()}%"),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Column(
                        children: [
                          Text(
                            'تسک های ${categoryItem.title}',
                            textAlign: TextAlign.center,
                            style: AppTheme.headline3.withWhite.copyWith(
                                color: backColorBri,
                                overflow: TextOverflow.ellipsis),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'تسک های تکمیل شده $completeTasks / $totalTasks',
                            style: AppTheme.text3.withWhite
                                .copyWith(color: backColorBri),
                          ),
                        ],
                      ),

                      // CircularPercentIndicator(
                      //   radius: 120.0,
                      //   lineWidth: 13.0,
                      //   animation: true,
                      //   percent: percent(totalTasks, completeTasks),
                      //   center: Text(
                      //     "${(percent(totalTasks, completeTasks) * 100).toInt()}%",
                      //     style: AppTheme.headline3.withBlack,
                      //   ),
                      //   curve: Curves.easeOutExpo,
                      //   animationDuration: 3000,
                      //   circularStrokeCap: CircularStrokeCap.round,
                      //   progressColor: AppTheme.boldColorFont,
                      //   backgroundColor: Colors.white,
                      // ),
                    ],
                  );
                }),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _taskList(),
            ]),
          ),
        ],
      ),
    );
  }

  _taskList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocBuilder<TaskBloc, TaskState>(
        buildWhen: (previous, current) {
          return current is TaskStream;
        },
        builder: (context, state) {
          if (state is TaskStream) {
            final entity = state.entity;
            return StreamBuilder<TaskWithCategoryEntity>(
              stream: entity,
              builder: (context, snapshot) {
                setCompleteAndTotalValue(snapshot);
                if (snapshot.hasError) {
                  return FailureWidget(message: snapshot.stackTrace.toString());
                } else if (!snapshot.hasData) {
                  return LoadingWidget();
                } else if (snapshot.data!.taskWithCategoryList.isEmpty) {
                  return EmptyWidget();
                } else {
                  return taskListView(snapshot.data!);
                }
              },
            );
          }
          return EmptyWidget();
        },
      ),
    );
  }

  Widget taskListView(TaskWithCategoryEntity data) {
    return LiveList.options(
      options: Helper.options,
      itemCount: data.taskWithCategoryList.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index, animation) {
        final item = data.taskWithCategoryList[index];
        return TaskItemWidget(
          task: item.taskItemEntity,
          category: item.taskCategoryItemEntity,
          animation: animation,
        );
      },
    );
  }

  void _deleteCategory(
      {required TaskCategoryItemEntity taskCategoryItemEntity}) {
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
                    ' ${taskCategoryItemEntity.title}',
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
              context
                  .read<TaskCategoryBloc>()
                  .add(DeleteTaskCategory(id: taskCategoryItemEntity.id!));
              Helper.showCustomSnackBar(
                context,
                content: 'حذف با موفقیت انجام شد',
                bgColor: AppTheme.redPastel.lighter(30),
              );
              Navigator.pop(context);
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

  void _onTapAddOrEditCategory(
      {TaskCategoryItemEntity? category, bool isEditing = false}) {
    // context.read<TaskCategoryBloc>().add(GetTaskCategory());
    showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      enableDrag: true,
      topRadius: Radius.circular(20),
      backgroundColor: Colors.transparent,
      builder: (context) => CategorySheet(
          // categoryId: category?.id,
          isEditing: isEditing,
          taskCategoryItem: category),
    );
  }
}
