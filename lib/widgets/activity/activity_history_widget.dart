import 'package:aandm/models/activity/activity_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// A GitHub/GitLab-like activity history feed widget.
///
/// Displays a chronological timeline of user activities grouped by date,
/// with icons representing the action type and entity.
class ActivityHistoryWidget extends StatelessWidget {
  final List<EventlogMessage<dynamic>> activities;
  final int? maxItems; // optional limit on displayed items

  const ActivityHistoryWidget({
    super.key,
    required this.activities,
    this.maxItems,
  });

  @override
  Widget build(BuildContext context) {
    // Sort activities by date descending (most recent first)
    final sorted = List<EventlogMessage<dynamic>>.from(activities)
      ..sort((a, b) => b.date.compareTo(a.date));

    // Take only maxItems if specified
    final displayed = maxItems != null && maxItems! > 0
        ? sorted.take(maxItems!).toList()
        : sorted;

    // Group by month/year for section headers
    final grouped = _groupByMonth(displayed);

    if (displayed.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              'Noch keine Aktivitäten',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
      );
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final entry in grouped.entries) ...[
              _MonthHeader(monthYear: entry.key),
              const SizedBox(height: 8),
              ...entry.value.map((activity) => _ActivityItem(
                    activity: activity,
                    isLast: activity == entry.value.last &&
                        entry.key == grouped.keys.last,
                  )),
              if (entry.key != grouped.keys.last) const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }

  /// Groups activities by "Month YYYY" strings
  Map<String, List<EventlogMessage<dynamic>>> _groupByMonth(
      List<EventlogMessage<dynamic>> activities) {
    final map = <String, List<EventlogMessage<dynamic>>>{};
    for (final activity in activities) {
      final key = DateFormat('MMMM yyyy').format(activity.date);
      map.putIfAbsent(key, () => []).add(activity);
    }
    return map;
  }
}

class _MonthHeader extends StatelessWidget {
  final String monthYear;

  const _MonthHeader({required this.monthYear});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        monthYear,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final EventlogMessage<dynamic> activity;
  final bool isLast;

  const _ActivityItem({required this.activity, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    final icon = _iconForActivity(activity);
    final description = _descriptionForActivity(activity);
    final timeAgo = _formatTimeAgo(activity.date);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline column with icon and vertical line
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: PhosphorIcon(
                      icon,
                      size: 16,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.only(top: 4),
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.5),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16, top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    timeAgo,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.color
                              ?.withValues(alpha: 0.7),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PhosphorIconData _iconForActivity(EventlogMessage<dynamic> activity) {
    // Map entity types to icons
    return switch (activity.entityType.toLowerCase()) {
      'note' => PhosphorIconsRegular.note,
      'task' => PhosphorIconsRegular.checkSquare,
      'task_list' || 'tasklist' => PhosphorIconsRegular.listChecks,
      _ => PhosphorIconsRegular.pulse,
    };
  }

  String _descriptionForActivity(EventlogMessage<dynamic> activity) {
    // Map entity types to German nouns
    final entityName = switch (activity.entityType.toLowerCase()) {
      'note' => 'Notiz',
      'task' => 'Aufgabe',
      'task_list' || 'tasklist' => 'Aufgabenliste',
      _ => activity.entityType,
    };

    // Map action types to German verbs
    final actionVerb = switch (activity.actionType.toLowerCase()) {
      '1' => 'erstellt',
      '2' => 'aktualisiert',
      '4' => 'gelöscht',
      _ => activity.actionType,
    };

    return '${activity.user.username} hat $entityName $actionVerb';
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      return DateFormat('d. MMM yyyy').format(date);
    } else if (difference.inDays > 0) {
      return 'vor ${difference.inDays} ${difference.inDays == 1 ? 'Tag' : 'Tagen'}';
    } else if (difference.inHours > 0) {
      return 'vor ${difference.inHours} ${difference.inHours == 1 ? 'Stunde' : 'Stunden'}';
    } else if (difference.inMinutes > 0) {
      return 'vor ${difference.inMinutes} ${difference.inMinutes == 1 ? 'Minute' : 'Minuten'}';
    } else {
      return 'gerade eben';
    }
  }
}
