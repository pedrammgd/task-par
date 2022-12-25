import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import 'package:task_par/data/entities/task_category_entity.dart';
import 'package:task_par/data/entities/task_entity.dart';
import 'package:task_par/data/entities/task_with_category_entity.dart';
import 'package:task_par/logic/blocs/task/task_bloc.dart';
import 'package:task_par/logic/blocs/task_category/task_category_bloc.dart';
import 'package:task_par/presentation/utils/app_theme.dart';
import 'package:task_par/presentation/utils/constants.dart';
import 'package:task_par/presentation/utils/extensions.dart';
import 'package:task_par/presentation/utils/helper.dart';
import 'package:shamsi_date/shamsi_date.dart' as shamsi;

import 'buttons.dart';
import 'state_widgets.dart';

class TaskSheet extends StatefulWidget {
  final TaskWithCategoryItemEntity? task;
  final int? categoryId;
  final bool isEditing;

  const TaskSheet(
      {Key? key, this.task, this.categoryId, this.isEditing = false})
      : super(key: key);

  @override
  _TaskSheetState createState() => _TaskSheetState();
}

class _TaskSheetState extends State<TaskSheet> {
  late TaskItemEntity taskItem;
  late TaskCategoryItemEntity categoryItem;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late int? selectedCategory = widget.categoryId ?? null;
  // Jalali? datePicked;
  DateTime? datePicked;
  TimeOfDay? timePicked;
  bool isCompleted = false;
  bool isEdited = false;
  GetStorage getStorage = GetStorage();
  List countTasks = [];

