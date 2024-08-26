import 'package:powersync_flutter_demo/models/schema.dart';

import '../powersync.dart';
import 'package:powersync/sqlite3_common.dart' as sqlite;

class TodoItem {
  final String id;
  final String description;
  final String? photoId;
  final bool completed;

  TodoItem({
    required this.id,
    required this.description,
    required this.completed,
    required this.photoId,
  });

  factory TodoItem.fromRow(sqlite.Row row) {
    return TodoItem(
      id: row['id'],
      description: row['description'],
      photoId: row['photo_id'],
      completed: row['completed'] == 1,
    );
  }

  Future<void> toggle() async {
    if (completed) {
      await db.execute(
          'UPDATE $todosTable SET completed = FALSE, completed_by = NULL, completed_at = NULL WHERE id = ?',
          [id]);
    } else {
      await db.execute(
          'UPDATE $todosTable SET completed = TRUE, completed_by = ?, completed_at = datetime() WHERE id = ?',
          [getUserId(), id]);
    }
  }

  Future<void> delete() async {
    await db.execute('DELETE FROM $todosTable WHERE id = ?', [id]);
  }

  static Future<void> addPhoto(String photoId, String id) async {
    await db.execute(
        'UPDATE $todosTable SET photo_id = ? WHERE id = ?', [photoId, id]);
  }
}
