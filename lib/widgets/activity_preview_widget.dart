import 'package:aandm/backend/service/backend_service.dart';
import 'package:aandm/models/activity/activity_model.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ActivityPreviewWidget extends StatefulWidget {
  final VoidCallback onPressed;

  const ActivityPreviewWidget({
    super.key,
    required this.onPressed,
  });

  @override
  State<ActivityPreviewWidget> createState() => _ActivityPreviewWidgetState();
}

class _ActivityPreviewWidgetState extends State<ActivityPreviewWidget> {
  List<EventlogMessage<dynamic>> _activities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getActivities();
  }

  Future<void> _getActivities() async {
    try {
      final backend = Backend();
      final res = await backend.getActivity('own');
      setState(() {
        _activities = res;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return 'vor ${difference.inMinutes} Minuten';
    } else if (difference.inHours < 24) {
      return 'vor ${difference.inHours} Stunden';
    } else if (difference.inDays < 7) {
      return 'vor ${difference.inDays} Tagen';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'vor $weeks Wochen';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'vor $months Monaten';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'vor $years Jahren';
    }
  }

  String _getActionText(String action) {
    switch (action) {
      case '1':
        return 'erstellt';
      case '2':
        return 'aktualisiert';
      case '4':
        return 'gelöscht';
      default:
        return action;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: PhosphorIcon(
                        PhosphorIconsRegular.pulse,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Aktivitäten',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_activities.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Text(
                  'Keine Aktivitäten vorhanden',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              )
            else
              ..._activities.take(5).map((activity) {
                final IconData icon;
                final String entityName;

                switch (activity.entityType) {
                  case 'note':
                    icon = Icons.note_alt;
                    entityName = 'Notiz';
                  case 'task':
                    icon = Icons.check_box;
                    entityName = 'Aufgabe';
                  case 'task_list':
                    icon = Icons.checklist;
                    entityName = 'Aufgabenliste';
                  default:
                    icon = Icons.circle;
                    entityName = 'Element';
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          size: 16,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${activity.user.username} hat $entityName ${_getActionText(activity.actionType)}',
                              style: Theme.of(context).textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              _formatTimeAgo(activity.date),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
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
                    ],
                  ),
                );
              }),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: widget.onPressed,
                child: Text(
                  'Mehr anzeigen',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
