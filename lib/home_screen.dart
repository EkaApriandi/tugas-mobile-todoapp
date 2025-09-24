import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_provider.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _taskController = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Aplikasi Tugas Harian'),
            Chip(
              label: Text(
                '${context.watch<TodoProvider>().activeTodoCount} Aktif',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.blue.shade700,
            ),
          ],
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // build method utama sekarang hanya berisi struktur layout
        child: Column(
          children: [
            _buildTaskInputField(context), // Bagian 1: Input
            const SizedBox(height: 20),
            _buildFilterButtons(context), // Bagian 2: Filter
            const SizedBox(height: 20),
            _buildTaskList(context), // Bagian 3: Daftar Tugas
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER  ---

  /// Membangun UI untuk input field dan tombol tambah.
  Widget _buildTaskInputField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _taskController,
            decoration: const InputDecoration(
              hintText: 'Masukkan judul tugas...',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: const Icon(Icons.add, size: 30),
          style: IconButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            if (_taskController.text.length >= 3) {
              context.read<TodoProvider>().addTodo(_taskController.text);
              _taskController.clear();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Judul tugas minimal harus 3 karakter.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
    );
  }

  /// Membangun UI untuk tombol filter.
  Widget _buildFilterButtons(BuildContext context) {
    // Kita pakai 'watch' di sini agar tombol filter update saat filter diganti
    final provider = context.watch<TodoProvider>();
    return SegmentedButton<TodoFilter>(
      segments: const [
        ButtonSegment(value: TodoFilter.all, label: Text('Semua')),
        ButtonSegment(value: TodoFilter.active, label: Text('Aktif')),
        ButtonSegment(value: TodoFilter.completed, label: Text('Selesai')),
      ],
      selected: {provider.currentFilter},
      onSelectionChanged: (Set<TodoFilter> newFilter) {
        // Gunakan 'read' di dalam callback
        context.read<TodoProvider>().setFilter(newFilter.first);
      },
      style: SegmentedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        selectedBackgroundColor: Colors.blue,
        selectedForegroundColor: Colors.white,
      ),
    );
  }

  /// Membangun UI untuk daftar tugas yang bisa di-scroll.
  Widget _buildTaskList(BuildContext context) {
    // Kita pakai 'watch' di sini agar list update saat ada perubahan data
    final provider = context.watch<TodoProvider>();
    return Expanded(
      child: ListView.builder(
        itemCount: provider.filteredTodos.length,
        itemBuilder: (context, index) {
          final todo = provider.filteredTodos[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              leading: Checkbox(
                value: todo.isDone,
                onChanged: (value) {
                  context.read<TodoProvider>().toggleTodoStatus(todo.id);
                },
              ),
              title: Text(
                todo.title,
                style: TextStyle(
                  decoration: todo.isDone
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: todo.isDone ? Colors.grey : Colors.black,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  context.read<TodoProvider>().deleteTodo(todo.id);
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Tugas telah dihapus'),
                      action: SnackBarAction(
                        label: 'BATALKAN',
                        onPressed: () {
                          context.read<TodoProvider>().undoDelete();
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}