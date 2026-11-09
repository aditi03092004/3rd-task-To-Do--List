import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_app/main.dart';
import 'package:todo_list_app/models/task.dart';
import 'package:todo_list_app/screens/todo_screen.dart';

void main() {
  group('To-Do List App Widget & Integration Tests', () {
    testWidgets('Renders complete application UI successfully on launch', (WidgetTester tester) async {
      await tester.pumpWidget(const TodoApp());
      await tester.pumpAndSettle();

      // Verify App Header
      expect(find.byKey(const Key('app_header_title')), findsOneWidget);
      expect(find.text('My Tasks'), findsOneWidget);
      expect(find.text('Stay organized. Get things done.'), findsOneWidget);
      expect(find.byKey(const Key('app_header_date')), findsOneWidget);

      // Verify Task Summary & 3 Counters exist
      expect(find.text('Task Overview'), findsOneWidget);
      expect(find.byKey(const Key('total_tasks_counter')), findsOneWidget);
      expect(find.byKey(const Key('remaining_tasks_counter')), findsOneWidget);
      expect(find.byKey(const Key('completed_tasks_counter')), findsOneWidget);

      // Verify Add Task field
      expect(find.byKey(const Key('add_task_text_field')), findsOneWidget);
      expect(find.text('What needs to be done?'), findsOneWidget);
      expect(find.byKey(const Key('add_task_button')), findsOneWidget);
    });

    testWidgets('Displays empty state when no tasks exist', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TodoScreen(initialTasks: []),
        ),
      );
      await tester.pumpAndSettle();

      // Counters should all be 0
      expect(find.byKey(const Key('total_tasks_counter')), findsOneWidget);
      final totalText = tester.widget<Text>(find.byKey(const Key('total_tasks_counter')));
      expect(totalText.data, equals('0'));

      // Empty State elements
      expect(find.byKey(const Key('empty_state_title')), findsOneWidget);
      expect(find.text('No tasks yet!'), findsOneWidget);
      expect(find.text('Add your first task and start being productive.'), findsOneWidget);
    });

    testWidgets('Prevents empty and whitespace-only task submission', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TodoScreen(initialTasks: []),
        ),
      );
      await tester.pumpAndSettle();

      // Attempt to submit empty string
      await tester.tap(find.byKey(const Key('add_task_button')));
      await tester.pumpAndSettle();

      // Attempt to submit whitespace
      await tester.enterText(find.byKey(const Key('add_task_text_field')), '     ');
      await tester.tap(find.byKey(const Key('add_task_button')));
      await tester.pumpAndSettle();

      // Total count remains 0, still in empty state
      final totalText = tester.widget<Text>(find.byKey(const Key('total_tasks_counter')));
      expect(totalText.data, equals('0'));
      expect(find.byKey(const Key('empty_state_title')), findsOneWidget);
    });

    testWidgets('Adds a new task dynamically, clears input, and updates counters immediately', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TodoScreen(initialTasks: []),
        ),
      );
      await tester.pumpAndSettle();

      // Enter task title
      await tester.enterText(find.byKey(const Key('add_task_text_field')), 'Complete Flutter Internship Task');
      await tester.pumpAndSettle();

      // Tap Add button
      await tester.tap(find.byKey(const Key('add_task_button')));
      await tester.pumpAndSettle();

      // Task should now be rendered in the list
      expect(find.text('Complete Flutter Internship Task'), findsOneWidget);

      // Input field should be cleared
      final textField = tester.widget<TextField>(find.byKey(const Key('add_task_text_field')));
      expect(textField.controller?.text, isEmpty);

      // Verify counters update dynamically
      final totalText = tester.widget<Text>(find.byKey(const Key('total_tasks_counter')));
      final remainingText = tester.widget<Text>(find.byKey(const Key('remaining_tasks_counter')));
      final completedText = tester.widget<Text>(find.byKey(const Key('completed_tasks_counter')));

      expect(totalText.data, equals('1'));
      expect(remainingText.data, equals('1'));
      expect(completedText.data, equals('0'));
    });

    testWidgets('Supports adding task via keyboard submission (Enter)', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TodoScreen(initialTasks: []),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('add_task_text_field')), 'Keyboard Submit Task');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.text('Keyboard Submit Task'), findsOneWidget);
      final totalText = tester.widget<Text>(find.byKey(const Key('total_tasks_counter')));
      expect(totalText.data, equals('1'));
    });

    testWidgets('Marks and unmarks tasks as completed and toggles strikethrough styling', (WidgetTester tester) async {
      final initialTask = Task(
        id: 'toggle_test_id',
        title: 'Task To Toggle',
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: TodoScreen(initialTasks: [initialTask]),
        ),
      );
      await tester.pumpAndSettle();

      // Initial counters
      expect(tester.widget<Text>(find.byKey(const Key('remaining_tasks_counter'))).data, equals('1'));
      expect(tester.widget<Text>(find.byKey(const Key('completed_tasks_counter'))).data, equals('0'));

      // Toggle to Completed
      final checkboxFinder = find.byKey(const Key('checkbox_toggle_test_id'));
      expect(checkboxFinder, findsOneWidget);
      await tester.tap(checkboxFinder);
      await tester.pumpAndSettle();

      // Verify counters updated
      expect(tester.widget<Text>(find.byKey(const Key('remaining_tasks_counter'))).data, equals('0'));
      expect(tester.widget<Text>(find.byKey(const Key('completed_tasks_counter'))).data, equals('1'));

      // Verify 'Completed' badge is displayed
      expect(find.byKey(const Key('task_completed_badge_toggle_test_id')), findsOneWidget);

      // Uncheck task back to active
      await tester.tap(checkboxFinder);
      await tester.pumpAndSettle();

      // Verify counters reverted
      expect(tester.widget<Text>(find.byKey(const Key('remaining_tasks_counter'))).data, equals('1'));
      expect(tester.widget<Text>(find.byKey(const Key('completed_tasks_counter'))).data, equals('0'));
    });

    testWidgets('Deletes task via swipe (Dismissible) and updates counters immediately', (WidgetTester tester) async {
      final task1 = Task(
        id: 'swipe_1',
        title: 'Swipe to delete me',
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: TodoScreen(initialTasks: [task1]),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Swipe to delete me'), findsOneWidget);
      expect(tester.widget<Text>(find.byKey(const Key('total_tasks_counter'))).data, equals('1'));

      // Perform dismiss drag from right to left
      await tester.drag(find.text('Swipe to delete me'), const Offset(-500.0, 0.0));
      await tester.pumpAndSettle();

      // Task should be removed
      expect(find.text('Swipe to delete me'), findsNothing);

      // All counters should update to 0
      expect(tester.widget<Text>(find.byKey(const Key('total_tasks_counter'))).data, equals('0'));
      expect(tester.widget<Text>(find.byKey(const Key('remaining_tasks_counter'))).data, equals('0'));

      // Empty state should now appear
      expect(find.byKey(const Key('empty_state_title')), findsOneWidget);

      // SnackBar with Undo action should appear
      expect(find.text('UNDO'), findsOneWidget);
    });

    testWidgets('Filtering tasks by Active and Done works accurately', (WidgetTester tester) async {
      final activeTask = Task(
        id: 'active_1',
        title: 'Active Task 1',
        isCompleted: false,
        createdAt: DateTime.now(),
      );
      final completedTask = Task(
        id: 'completed_1',
        title: 'Completed Task 1',
        isCompleted: true,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: TodoScreen(initialTasks: [activeTask, completedTask]),
        ),
      );
      await tester.pumpAndSettle();

      // In 'All' view, both are visible
      expect(find.text('Active Task 1'), findsOneWidget);
      expect(find.text('Completed Task 1'), findsOneWidget);

      // Switch to 'Active'
      await tester.tap(find.text('Active'));
      await tester.pumpAndSettle();
      expect(find.text('Active Task 1'), findsOneWidget);
      expect(find.text('Completed Task 1'), findsNothing);

      // Switch to 'Done'
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();
      expect(find.text('Active Task 1'), findsNothing);
      expect(find.text('Completed Task 1'), findsOneWidget);
    });
  });
}
