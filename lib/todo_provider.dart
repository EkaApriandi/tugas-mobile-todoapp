import 'package:flutter/material.dart';
import 'todo_model.dart';

enum TodoFilter { all, active, completed }

class TodoProvider with ChangeNotifier {
  final List<Todo> _todos = [];
  TodoFilter _currentFilter = TodoFilter.all;

  Todo? _lastRemovedTodo;
  int? _lastRemovedIndex;

  int get activeTodoCount {
    return _todos.where((todo) => !todo.isDone).length;
  }

  List<Todo> get filteredTodos {
    switch (_currentFilter) {
      case TodoFilter.active:
        return _todos.where((todo) => !todo.isDone).toList();
      case TodoFilter.completed:
        return _todos.where((todo) => todo.isDone).toList();
      case TodoFilter.all:
        return _todos;
    }
  }

  TodoFilter get currentFilter => _currentFilter;

  void setFilter(TodoFilter filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  void addTodo(String title) {
    final newTodo = Todo(
      id: DateTime.now().toString(),
      title: title,
    );
    _todos.add(newTodo);
    notifyListeners();
  }

  void toggleTodoStatus(String id) {
    final todo = _todos.firstWhere((todo) => todo.id == id);
    todo.isDone = !todo.isDone;
    notifyListeners();
  }

  void deleteTodo(String id) {
    _lastRemovedIndex = _todos.indexWhere((todo) => todo.id == id);
    if (_lastRemovedIndex != -1) {
      _lastRemovedTodo = _todos.removeAt(_lastRemovedIndex!);
      notifyListeners();
    }
  }

  void undoDelete() {
    if (_lastRemovedTodo != null && _lastRemovedIndex != null) {
      _todos.insert(_lastRemovedIndex!, _lastRemovedTodo!);
      _lastRemovedTodo = null;
      _lastRemovedIndex = null;
      notifyListeners();
    }
  }
}