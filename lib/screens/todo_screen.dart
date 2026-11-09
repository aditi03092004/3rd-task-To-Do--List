import 'package:flutter/material.dart';
import '../models/task.dart';
import '../utils/date_formatter.dart';
import '../widgets/add_task_field.dart';
import '../widgets/empty_state.dart';
import '../widgets/task_item.dart';
import '../widgets/task_summary.dart';

/// Filter options for viewing tasks.
enum TaskFilter { all, active, completed }

/// The primary single-screen UI for the To-Do List Application.
///
/// Manages:
/// - Dynamic task list state with [setState]
/// - Task creation, completion toggling, and swipe deletion with Undo
/// - Real-time dynamic calculation of total, completed, and remaining tasks
/// - Filter switching (All, Active, Completed)
class TodoScreen extends StatefulWidget {
  final List<Task>? initialTasks;

  const TodoScreen({
    super.key,
    this.initialTasks,
  });

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  late final List<Task> _tasks;
  TaskFilter _currentFilter = TaskFilter.all;

  @override
  void initState() {
    super.initState();
    // Initialize with provided tasks or standard starter tasks for presentation
    _tasks = widget.initialTasks != null
        ? List<Task>.from(widget.initialTasks!)
        : [
            Task(
              id: 'starter_1',
              title: 'Review Flutter internship submission guidelines',
              isCompleted: true,
              createdAt: DateTime.now().subtract(const Duration(hours: 3)),
            ),
            Task(
              id: 'starter_2',
              title: 'Build responsive Material 3 To-Do interface',
              isCompleted: false,
              createdAt: DateTime.now().subtract(const Duration(hours: 1)),
            ),
            Task(
              id: 'starter_3',
              title: 'Test swipe-to-delete and counter reactivity',
              isCompleted: false,
              createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
            ),
          ];
  }

  // Dynamic getters calculated directly from the actual task list
  int get _totalTasks => _tasks.length;
  int get _completedTasks => _tasks.where((task) => task.isCompleted).length;
  int get _remainingTasks => _tasks.where((task) => !task.isCompleted).length;

  List<Task> get _filteredTasks {
    switch (_currentFilter) {
      case TaskFilter.active:
        return _tasks.where((task) => !task.isCompleted).toList();
      case TaskFilter.completed:
        return _tasks.where((task) => task.isCompleted).toList();
      case TaskFilter.all:
        return _tasks;
    }
  }

  /// Adds a new task dynamically and triggers an instant UI update.
  void _addTask(String title) {
    final newTask = Task.create(title: title);
    setState(() {
      _tasks.insert(0, newTask);
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Task "${newTask.title}" added',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: const Color(0xFF1E293B),
      ),
    );
  }

  /// Toggles the completion status of a task and updates counters dynamically.
  void _toggleTask(Task task, bool? isCompleted) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      setState(() {
        _tasks[index] = _tasks[index].copyWith(
          isCompleted: isCompleted ?? !_tasks[index].isCompleted,
        );
      });
    }
  }

  /// Removes a task from the list and provides an instant Undo action.
  void _deleteTask(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index == -1) return;

    final removedTask = _tasks[index];
    setState(() {
      _tasks.removeAt(index);
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Deleted "${removedTask.title}"',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: const Color(0xFF60A5FA),
          onPressed: () {
            setState(() {
              _tasks.insert(index.clamp(0, _tasks.length), removedTask);
            });
          },
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: const Color(0xFF0F172A),
      ),
    );
  }

  /// Resets the list with sample tasks for demonstration.
  void _resetSampleTasks() {
    setState(() {
      _tasks.clear();
      _tasks.addAll([
        Task.create(title: 'Organize workspace & review project deliverables'),
        Task.create(title: 'Verify all widget and state management tests'),
        Task.create(title: 'Prepare final internship presentation slides'),
      ]);
    });
  }

  /// Clears all tasks.
  void _clearAllTasks() {
    if (_tasks.isEmpty) return;
    final backup = List<Task>.from(_tasks);
    setState(() {
      _tasks.clear();
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All tasks cleared'),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: const Color(0xFF60A5FA),
          onPressed: () {
            setState(() {
              _tasks.addAll(backup);
            });
          },
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: const Color(0xFF0F172A),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryBlue = theme.colorScheme.primary;
    final currentDateFormatted = DateFormatter.formatHeaderDate(DateTime.now());
    final visibleTasks = _filteredTasks;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar / Header Section
            _buildAppHeader(primaryBlue, currentDateFormatted),

            // Scrollable Content / Dynamic Task Area
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // Task Summary Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                      child: TaskSummary(
                        totalTasks: _totalTasks,
                        completedTasks: _completedTasks,
                        remainingTasks: _remainingTasks,
                      ),
                    ),
                  ),

                  // Add Task Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: AddTaskField(
                        onAddTask: _addTask,
                      ),
                    ),
                  ),

                  // Filter Chips & List Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
                      child: _buildFilterHeader(primaryBlue),
                    ),
                  ),

                  // Task List or Empty State
                  if (_tasks.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyState(
                        onSuggestionSelected: _addTask,
                      ),
                    )
                  else if (visibleTasks.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _buildNoMatchingFilterState(),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final task = visibleTasks[index];
                          return TaskItem(
                            key: ValueKey('task_item_${task.id}'),
                            task: task,
                            onToggle: (value) => _toggleTask(task, value),
                            onDelete: () => _deleteTask(task),
                          );
                        },
                        childCount: visibleTasks.length,
                      ),
                    ),

                  // Bottom padding for scroll room
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 32),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// App Header displaying title, subtitle, date, and quick actions
  Widget _buildAppHeader(Color primaryColor, String formattedDate) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.blue.shade100.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & Subtitle & Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.check_box_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'My Tasks',
                      key: Key('app_header_title'),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Stay organized. Get things done.',
                  key: Key('app_header_subtitle'),
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 13,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      formattedDate,
                      key: const Key('app_header_date'),
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Options Menu
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert_rounded,
              color: Colors.blueGrey.shade700,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            onSelected: (value) {
              if (value == 'reset') {
                _resetSampleTasks();
              } else if (value == 'clear') {
                _clearAllTasks();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.refresh_rounded, size: 18, color: Color(0xFF2563EB)),
                    SizedBox(width: 10),
                    Text('Load Sample Tasks'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.clear_all_rounded, size: 18, color: Color(0xFFEF4444)),
                    SizedBox(width: 10),
                    Text('Clear All Tasks'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Filter header with category chips (All, Active, Completed)
  Widget _buildFilterHeader(Color primaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Tasks List',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        Row(
          children: [
            _buildFilterChip('All', TaskFilter.all),
            const SizedBox(width: 6),
            _buildFilterChip('Active', TaskFilter.active),
            const SizedBox(width: 6),
            _buildFilterChip('Done', TaskFilter.completed),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, TaskFilter filter) {
    final isSelected = _currentFilter == filter;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        setState(() {
          _currentFilter = filter;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2563EB)
                : Colors.blue.shade100.withValues(alpha: 0.8),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildNoMatchingFilterState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.filter_list_off_rounded,
              size: 48,
              color: Colors.blueGrey.shade300,
            ),
            const SizedBox(height: 12),
            Text(
              'No ${_currentFilter == TaskFilter.active ? "active" : "completed"} tasks found',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                setState(() {
                  _currentFilter = TaskFilter.all;
                });
              },
              child: const Text('Show All Tasks'),
            ),
          ],
        ),
      ),
    );
  }
}