  @override
  void initState() {
    if (widget.isEditing) {
      taskItem = widget.task!.taskItemEntity;
      categoryItem = widget.task!.taskCategoryItemEntity;
      titleController = TextEditingController(text: taskItem.title);
      descriptionController = TextEditingController(text: taskItem.description);
      selectedCategory = categoryItem.id;
      datePicked = taskItem.deadline;
      timePicked = taskItem.deadline != null
          ? TimeOfDay.fromDateTime(taskItem.deadline!)
          // ? TimeOfDay.now()
          : null;
      isCompleted = taskItem.isCompleted;
    } else {
      countTasks = getStorage.read(Keys.listTaskKey);
      print('countTasks$countTasks');
      titleController = TextEditingController();
      descriptionController = TextEditingController();
    }

    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // _deleteTask() {
  //   showDialog<bool>(
  //     context: context,
  //     builder: (context) =>
  //         // FilterWrapper(
  //         // blurAmount: 5,
  //         // child:
  //         AlertDialog(
  //       title: Text("Delete the task?", style: AppTheme.headline3),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           GarbageWidget(),
  //           SizedBox(height: 20),
  //           Text(
  //             'Are you sure want to delete the task?',
  //             style: AppTheme.text1,
  //           ),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //             onPressed: () => Navigator.pop(context, false),
  //             child: Text(
  //               'Cancel',
  //               style: AppTheme.text1,
  //             )),
  //         TextButton(
  //           onPressed: () {
  //             context.read<TaskBloc>().add(DeleteTask(id: taskItem.id!));
  //             Helper.showCustomSnackBar(
  //               context,
  //               content: 'Success Delete Task',
  //             );
  //             Navigator.pop(context, true);
  //           },
  //           child: Text(
  //             'Delete',
  //             style: AppTheme.text1.withPurple,
  //           ),
  //         ),
  //       ],
  //       insetPadding:
  //           const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       clipBehavior: Clip.antiAlias,
  //     ),
  //     // ),
  //   ).then((isDelete) {
  //     if (isDelete != null && isDelete) {
  //       Navigator.pop(context);
  //     }
  //   });
  // }

  _updateTask() {
    if (_formKey.currentState!.validate()) {
      TaskItemEntity taskItemEntity = TaskItemEntity(
        id: taskItem.id,
        title: titleController.text,
        description: descriptionController.text,
        categoryId: selectedCategory!,
      );
      if (datePicked != null) {
        final DateTime savedDeadline = DateTime(
          datePicked!.year,
          datePicked!.month,
          datePicked!.day,
          // timePicked != null ? timePicked!.hour : DateTime.now().hour,
          // timePicked != null ? timePicked!.minute : DateTime.now().minute,
          timePicked != null ? timePicked!.hour : DateTime.now().hour,
          timePicked != null ? timePicked!.minute : DateTime.now().minute,
        );

        taskItemEntity = TaskItemEntity(
          id: taskItem.id,
          title: titleController.text,
          description: descriptionController.text,
          categoryId: selectedCategory!,
          deadline: savedDeadline.toLocal(),
          isCompleted: false,
        );
      }
      context.read<TaskBloc>().add(UpdateTask(taskItemEntity: taskItemEntity));
      Helper.showCustomSnackBar(
        context,
        content: ' تسک ${taskItem.title} با موفقیت ویرایش شد ',
      );
      Navigator.pop(context);
    }
  }

  _saveTask() {
    if (_formKey.currentState!.validate()) {
      TaskItemEntity taskItemEntity = TaskItemEntity(
        title: titleController.text,
        description: descriptionController.text,
        categoryId: selectedCategory!,
      );
      if (datePicked != null) {
        final DateTime savedDeadline = DateTime(
          datePicked?.year ?? DateTime.now().year,
          datePicked?.month ?? DateTime.now().month,
          datePicked?.day ?? DateTime.now().day,
          timePicked != null ? timePicked!.hour : DateTime.now().hour,
          timePicked != null ? timePicked!.minute : DateTime.now().minute,
        );
        taskItemEntity = TaskItemEntity(
          title: titleController.text,
          description: descriptionController.text,
          categoryId: selectedCategory!,
          deadline: savedDeadline.toLocal(),
          isCompleted: false,
        );
      }
      context.read<TaskBloc>().add(InsertTask(taskItemEntity: taskItemEntity));
      Helper.showCustomSnackBar(
        context,
        content: ' تسک ${titleController.text} تسک با موفقیت افزوده شد ',
      );
      countTasks.add(1);
      getStorage.write(Keys.listTaskKey, countTasks);
      Navigator.pop(context);
    }
  }

  _getDate() async {
    Helper.unfocus();
    Jalali? picked = await showPersianDatePicker(
      context: context,
      // initialDate:datePicked.?? Jalali.now(),
      initialDate: Jalali.fromDateTime(datePicked ?? DateTime.now()),
      firstDate: Jalali(1385, 8),
      lastDate: Jalali(1450, 9),
    );
    // var picked = await jalaliCalendarPicker(
    //     convertToGregorian: true, context: context); // نمایش خروجی به صورت شمسی
    // print(picked);

    // setState(() {
    //   datePicked = DateTime.parse(picked!);
    //   print(datePicked);
    // });

    // Jalali? picked = await showPersianDatePicker(
    //   context: context,
    //   initialDate: Jalali.now(),
    //   firstDate: Jalali(1385, 8),
    //   lastDate: Jalali(1450, 9),
    // );
    if (picked != null) {
      setState(() {
        print(picked.runtimeType);
        // datePicked = DateTime.parse(picked);
        datePicked = picked.toDateTime();

        print(datePicked);
      });
    }
    // final picked = await Helper.showDeadlineDatePicker(
    //   context,
    //   datePicked ?? DateTime.now(),
    // );
    // if (picked != null && picked != datePicked) {
    //   setState(() {
    //     datePicked = picked;
    //   });
    // }
  }

  _getTime() {
    Helper.unfocus();
    Helper.showDeadlineTimePicker(
      context,
      timePicked ?? TimeOfDay.now(),
      onTimeChanged: (TimeOfDay timeOfDay) {
        if (timeOfDay != timePicked) {
          setState(() {
            timePicked = timeOfDay;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCategoryBloc, TaskCategoryState>(
      builder: (context, state) {
        return Material(
          child: SafeArea(
            top: false,
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                padding: EdgeInsets.all(20),
                child: state is TaskCategoryLoading
                    ? LoadingWidget()
                    : SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              // widget.isEditing
                              //     ? Row(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.spaceBetween,
                              //         children: [
                              //           GestureDetector(
                              //             child: SvgPicture.asset(
                              //               Resources.trash,
                              //               height: 20,
                              //               width: 20,
                              //             ),
                              //             onTap: _deleteTask,
                              //           ),
                              //           Text('ویرایش تسک',
                              //               style: AppTheme.headline3),
                              //           GestureDetector(
                              //             child: SvgPicture.asset(
                              //               Resources.complete,
                              //               height: 20,
                              //               width: 20,
                              //             ),
                              //             onTap: _updateTask,
                              //           ),
                              //         ],
                              //       )
                              //     :
                              Center(
                                child: Text(
                                    widget.isEditing
                                        ? 'ویرایش تسک'
                                        : 'افزودن تسک',
                                    style: AppTheme.headline3),
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                style: AppTheme.text1.withBlack,
                                controller: titleController,
                                decoration: InputDecoration(
                                  hintText: 'عنوان تسک',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'عنوان تسک رو فراموش کردی وارد کنی';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                style: AppTheme.text1.withBlack,
                                controller: descriptionController,
                                decoration: InputDecoration(
                                  hintText: 'توضیحات',
                                ),
                                maxLines: 5,
                                scrollPhysics: BouncingScrollPhysics(),
                              ),
                              SizedBox(height: 20),
                              Row(children: [
                                Expanded(
                                  child: RippleButton(
                                    onTap: _getDate,
                                    text: datePicked != null
                                        ? Helper.formatDataJalaliHeader(
                                            shamsi.Jalali.fromDateTime(
                                                datePicked!)
                                            // datePicked!.toJalali()
                                            )
                                        : 'تاریخ',
                                    prefixWidget: SvgPicture.asset(
                                        Resources.date,
                                        color: Colors.white,
                                        width: 16),
                                    suffixWidget: datePicked != null
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                datePicked = null;
                                              });
                                            },
                                            child: Icon(
                                              Icons.close_rounded,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: RippleButton(
                                    onTap: _getTime,
                                    text: timePicked != null
                                        ? timePicked!.format(context)
                                        : 'ساعت',
                                    prefixWidget: SvgPicture.asset(
                                        Resources.clock,
                                        color: Colors.white,
                                        width: 16),
                                    suffixWidget: timePicked != null
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                timePicked = null;
                                              });
                                            },
                                            child: Icon(
                                              Icons.close_rounded,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                              ]),
                              SizedBox(height: 20),
                              state is TaskCategorySuccess
                                  ? state.entity.taskCategoryList.isEmpty
                                      ? Text(
                                          'دسته بندی وجود ندارد ، ابتدا یک دسته بندی ایجاد کنید',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.red),
                                        )
                                      : DropdownButtonFormField<int>(
                                          decoration: InputDecoration(
                                            hintText: 'دسته بندی',
                                          ),
                                          validator: (value) {
                                            if (value == null) {
                                              return 'دسته بندی رو فراموش کردی وارد کنی';
                                            }
                                            return null;
                                          },
                                          onTap: () => Helper.unfocus(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedCategory = value;
                                            });
                                          },
                                          items: state.entity.taskCategoryList
                                              .map((e) {
                                            final brightness = ThemeData
                                                .estimateBrightnessForColor(
                                                    e.backgroundColor);
                                            final backColorBri =
                                                brightness == Brightness.light
                                                    ? Colors.black
                                                    : e.backgroundColor;
                                            return DropdownMenuItem(
                                              value: e.id,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    IconData(
                                                        e.icon.icon!.codePoint,
                                                        fontFamily:
                                                            'MaterialIcons'),
                                                    color: backColorBri,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  SizedBox(
                                                    width: 100,
                                                    child: Text(
                                                      e.title,
                                                      style: TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontFamily:
                                                              'IRANSans'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                          style: AppTheme.text1.withBlack,
                                          value: selectedCategory,
                                        )
                                  : Container(),
                              SizedBox(height: 20),
                              PinkButton(
                                text: widget.isEditing ? 'ویرایش' : 'افزودن',
                                onTap:
                                    widget.isEditing ? _updateTask : _saveTask,
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
