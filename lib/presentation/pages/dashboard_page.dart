import 'package:auto_animated/auto_animated.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:task_par/data/entities/category_total_tasks_entity.dart';
import 'package:task_par/data/entities/task_category_entity.dart';
import 'package:task_par/data/entities/task_with_category_entity.dart';
import 'package:task_par/logic/blocs/task/task_bloc.dart';
import 'package:task_par/logic/blocs/task_category/task_category_bloc.dart';
import 'package:task_par/presentation/routes/argument_bundle.dart';
import 'package:task_par/presentation/routes/page_path.dart';
import 'package:task_par/presentation/utils/utils.dart';
import 'package:task_par/presentation/widgets/category_sheet.dart';
import 'package:task_par/presentation/widgets/state_widgets.dart';
import 'package:task_par/presentation/widgets/task_item_widget.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late String avatar;
  late String myName;
  GetStorage getStorage = GetStorage();

  @override
  void initState() {
    // avatar = randomAvatarString(
    //   DateTime.now().toIso8601String(),
    //   trBackground: false,
    // );
    setAvatar();
    myName = getStorage.read(Keys.myNameKey) ?? '';

    setInitialCategory();
    context.read<TaskCategoryBloc>().add(WatchTaskCategory());
    context.read<TaskBloc>().add(WatchOnGoingTask());
    context.read<TaskBloc>().add(WatchCompletedTask());
    super.initState();
  }

  void setAvatar() {
    avatar = getStorage.read(Keys.avatarKey) ??
        randomAvatarString(
          DateTime.now().toIso8601String(),
        );
    getStorage.write(Keys.avatarKey, avatar);
  }

  void setInitialCategory() {
    bool isInitial = getStorage.read(Keys.isInitial) ?? true;
    if (isInitial) {
      getStorage.write(Keys.listTaskKey, []);
      context.read<TaskCategoryBloc>().add(InsertTaskCategory(
            taskCategoryItemEntity: TaskCategoryItemEntity(
                backgroundColor: Colors.deepOrange,
                title: "درسی",
                gradient: AppTheme.orangeGradient,
                icon: Icon(Icons.school_outlined)),
          ));
      context.read<TaskCategoryBloc>().add(InsertTaskCategory(
            taskCategoryItemEntity: TaskCategoryItemEntity(
                backgroundColor: Colors.black,
                title: "کار",
                gradient: AppTheme.toscaGradient,
                icon: Icon(Icons.work_outline)),
          ));
      context.read<TaskCategoryBloc>().add(InsertTaskCategory(
            taskCategoryItemEntity: TaskCategoryItemEntity(
                title: "سلامتی",
                gradient: AppTheme.purpleGradient,
                backgroundColor: Colors.blue,
                icon: Icon(Icons.health_and_safety_outlined)),
          ));

      getStorage.write(Keys.isInitial, false);
    }
  }

  _goToOnGoingPage() {
    Navigator.pushNamed(
      context,
      PagePath.onGoingComplete,
      arguments: ArgumentBundle(extras: {
        Keys.statusType: StatusType.ON_GOING,
      }, identifier: 'on going detail'),
    );
  }

  _goToCompletePage() {
    Navigator.pushNamed(
      context,
      PagePath.onGoingComplete,
      arguments: ArgumentBundle(extras: {
        Keys.statusType: StatusType.COMPLETE,
      }, identifier: 'complete detail'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child: Container(
            child: Column(
              children: [
                _avatar(),

                // _topBar(),
                _myTasks(),
                _onGoing(),
                _complete(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _avatar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Material(
            shape: CircleBorder(),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              radius: 28,
              onTap: () {
                setState(() {
                  avatar = randomAvatarString(
                    DateTime.now().toIso8601String(),
                  );
                  getStorage.write(Keys.avatarKey, avatar);
                });
              },
              child: CircleAvatar(
                radius: 28,
                child: SvgPicture.string(avatar),
              ),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ' سلام $myName 👋',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                Helper.formatDataJalaliHeader(Jalali.now()),
                // Jalali.now().formatter.date.toString(),
                // DateTime.now().format(FormatDate.monthDayYear),
                style: AppTheme.text3,
              ),
            ],
          ),
          Spacer(),
          Image.asset(
              width: 50,
              height: 50,
              fit: BoxFit.contain,
              loadSubscriptionWidget(
                  subscriptionData: getStorage.read(Keys.subscriptionKey) ??
                      'assets/img/coffee-cup.png')),
        ],
      ),
    );
  }

  String loadSubscriptionWidget({required String subscriptionData}) {
    if (subscriptionData == 'bronze_buy') {
      return 'assets/img/bronze-cup.png';
    } else if (subscriptionData == 'silver') {
      return 'assets/img/silver-cup.png';
    } else if (subscriptionData == 'gold') {
      return 'assets/img/gold_cup.png';
    } else {
      return 'assets/img/coffee-cup.png';
    }
  }

  _topBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateTime.now().format(FormatDate.monthDayYear),
            style: AppTheme.text1,
          ),
          SizedBox(width: 20),
          Expanded(
            child: Hero(
              tag: Keys.heroSearch,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.cornflowerBlue),
                ),
                padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Search Tasks here',
                        style: AppTheme.text3,
                      ),
                    ),
                    Icon(
                      Icons.search_rounded,
                      color: AppTheme.cornflowerBlue,
                    ),
                  ],
                ),
              ).addRipple(
                onTap: () => Navigator.pushNamed(context, PagePath.search),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _myTasks() {
    return
        // Padding(
        // padding: const EdgeInsets.symmetric(horizontal: 20),
        // child:
        // Column(
        // mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        // children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Text(
        //         'تسک هام',
        //         style: AppTheme.headline3,
        //         textAlign: TextAlign.start,
        //       ),
        //       TextButton(
        //         onPressed: () {
        //           showCupertinoModalBottomSheet(
        //             expand: false,
        //             context: context,
        //             enableDrag: true,
        //             topRadius: Radius.circular(20),
        //             backgroundColor: Colors.transparent,
        //             builder: (context) => Material(
        //               child: SafeArea(
        //                 top: false,
        //                 child: Column(
        //                   mainAxisSize: MainAxisSize.min,
        //                   children: [
        //                     SizedBox(
        //                       height: 300,
        //                       child: GridView.builder(
        //                         // physics: NeverScrollableScrollPhysics(),
        //                         shrinkWrap: true,
        //                         gridDelegate:
        //                             SliverGridDelegateWithFixedCrossAxisCount(
        //                                 crossAxisCount: 2),
        //                         itemBuilder: (context, index) {
        //                           return Text('pedram');
        //                         },
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           );
        //         },
        //         child: Text(
        //           'مشاهده همه',
        //           style: AppTheme.text3.withPink,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // SizedBox(height: 20),
        BlocBuilder<TaskCategoryBloc, TaskCategoryState>(
      buildWhen: (previous, current) {
        return current is TaskCategoryStream;
      },
      builder: (context, state) {
        if (state is TaskCategoryStream) {
          final entity = state.entity;
          return StreamBuilder<CategoryTotalTaskEntity>(
            stream: entity,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return FailureWidget(message: snapshot.stackTrace.toString());
              } else if (!snapshot.hasData) {
                return LoadingWidget();
              } else if (snapshot.data!.categoryTotalTaskList.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _addBorderButtonCategory(isEmpty: true),
                );
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'تسک هام',
                          style: AppTheme.headline3,
                          textAlign: TextAlign.start,
                        ),
                        if (snapshot.data!.categoryTotalTaskList.length > 4)
                          TextButton(
                            onPressed: () {
                              showCupertinoModalBottomSheet(
                                expand: false,
                                context: context,
                                enableDrag: true,
                                topRadius: Radius.circular(20),
                                backgroundColor: Colors.transparent,
                                builder: (context) => Material(
                                  child: SafeArea(
                                    top: false,
                                    child: Padding(
                                      padding:
                                          MediaQuery.of(context).viewInsets,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 5,
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            margin: EdgeInsets.all(10),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                1.3,
                                            child: GridView.builder(
                                              // physics: NeverScrollableScrollPhysics(),
                                              padding: EdgeInsets.all(5),
                                              shrinkWrap: true,
                                              itemCount: snapshot.data!
                                                  .categoryTotalTaskList.length,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2),
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: taskCategoryItemWidget(
                                                    snapshot
                                                        .data!
                                                        .categoryTotalTaskList[
                                                            index]
                                                        .taskCategoryItemEntity,
                                                    snapshot
                                                        .data!
                                                        .categoryTotalTaskList[
                                                            index]
                                                        .totalTasks,
                                                    index,
                                                    openFromDialog: true,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'مشاهده همه',
                              style: AppTheme.text3.withBlack
                                  .copyWith(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  taskCategoryListView(snapshot.data!),
                ],
              );
            },
          );
        }
        return EmptyWidget();
      },
      // )
      // ],
    );
  }

  Widget _onGoing() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Hero(
                tag: Keys.heroStatus + StatusType.ON_GOING.toString(),
                child: Text(
                  'در حال انجام',
                  style: AppTheme.headline3,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          BlocBuilder<TaskBloc, TaskState>(
            buildWhen: (previous, current) {
              return current is OnGoingTaskStream;
            },
            builder: (context, state) {
              if (state is OnGoingTaskStream) {
                final entity = state.entity;
                return StreamBuilder<TaskWithCategoryEntity>(
                  stream: entity,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return FailureWidget(
                          message: snapshot.stackTrace.toString());
                    } else if (!snapshot.hasData) {
                      return LoadingWidget();
                    } else if (snapshot.data!.taskWithCategoryList.isEmpty) {
                      return EmptyWidget();
                    }

                    return Column(
                      children: [
                        taskListView(snapshot.data!),
                        if (snapshot.data!.taskWithCategoryList.length > 3)
                          TextButton(
                            onPressed: _goToOnGoingPage,
                            child: Text(
                              'مشاهده همه',
                              style: AppTheme.text3.copyWith(
                                  color: AppTheme.orange.withOpacity(0.8)),
                            ),
                          ),
                      ],
                    );
                  },
                );
              }
              return EmptyWidget();
            },
          ),
        ],
      ),
    );
  }

  Widget _complete() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Hero(
                tag: Keys.heroStatus + StatusType.COMPLETE.toString(),
                child: Text(
                  'انجام شده',
                  style: AppTheme.headline3,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          BlocBuilder<TaskBloc, TaskState>(
            buildWhen: (previous, current) {
              return current is CompletedTaskStream;
            },
            builder: (context, state) {
              if (state is CompletedTaskStream) {
                final entity = state.entity;
                return StreamBuilder<TaskWithCategoryEntity>(
                  stream: entity,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return FailureWidget(
                          message: snapshot.stackTrace.toString());
                    } else if (!snapshot.hasData) {
                      return LoadingWidget();
                    } else if (snapshot.data!.taskWithCategoryList.isEmpty) {
                      return EmptyWidget();
                    }
                    return Column(
                      // mainAxisSize: MainAxisSize.min,
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        taskListView(snapshot.data!),
                        if (snapshot.data!.taskWithCategoryList.length > 3)
                          TextButton(
                            onPressed: _goToCompletePage,
                            child: Text(
                              'مشاهده همه',
                              style: AppTheme.text3.copyWith(
                                  color: AppTheme.green.withOpacity(0.8)),
                            ),
                          ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    );
                  },
                );
              }
              return EmptyWidget();
            },
          ),
        ],
      ),
    );
  }

  Widget taskCategoryListView(CategoryTotalTaskEntity data) {
    final dataList = data.categoryTotalTaskList;
    return SizedBox(
      height: 150,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        shrinkWrap: true,
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(
            // width: 300,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              clipBehavior: Clip.none,
              itemCount: dataList.length > 3 ? 4 : dataList.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final taskItem = dataList[index];
                return taskCategoryItemWidget(taskItem.taskCategoryItemEntity,
                    taskItem.totalTasks, index);
              },
            ),
          ),
          SizedBox(
            width: 8,
          ),
          _addBorderButtonCategory(),
          SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }

  Widget _addBorderButtonCategory({bool isEmpty = false}) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(16),
      // padding: EdgeInsets.all(6),
      // strokeCap: StrokeCap.butt,
      dashPattern: [8, 4],
      strokeWidth: 2,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        child: Container(
          width: isEmpty
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width / 2.5,
          padding: EdgeInsets.all(12),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'افزودن دسته بندی',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Icon(
              Icons.add,
              size: 28,
            ),
          ]),
        ).addRipple(
          onTap: () {
            _onTapAddOrEditCategory();
          },
        ),
      ),
    );
  }

  // Widget taskCategoryGridView(CategoryTotalTaskEntity data) {
  //   final dataList = data.categoryTotalTaskList;
  //   return StaggeredGridView.countBuilder(
  //     crossAxisCount: 4,
  //     shrinkWrap: true,
  //     physics: NeverScrollableScrollPhysics(),
  //     itemCount: dataList.length,
  //     itemBuilder: (BuildContext context, int index) {
  //       final taskItem = dataList[index];
  //       return taskCategoryItemWidget(
  //           taskItem.taskCategoryItemEntity, taskItem.totalTasks, index);
  //     },
  //     staggeredTileBuilder: (int index) =>
  //         StaggeredTile.count(2, index.isEven ? 2.4 : 1.8),
  //     mainAxisSpacing: 20,
  //     crossAxisSpacing: 20,
  //   );
  // }

  Widget taskCategoryItemWidget(
    TaskCategoryItemEntity categoryItem,
    int totalTasks,
    int index, {
    bool hasMore = false,
    bool openFromDialog = false,
  }) {
    final brightness =
        ThemeData.estimateBrightnessForColor(categoryItem.backgroundColor);
    final backColorBri =
        brightness == Brightness.light ? Colors.black : Colors.white;
    return Container(
      width: MediaQuery.of(context).size.width / 2.5,
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: categoryItem.backgroundColor,
        // gradient: categoryItem.gradient.withDiagonalGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.getShadow(categoryItem.backgroundColor),
      ),
      child: Stack(
        children: [
          if (hasMore)
            Positioned(
              top: 5,
              left: 5,
              child: PopupMenuButton<String>(
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
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: CircleAvatar(
                    radius: 25,
                    // backgroundColor: Colors.white,
                    backgroundColor: backColorBri,
                    child: Icon(
                      IconData(categoryItem.icon.icon!.codePoint,
                          fontFamily: 'MaterialIcons'),
                      color: categoryItem.backgroundColor,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          categoryItem.title,
                          style: AppTheme.headline3.withWhite
                              .copyWith(color: backColorBri),
                          // maxLines: index.isEven ? 3 : 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Card(
                      // radius: 25,
                      // backgroundColor: Colors.white,
                      Icon(
                        Icons.arrow_forward_ios, color: backColorBri,
                        // color: categoryItem.backgroundColor,
                        // ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  totalTasks == 0 ? 'بدون تسک' : '$totalTasks تسک ',
                  style: AppTheme.text1.withWhite.copyWith(color: backColorBri),
                ),
              ],
            ),
          ),
        ],
      ),
    ).addRipple(onTap: () {
      if (openFromDialog) Navigator.pop(context);
      Navigator.pushNamed(
        context,
        PagePath.detailCategory,
        arguments: ArgumentBundle(extras: {
          Keys.categoryItem: categoryItem,
          Keys.index: index,
        }, identifier: 'detail Category'),
      );
    });
  }

  Widget taskListView(TaskWithCategoryEntity data) {
    return LiveList.options(
      options: Helper.options,
      // itemCount: data.taskWithCategoryList.length,
      itemCount: data.taskWithCategoryList.length > 3
          ? 3
          : data.taskWithCategoryList.length,
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

  void _deleteCategory(
      {required TaskCategoryItemEntity taskCategoryItemEntity}) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("حذف دسته بندی", style: AppTheme.headline3),
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
                content:
                    ' دسته بندی ${taskCategoryItemEntity.title} حذف با موفقیت انجام شد ',
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
}
