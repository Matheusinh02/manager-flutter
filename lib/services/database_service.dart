import 'dart:async';
import 'dart:convert';
import '../models/task.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  
  // Armazenamento em memória para web e plataformas sem SQLite
  static final List<Task> _inMemoryTasks = [];

  DatabaseService._init();

  Future<Task> create(Task task) async {
    _inMemoryTasks.add(task);
    return task;
  }

  Future<Task?> read(String id) async {
    try {
      return _inMemoryTasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Task>> readAll() async {
    // Retorna cópia ordenada por data de criação
    final tasks = List<Task>.from(_inMemoryTasks);
    tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return tasks;
  }

  Future<int> update(Task task) async {
    final index = _inMemoryTasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _inMemoryTasks[index] = task;
      return 1;
    }
    return 0;
  }

  Future<int> delete(String id) async {
    final index = _inMemoryTasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _inMemoryTasks.removeAt(index);
      return 1;
    }
    return 0;
  }

  Future<void> close() async {
    // Não há nada para fechar em armazenamento em memória
  }

  // Exportar todas as tarefas para JSON
  String exportToJson() {
    final tasksData = _inMemoryTasks.map((task) => task.toMap()).toList();
    final backup = {
      'version': '1.0.0',
      'exportDate': DateTime.now().toIso8601String(),
      'tasksCount': tasksData.length,
      'tasks': tasksData,
    };
    return jsonEncode(backup);
  }

  // Importar tarefas de JSON com validação
  Future<Map<String, dynamic>> importFromJson(String jsonString) async {
    try {
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      
      // Validar estrutura básica
      if (!data.containsKey('tasks') || data['tasks'] is! List) {
        return {
          'success': false,
          'error': 'Formato de arquivo inválido: campo "tasks" não encontrado',
        };
      }

      final tasksList = data['tasks'] as List;
      final importedTasks = <Task>[];
      final errors = <String>[];

      // Validar e converter cada tarefa
      for (var i = 0; i < tasksList.length; i++) {
        try {
          final taskMap = tasksList[i] as Map<String, dynamic>;
          
          // Validar campos obrigatórios
          if (!taskMap.containsKey('id') || !taskMap.containsKey('title')) {
            errors.add('Tarefa ${i + 1}: campos obrigatórios ausentes');
            continue;
          }

          final task = Task.fromMap(taskMap);
          importedTasks.add(task);
        } catch (e) {
          errors.add('Tarefa ${i + 1}: erro ao processar - $e');
        }
      }

      if (importedTasks.isEmpty) {
        return {
          'success': false,
          'error': 'Nenhuma tarefa válida encontrada no arquivo',
          'details': errors,
        };
      }

      // Limpar tarefas existentes e adicionar as importadas
      _inMemoryTasks.clear();
      _inMemoryTasks.addAll(importedTasks);

      return {
        'success': true,
        'imported': importedTasks.length,
        'errors': errors.isEmpty ? null : errors,
        'exportDate': data['exportDate'],
        'version': data['version'],
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro ao processar arquivo: $e',
      };
    }
  }

  // Limpar todas as tarefas
  Future<void> clearAll() async {
    _inMemoryTasks.clear();
  }
}
