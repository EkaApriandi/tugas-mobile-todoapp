class Todo {
  // Properti untuk setiap item To-Do
  final String id;
  final String title;
  bool isDone;

  // Constructor untuk membuat objek Todo
  Todo({
    required this.id,
    required this.title,
    this.isDone = false, // Secara default, tugas baru belum selesai
  });
}