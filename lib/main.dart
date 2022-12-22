import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logging/logging.dart';
import 'package:task_par/data/data_providers/local/moor_database.dart';
import 'package:task_par/data/data_providers/local/task_dao.dart';

import 'data/exceptions/api_exception.dart';
import 'data/repositories/repositories.dart';
import 'logic/blocs/blocs.dart';
import 'presentation/routes/routes.dart';
import 'presentation/utils/utils.dart';

void main() async {
  await GetStorage.init();
  Bloc.observer = SimpleBlocObserver();
  final AppDatabase appDatabase = AppDatabase();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<TaskRepository>(
          create: (context) => TaskRepository(taskDao: TaskDao(appDatabase)),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<TaskCategoryBloc>(
            create: (context) => TaskCategoryBloc(
              taskRepository: context.read<TaskRepository>(),
            ),
          ),
          BlocProvider<TaskBloc>(
            create: (context) => TaskBloc(
              taskRepository: context.read<TaskRepository>(),
            ),
          ),
          BlocProvider<SearchBloc>(
            create: (context) => SearchBloc(
              taskRepository: context.read<TaskRepository>(),
            ),
          )
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  late final PageRouter _router;

  MyApp() : _router = PageRouter() {
    initLogger();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskPar',
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("fa", "IR"), // OR Locale('ar', 'AE') OR Other RTL locales
      ],
      locale: const Locale('fa', 'IR'),
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: AppTheme.scaffoldColor,
        fontFamily: 'IRANSans',
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.black),
          enabledBorder: AppTheme.enabledBorder,
          focusedBorder: AppTheme.focusedBorder,
          errorBorder: AppTheme.errorBorder,
          focusedErrorBorder: AppTheme.focusedErrorBorder,
          isDense: true,
          hintStyle: AppTheme.text1,
        ),
      ),
      onGenerateRoute: _router.getRoute,
      navigatorObservers: [_router.routeObserver],
    );
  }

  void initLogger() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      dynamic e = record.error;
      String m = e is APIException ? e.message : e.toString();
      print(
          '${record.loggerName}: ${record.level.name}: ${record.message} ${m != 'null' ? m : ''}');
    });
    Logger.root.info("Logger initialized.");
  }
}
