import 'package:flutter/material.dart';

/// An attractive, modern summary card displaying real-time metrics:
/// - Total tasks
/// - Completed tasks
/// - Remaining tasks
///
/// Features a dynamic progress indicator and motivational status badge.
class TaskSummary extends StatelessWidget {
  final int totalTasks;
  final int completedTasks;
  final int remainingTasks;

  const TaskSummary({
    super.key,
    required this.totalTasks,
    required this.completedTasks,
    required this.remainingTasks,
  });

  double get _progressPercentage {
    if (totalTasks == 0) return 0.0;
    return (completedTasks / totalTasks).clamp(0.0, 1.0);
  }

  String get _motivationalText {
    if (totalTasks == 0) {
      return 'No tasks yet. Tap below to start!';
    }
    if (remainingTasks == 0) {
      return 'All tasks completed! Fantastic job! 🎉';
    }
    final percent = (_progressPercentage * 100).toInt();
    if (percent >= 70) {
      return 'Almost there! Keep up the momentum!';
    }
    return '$remainingTasks ${remainingTasks == 1 ? 'task' : 'tasks'} waiting for your attention.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryBlue = theme.colorScheme.primary;
    final percentInt = (_progressPercentage * 100).toInt();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.blue.shade100.withValues(alpha: 0.6),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Title and Percentage Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: primaryBlue.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.insights_rounded,
                      size: 18,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Task Overview',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$percentInt% Done',
                  style: TextStyle(
                    color: primaryBlue,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Linear Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _progressPercentage,
              minHeight: 8,
              backgroundColor: Colors.blue.shade50,
              valueColor: AlwaysStoppedAnimation<Color>(
                remainingTasks == 0 && totalTasks > 0
                    ? const Color(0xFF10B981)
                    : primaryBlue,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Motivational / Status Text
          Text(
            _motivationalText,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey.shade600,
            ),
          ),
          const SizedBox(height: 16),

          // 3 Metric Counters in Row
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  key: const Key('total_tasks_counter'),
                  label: 'Total',
                  count: totalTasks,
                  icon: Icons.assignment_outlined,
                  color: const Color(0xFF2563EB),
                  backgroundColor: const Color(0xFFEFF6FF),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricTile(
                  key: const Key('remaining_tasks_counter'),
                  label: 'Remaining',
                  count: remainingTasks,
                  icon: Icons.hourglass_top_rounded,
                  color: const Color(0xFFF59E0B),
                  backgroundColor: const Color(0xFFFEF3C7),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricTile(
                  key: const Key('completed_tasks_counter'),
                  label: 'Completed',
                  count: completedTasks,
                  icon: Icons.check_circle_outline_rounded,
                  color: const Color(0xFF10B981),
                  backgroundColor: const Color(0xFFD1FAE5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required Key key,
    required String label,
    required int count,
    required IconData icon,
    required Color color,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$count',
            key: key,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
