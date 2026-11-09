import 'package:flutter/material.dart';
import '../models/task.dart';
import '../utils/date_formatter.dart';

/// An individual task card widget supporting:
/// - Checkbox toggle for completion with strikethrough styling
/// - Dismissible swipe-to-delete with red background and trash icon
/// - Subtle visual distinction for completed tasks
/// - Responsive card elevation and rounded corners
class TaskItem extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?> onToggle;
  final VoidCallback onDelete;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryBlue = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Dismissible(
        key: ValueKey('task_dismissible_${task.id}'),
        direction: DismissDirection.endToStart,
        background: _buildSwipeDeleteBackground(),
        onDismissed: (_) => onDelete(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: task.isCompleted
                ? const Color(0xFFF8FAFC)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: task.isCompleted
                  ? const Color(0xFFE2E8F0)
                  : Colors.blue.shade100.withValues(alpha: 0.8),
              width: 1.2,
            ),
            boxShadow: task.isCompleted
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: const Color(0xFF1E3A8A).withValues(alpha: 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => onToggle(!task.isCompleted),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    // Checkbox
                    Transform.scale(
                      scale: 1.15,
                      child: Checkbox(
                        key: Key('checkbox_${task.id}'),
                        value: task.isCompleted,
                        onChanged: onToggle,
                        activeColor: primaryBlue,
                        checkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        side: BorderSide(
                          color: task.isCompleted
                              ? primaryBlue
                              : Colors.blueGrey.shade300,
                          width: 1.8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Task Content (Title & Timestamp)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: task.isCompleted
                                  ? FontWeight.w400
                                  : FontWeight.w600,
                              color: task.isCompleted
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF0F172A),
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              decorationColor: const Color(0xFF94A3B8),
                              decorationThickness: 2.0,
                              height: 1.25,
                            ),
                            child: Text(
                              task.title,
                              key: Key('task_title_${task.id}'),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 12,
                                color: task.isCompleted
                                    ? Colors.grey.shade400
                                    : Colors.blueGrey.shade400,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormatter.formatTime(task.createdAt),
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                  color: task.isCompleted
                                      ? Colors.grey.shade400
                                      : Colors.blueGrey.shade400,
                                ),
                              ),
                              if (task.isCompleted) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 1.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD1FAE5),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Completed',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF059669),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Delete button (clickable for desktop/accessibility)
                    IconButton(
                      key: Key('delete_task_button_${task.id}'),
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        size: 20,
                        color: Colors.grey.shade400,
                      ),
                      tooltip: 'Delete task',
                      splashRadius: 20,
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Red swipe-to-delete background with a trash icon and Delete label.
  Widget _buildSwipeDeleteBackground() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEF4444).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 22),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.delete_forever_rounded,
            color: Colors.white,
            size: 26,
          ),
          SizedBox(width: 6),
          Text(
            'Delete',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
