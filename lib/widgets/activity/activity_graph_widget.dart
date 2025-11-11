import 'package:aandm/models/activity/activity_model.dart';
import 'package:aandm/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A GitHub-like contribution heatmap for a list of activities.
///
/// - Columns are weeks (latest on the right), rows are days (Sun..Sat).
/// - Colors are sourced from the theme via ActivityHeatmapColors.
class ActivityGraphWidget extends StatelessWidget {
  final List<EventlogMessage<dynamic>> activities;
  final int weeks; // number of week columns to render
  final double cellSize; // square size
  final double cellSpacing; // spacing between cells
  final bool showLegend; // show color scale legend
  final DateTime? endDate; // end of range; defaults to today
  final EdgeInsetsGeometry padding; // padding inside the card

  const ActivityGraphWidget({
    super.key,
    required this.activities,
    this.weeks = 16,
    this.cellSize = 12,
    this.cellSpacing = 2,
    this.showLegend = true,
    this.endDate,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    final heatmap =
        Theme.of(context).extension<ActivityHeatmapColors>()?.levels ??
            [
              const Color(0xFFE8F5E9),
              const Color(0xFFC8E6C9),
              const Color(0xFFA5D6A7),
              const Color(0xFF66BB6A),
              const Color(0xFF2E7D32),
            ];

    final now = (endDate ?? DateTime.now()).toLocal();
    final endOfWeek = _endOfWeek(now);
    final start = endOfWeek.subtract(Duration(days: 7 * (weeks - 1)));

    final countsByDay = _groupByDay(activities);
    final maxCount = countsByDay.isEmpty
        ? 0
        : countsByDay.values.reduce((a, b) => a > b ? a : b);

    final columns = List.generate(weeks, (w) {
      final columnStart = start.add(Duration(days: w * 7));
      return List.generate(
          7,
          (d) => DateTime(columnStart.year, columnStart.month, columnStart.day)
              .add(Duration(days: d)));
    });

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Compute dynamic cell size so the entire grid spans available width (no weekday labels).
            // Total width formula: weeks*x + (weeks-1)*cellSpacing
            final availableWidth = constraints.maxWidth;
            final dynamicCellSize =
                (availableWidth - (weeks - 1) * cellSpacing) / weeks;
            final resolvedCellSize = dynamicCellSize.clamp(6, 32).toDouble();

            final grid = Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (final week in columns)
                        Column(
                          children: [
                            for (final day in week)
                              _buildCell(
                                context,
                                day,
                                countsByDay[DateTime(
                                        day.year, day.month, day.day)] ??
                                    0,
                                heatmap,
                                maxCount,
                                overrideSize: resolvedCellSize,
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                grid,
                if (showLegend) ...[
                  const SizedBox(height: 12),
                  _Legend(
                    heatmap: heatmap,
                    cellSize: resolvedCellSize,
                    cellSpacing: cellSpacing,
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCell(BuildContext context, DateTime day, int count,
      List<Color> heatmap, int maxCount,
      {double? overrideSize}) {
    final bucket = _bucketForCount(count, maxCount);
    final color = heatmap[bucket];
    final dayKey = DateFormat('yyyy-MM-dd').format(day);
    final tooltip =
        '${DateFormat.yMMMEd().format(day)}\n$count activit${count == 1 ? 'y' : 'ies'}';
    return Padding(
      padding: EdgeInsets.only(bottom: cellSpacing),
      child: Tooltip(
        message: tooltip,
        child: Semantics(
          label: 'activity $dayKey count:$count',
          child: Container(
            key: ValueKey('activity-cell-$dayKey'),
            width: overrideSize ?? cellSize,
            height: overrideSize ?? cellSize,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }

  static int _bucketForCount(int count, int maxCount) {
    if (count <= 0 || maxCount <= 0) return 0;
    // Quantize proportionally into 4 non-zero levels.
    final ratio = count / maxCount;
    final level = (ratio * 4).ceil();
    return level.clamp(1, 4);
  }

  static Map<DateTime, int> _groupByDay(
      List<EventlogMessage<dynamic>> activities) {
    final map = <DateTime, int>{};
    for (final a in activities) {
      final dLocal = a.date.toLocal();
      final key = DateTime(dLocal.year, dLocal.month, dLocal.day);
      map.update(key, (v) => v + 1, ifAbsent: () => 1);
    }
    return map;
  }

  static DateTime _endOfWeek(DateTime date) {
    // Use Sunday as first row like GitHub. Find the Saturday of the current week.
    final weekday =
        date.weekday % 7; // Sunday -> 0, Monday -> 1, ... Saturday -> 6
    final daysToSaturday = 6 - weekday;
    final end = DateTime(date.year, date.month, date.day)
        .add(Duration(days: daysToSaturday));
    return end;
  }
}

// Day labels removed per request – graph now spans entire card width.

class _Legend extends StatelessWidget {
  final List<Color> heatmap;
  final double cellSize;
  final double cellSpacing;

  const _Legend(
      {required this.heatmap,
      required this.cellSize,
      required this.cellSpacing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Less',
          style: Theme.of(context).textTheme.labelSmall,
        ),
        SizedBox(width: 6),
        for (int i = 0; i < heatmap.length; i++)
          Padding(
            padding: EdgeInsets.only(right: cellSpacing),
            child: Container(
              width: cellSize,
              height: cellSize,
              decoration: BoxDecoration(
                color: heatmap[i],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        SizedBox(width: 6),
        Text(
          'More',
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}
