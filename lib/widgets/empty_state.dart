import 'package:flutter/material.dart';

/// An attractive, modern empty state displayed when the task list is empty.
///
/// Features:
/// - Distinct checklist icon container with soft gradient
/// - "No tasks yet!" header
/// - "Add your first task and start being productive." subtitle
/// - Interactive quick-suggestion chips to help users get started instantly
class EmptyState extends StatelessWidget {
  final ValueChanged<String>? onSuggestionSelected;

  const EmptyState({
    super.key,
    this.onSuggestionSelected,
  });

  static const List<String> _suggestions = [
    'Review project submission',
    'Write documentation notes',
    'Plan tomorrow’s goals',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryBlue = theme.colorScheme.primary;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Illustration Container
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryBlue.withValues(alpha: 0.15),
                    const Color(0xFF60A5FA).withValues(alpha: 0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryBlue.withValues(alpha: 0.2),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryBlue.withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.checklist_rtl_rounded,
                size: 50,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 20),

            // Main Empty Message
            const Text(
              'No tasks yet!',
              key: Key('empty_state_title'),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),

            // Subtitle
            const Text(
              'Add your first task and start being productive.',
              key: Key('empty_state_subtitle'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w400,
                color: Color(0xFF64748B),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),

            // Suggested quick actions
            if (onSuggestionSelected != null) ...[
              Text(
                'QUICK SUGGESTIONS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: Colors.blueGrey.shade400,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: _suggestions.map((suggestion) {
                  return ActionChip(
                    avatar: Icon(
                      Icons.add_rounded,
                      size: 16,
                      color: primaryBlue,
                    ),
                    label: Text(
                      suggestion,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey.shade800,
                      ),
                    ),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.blue.shade100,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 1,
                    shadowColor: Colors.black.withValues(alpha: 0.04),
                    onPressed: () => onSuggestionSelected!(suggestion),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
