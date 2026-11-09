import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_app/models/task.dart';

void main() {
  group('Task Model Unit Tests', () {
    test('Task.create generates a unique ID, trims title, and defaults to pending', () {
      final task = Task.create(title: '  Buy groceries  ');
      expect(task.title, equals('Buy groceries'));
      expect(task.isCompleted, isFalse);
      expect(task.id, isNotEmpty);
      expect(task.createdAt, isNotNull);
    });

    test('toggle() switches isCompleted from false to true and vice-versa', () {
      final task = Task.create(title: 'Learn Flutter');
      expect(task.isCompleted, isFalse);

      final completedTask = task.toggle();
      expect(completedTask.isCompleted, isTrue);
      expect(completedTask.id, equals(task.id));
      expect(completedTask.title, equals(task.title));

      final revertedTask = completedTask.toggle();
      expect(revertedTask.isCompleted, isFalse);
    });

    test('copyWith properly modifies specified attributes only', () {
      final task = Task(
        id: '101',
        title: 'Initial Title',
        isCompleted: false,
        createdAt: DateTime(2026, 11, 9),
      );

      final updatedTitle = task.copyWith(title: 'Updated Title');
      expect(updatedTitle.title, equals('Updated Title'));
      expect(updatedTitle.id, equals('101'));
      expect(updatedTitle.isCompleted, isFalse);

      final updatedStatus = task.copyWith(isCompleted: true);
      expect(updatedStatus.isCompleted, isTrue);
      expect(updatedStatus.title, equals('Initial Title'));
    });

    test('serialization toMap and fromMap preserves data integrity', () {
      final original = Task(
        id: 'serialize_test_1',
        title: 'Serialization Test',
        isCompleted: true,
        createdAt: DateTime(2026, 11, 9, 14, 30),
      );

      final map = original.toMap();
      final restored = Task.fromMap(map);

      expect(restored.id, equals(original.id));
      expect(restored.title, equals(original.title));
      expect(restored.isCompleted, equals(original.isCompleted));
      expect(restored.createdAt, equals(original.createdAt));
      expect(restored, equals(original));
    });
  });
}
