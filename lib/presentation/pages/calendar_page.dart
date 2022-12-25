import 'package:auto_animated/auto_animated.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shamsi_date/extensions.dart';
import 'package:task_par/data/entities/task_with_category_entity.dart';
import 'package:task_par/logic/blocs/task/task_bloc.dart';
import 'package:task_par/presentation/utils/app_theme.dart';
import 'package:task_par/presentation/utils/helper.dart';
import 'package:task_par/presentation/widgets/jalali_table_widget/src/jalaliTableCalendar.dart';
import 'package:task_par/presentation/widgets/state_widgets.dart';
import 'package:task_par/presentation/widgets/task_item_widget.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime datePicked = DateTime.now();
  // Jalali datePicked = Jalali.now();
  final ValueNotifier<int> totalTask = ValueNotifier(0);

  @override
  void initState() {
    _getTaskByDate();
    super.initState();
  }

  _getTaskByDate() {
    context.read<TaskBloc>().add(WatchTaskByDate(dateTime: datePicked));
    // .add(WatchTaskByDate(dateTime: datePicked.toLocal()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _topBar(),
              SizedBox(height: 20),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Expanded(
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             // Text(
              //             //   datePicked.format(FormatDate.monthYear),
              //             //   style: AppTheme.headline2,
              //             // ),
              //             // SizedBox(height: 8),
              //             // ValueListenableBuilder<int>(
              //             //   valueListenable: totalTask,
              //             //   builder: (context, value, child) => Text(
              //             //     '$value تسک در ${Helper.formatDataJalaliHeader(datePicked.toJalali())}',
              //             //     style: AppTheme.text1,
              //             //   ),
              //             // ),
              //           ],
              //         ),
              //       ),
              //       RippleCircleButton(
              //         onTap: () async {
              //           _selectDate();
              //           // final picked = await Helper.showDeadlineDatePicker(
              //           //   context,
              //           //   datePicked,
              //           // );
              //           // if (picked != null && picked != datePicked) {
              //           //   setState(() {
              //           //     datePicked = picked;
              //           //     _getTaskByDate();
              //           //   });
              //           // }
              //         },
              //         child: SvgPicture.asset(Resources.date,
              //             color: Colors.white, width: 20),
              //       ),
              //     ],
              //   ),
              // ),
              JalaliTableCalendar(
                  initialTime: TimeOfDay.fromDateTime(datePicked),
                  // initialTime: ,
                  context: context,
                  // add the events for each day
                  events: {
                    datePicked: ['sample event', 66546],
                    // datePicked.add(Duration(days: 1)): [6, 5, 465, 1, 66546],
                    // datePicked.add(Duration(days: 2)): [6, 5, 465, 66546],
                  },
                  //make marker for every day that have some events
                  marker: (date, events) {
                    return ValueListenableBuilder<int>(
                      valueListenable: totalTask,
                      builder: (context, value, child) => value == 0
                          ? const SizedBox()
                          : Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.red[200],
                                    shape: BoxShape.circle),
                                padding: value >= 10
                                    ? const EdgeInsets.all(2.0)
                                    : const EdgeInsets.all(6.0),
                                child: Text(
                                    value >= 10 ? '<10' : value.toString()),

                                // Text((events?.length).toString()),
                              ),
                            ),
                    );
                  },
                  onDaySelected: (date) {
                    setState(() {
                      datePicked = date;
                      print(datePicked.toLocal());
                      _getTaskByDate();
                    });
                    print(date);
                  }),
              ValueListenableBuilder<int>(
                valueListenable: totalTask,
                builder: (context, value, child) => value == 0
                    ? SizedBox()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          '$value تسک در ${Helper.formatDataJalaliHeader(datePicked.toJalali())}',
                          style: AppTheme.text1,
                        ),
                      ),
              ),
              // EventCalendar(
              //   calendarType: CalendarType.JALALI,
              //   calendarLanguage: 'fa',
              //   calendarOptions: CalendarOptions(viewType: ViewType.DAILY),
              //   showEvents: false,
              //   eventOptions: EventOptions(),
              //   onChangeDateTime: (value) {
              //     print(value);
              //     setState(() {
              //       datePicked = value.toDateTime();
              //       print(datePicked.toLocal());
              //       _getTaskByDate();
              //     });
              //   },
              // ),
              // CalendarTimeline(
              //   initialDate: datePicked,
              //   firstDate: DateTime(2019, 1, 15),
              //   lastDate: DateTime(2025, 11, 20),
              //   onDateSelected: (date) {
              //     setState(() {
              //       datePicked = date!;
              //       print(datePicked.toLocal());
              //       _getTaskByDate();
              //     });
              //   },
              //   leftMargin: 20,
              //   monthColor: Colors.blueGrey,
              //   dayColor: Colors.teal[200],
              //   activeDayColor: Colors.white,
              //   activeBackgroundDayColor: Colors.redAccent[100],
              //   dotsColor: Color(0xFF333A47),
              //   locale: 'en_US',
              // ),
              _taskByDate(),
            ],
          ),
        ),
      ),
    );
  }

  // Future _selectDate() async {
  //   var picked = await jalaliCalendarPicker(
  //       convertToGregorian: true, context: context); // نمایش خروجی به صورت شمسی
  //   print(picked);
  //   // datePicked = picked;
  //
  //   //     _getTaskByDate();
  //   //  await jalaliCalendarPicker(context: context,convertToGregorian: true); // نمایش خروجی به صورت میلادی
  //   // if (picked != null) setState(() => datePicked = picked);
  //
  //   // DateTime j2dt = DateTime.parse(picked!).toDateTime();
  //   setState(() {
  //     datePicked = DateTime.parse(picked!);
  //     print(datePicked);
  //   });
  // }

  _topBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        'تقویم کارهام',
        style: AppTheme.headline3,
        textAlign: TextAlign.center,
      ),
    );
  }

  _taskByDate() {
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
                    totalTask.value =
                        snapshot.data!.taskWithCategoryList.length;
                  }
                });
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
      physics: BouncingScrollPhysics(),
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
