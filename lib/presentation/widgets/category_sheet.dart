
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:task_par/data/entities/task_category_entity.dart';
import 'package:task_par/logic/blocs/task_category/task_category_bloc.dart';
import 'package:task_par/presentation/utils/app_theme.dart';
import 'package:task_par/presentation/utils/extensions.dart';
import 'package:task_par/presentation/utils/helper.dart';
import 'package:task_par/presentation/widgets/jalali_table_widget/src/jalaliCalendarPicker.dart';

import 'buttons.dart';
import 'state_widgets.dart';

class CategorySheet extends StatefulWidget {
  final TaskCategoryItemEntity? taskCategoryItem;
  final int? categoryId;
  final bool isEditing;

  const CategorySheet(
      {Key? key,
      this.taskCategoryItem,
      this.categoryId,
      this.isEditing = false})
      : super(key: key);

  @override
  _CategorySheetState createState() => _CategorySheetState();
}

class _CategorySheetState extends State<CategorySheet> {
  late TaskCategoryItemEntity categoryItem;
  TextEditingController titleController = TextEditingController();

  int iconCat = Icons.create_new_folder_outlined.codePoint;
  Color colorCat = Colors.green;
  TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late int? selectedCategory = widget.categoryId ?? null;

  // Jalali? datePicked;
  DateTime? datePicked;
  TimeOfDay? timePicked;
  bool isCompleted = false;
  bool isEdited = false;

  @override
  void initState() {
    if (widget.isEditing) {
      categoryItem = widget.taskCategoryItem!;
      print(categoryItem.id);
      titleController = TextEditingController(text: categoryItem.title);

      selectedCategory = categoryItem.id;
      colorCat = categoryItem.backgroundColor;

      iconCat = categoryItem.icon.icon!.codePoint;
      print(categoryItem.icon);
    } else {
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

  _updateTask() {
    if (_formKey.currentState!.validate()) {
      TaskCategoryItemEntity taskItemEntity = TaskCategoryItemEntity(
          title: titleController.text,
          icon: Icon(IconData(iconCat, fontFamily: 'MaterialIcons')),
          backgroundColor: colorCat,
          gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
          id: categoryItem.id);

      context.read<TaskCategoryBloc>().add(UpdateTaskCategory(
            taskCategoryItemEntity: taskItemEntity,
          ));
      Helper.showCustomSnackBar(
        context,
        content: 'taskItemEntityMMUU${taskItemEntity.title}',
        bgColor: AppTheme.lightPurple,
      );
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  _saveTask() {
    if (_formKey.currentState!.validate()) {
      TaskCategoryItemEntity taskItemEntity = TaskCategoryItemEntity(
        title: titleController.text,
        icon: Icon(IconData(iconCat, fontFamily: 'MaterialIcons')),
        backgroundColor: colorCat,
        gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
      );

      context.read<TaskCategoryBloc>().add(InsertTaskCategory(
            taskCategoryItemEntity: taskItemEntity,
          ));
      Navigator.pop(context);
    }
  }

  _getDate() async {
    Helper.unfocus();
    var picked = await jalaliCalendarPicker(
        convertToGregorian: true, context: context); // نمایش خروجی به صورت شمسی
    print(picked);

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
        datePicked = DateTime.parse(picked);
        // datePicked = picked.toDateTime();
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
                                          ? 'ویرایش دسته بندی'
                                          : 'افزودن دسته بندی',
                                      style: AppTheme.headline3),
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  style: AppTheme.text1.withBlack,
                                  controller: titleController,
                                  decoration: InputDecoration(
                                    labelText: 'عنوان دسته بندی',
                                    labelStyle: TextStyle(color: Colors.grey),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'عنوان دسته بندی رو فراموش کردی وارد کنی';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'رنگ دسته بندی را انتخاب کنید :',
                                  style: AppTheme.text1.withBlack,
                                ),
                                MaterialColorPicker(
                                    allowShades: true,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    // onMainColorChange: (value) {
                                    //   print(value);
                                    //   // setState(() {});
                                    //   // colorCat.value = value.value;
                                    //   // value.
                                    // },
                                    onColorChange: (Color color) {
                                      // provider.changeColor(color);
                                      // setState(() {
                                      colorCat = color;
                                      print(colorCat);
                                      // });
                                    },
                                    selectedColor: colorCat),

                                SizedBox(height: 20),
                                InkWell(
                                  onTap: () async {
                                    IconData? icon =
                                        await FlutterIconPicker.showIconPicker(
                                            context,
                                            closeChild: Text(
                                              'بستن',
                                              style: TextStyle(
                                                  fontFamily: 'IRANSans',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            title: Text(
                                              'آیکون خود را انتخاب کنید',
                                              style: TextStyle(
                                                  fontFamily: 'IRANSans',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            showSearchBar: false,
                                            iconPackModes: [
                                          // IconPack.cupertino,
                                          IconPack.material
                                        ]);
                                    if (icon != null) {
                                      setState(() {
                                        iconCat = icon.codePoint;
                                      });
                                    }
                                  },
                                  child: Row(children: [
                                    Text(
                                      'آیکون خود را انتخاب کنید :',
                                      style: AppTheme.text1.withBlack,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      IconData(iconCat,
                                          fontFamily: 'MaterialIcons'),
                                    ),
                                  ]),
                                ),
                                SizedBox(height: 20),
                                PinkButton(
                                  text: widget.isEditing ? 'ویرایش' : 'افزودن',
                                  onTap: widget.isEditing
                                      ? _updateTask
                                      : _saveTask,
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                ),
              )));
    });
  }
}
