import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:rxdart/rxdart.dart';
import 'package:task_par/data/entities/task_with_category_entity.dart';
import 'package:task_par/data/repositories/task_repository.dart';

part 'search_event.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final TaskRepository _taskRepository;

  SearchBloc({required TaskRepository taskRepository})
      : _taskRepository = taskRepository,
        super(SearchInitial());

  Stream<Transition<SearchEvent, SearchState>> transformEvents(
      Stream<SearchEvent> events, transitionFn) {
    return super.transformEvents(
      events.debounceTime(Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchTask) {
      yield* _mapSearchTaskToState(event);
    } else if (event is SetInitialSearch) {
      yield* _mapSetInitialSearchToState(event);
    }
  }

  Stream<SearchState> _mapSearchTaskToState(SearchTask event) async* {
    final Stream<TaskWithCategoryEntity> entity =
        _taskRepository.searchTasks(event.searchQuery);
    yield SearchStream(entity: entity);
  }

  Stream<SearchState> _mapSetInitialSearchToState(
      SetInitialSearch event) async* {
    yield SearchInitial();
  }
}
