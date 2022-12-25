import 'package:auto_animated/auto_animated.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_par/data/entities/task_with_category_entity.dart';
import 'package:task_par/logic/blocs/task/task_bloc.dart';
import 'package:task_par/presentation/routes/argument_bundle.dart';
import 'package:task_par/presentation/utils/app_theme.dart';
import 'package:task_par/presentation/utils/constants.dart';
import 'package:task_par/presentation/utils/extensions.dart';
import 'package:task_par/presentation/utils/helper.dart';
import 'package:task_par/presentation/widgets/state_widgets.dart';
import 'package:task_par/presentation/widgets/task_item_widget.dart';
import 'package:task_par/presentation/widgets/wide_app_bar.dart';

class OnGoingCompletePage extends StatefulWidget {
  final ArgumentBundle bundle;

  const OnGoingCompletePage({Key? key, required this.bundle}) : super(key: key);

  @override
  _OnGoingCompletePageState createState() => _OnGoingCompletePageState();
}

class _OnGoingCompletePageState extends State<OnGoingCompletePage> {
  late StatusType statusType = widget.bundle.extras[Keys.statusType];
  late String title =
      statusType == StatusType.ON_GOING ? 'در حال انجام' : 'انجام شده';
  LinearGradient randomGradient =
      LinearGradient(colors: []).randomGradientColor;

  ValueNotifier<int> totalTasks = ValueNotifier(0);

  @override
  void initState() {
    context.read<TaskBloc>().add(WatchTaskByStatus(statusType: statusType));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: () {
          Helper.showBottomSheet(
            context,
          );
        },
      ),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          WideAppBar(
            tag: statusType.toString(),
            title: title,
            gradient: statusType == StatusType.ON_GOING
                ? AppTheme.orange.withOpacity(0.8)
                : AppTheme.green.withOpacity(0.8),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
                SizedBox(
                  height: 56,
                ),
                Column(
                  children: [
                    Text(
                      'تسک های $title من',
                      style: AppTheme.headline1.withWhite,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    ValueListenableBuilder<int>(
                        valueListenable: totalTasks,
                        builder: (context, value, child) {
                          return Text(
                            'تعدادشون $value',
                            style: AppTheme.text1.withWhite,
                          );
                        }),
                  ],
                ),
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
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (snapshot.hasData) {
                    totalTasks.value =
                        snapshot.data!.taskWithCategoryList.length;
                  }
                });
                if (snapshot.hasError) {
                  return FailureWidget(message: snapshot.stackTrace.toString());
                } else if (!snapshot.hasData) {
                  return LoadingWidget();
                } else if (snapshot.data!.taskWithCategoryList.isEmpty) {
                  return EmptyWidget();
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 64),
                  child: taskListView(snapshot.data!),
                );
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
}
