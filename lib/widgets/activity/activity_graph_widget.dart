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
        Theme.of(context).extension<ActivityHeatmapColors>()!.levels;

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
      margin: EdgeInsets.zero,
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

            // Try to pick up card radius from theme; fallback to 12
            double cardRadius = 12;
            final shape = Theme.of(context).cardTheme.shape;
            if (shape is RoundedRectangleBorder) {
              final br = shape.borderRadius;
              final resolved = br.resolve(Directionality.of(context));
              cardRadius = resolved.topLeft.x;
            }

            final grid = Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int w = 0; w < columns.length; w++)
                        Column(
                          children: [
                            for (int d = 0; d < columns[w].length; d++)
                              _buildCell(
                                context,
                                columns[w][d],
                                countsByDay[DateTime(
                                      columns[w][d].year,
                                      columns[w][d].month,
                                      columns[w][d].day,
                                    )] ??
                                    0,
                                heatmap,
                                maxCount,
                                overrideSize: resolvedCellSize,
                                isTop: d == 0,
                                isBottom: d == columns[w].length - 1,
                                isLeft: w == 0,
                                isRight: w == columns.length - 1,
                                cornerRadius: cardRadius,
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
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCell(BuildContext context, DateTime day, int count,
      List<Color> heatmap, int maxCount,
      {double? overrideSize,
      bool isTop = false,
      bool isBottom = false,
      bool isLeft = false,
      bool isRight = false,
      double cornerRadius = 12}) {
    final bucket = _bucketForCount(count, maxCount);
    final color = heatmap[bucket];
    final dayKey = DateFormat('yyyy-MM-dd').format(day);
    final tooltip =
        '${DateFormat.yMMMEd().format(day)}\n$count activit${count == 1 ? 'y' : 'ies'}';
    final radius = BorderRadius.only(
      topLeft: isTop && isLeft
          ? Radius.circular(cornerRadius)
          : const Radius.circular(2),
      topRight: isTop && isRight
          ? Radius.circular(cornerRadius)
          : const Radius.circular(2),
      bottomLeft: isBottom && isLeft
          ? Radius.circular(cornerRadius)
          : const Radius.circular(2),
      bottomRight: isBottom && isRight
          ? Radius.circular(cornerRadius)
          : const Radius.circular(2),
    );
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
              borderRadius: radius,
            ),
          ),
        ),
      ),
    );
  }

  static int _bucketForCount(int count, int maxCount) {
    if (count <= 0) return 0;
    // Fixed thresholds: every 5 activities = 1 level
    // 0 -> level 0 (empty)
    // 1-5 -> level 1
    // 6-10 -> level 2
    // 11-15 -> level 3
    // 16+ -> level 4
    if (count <= 5) return 1;
    if (count <= 10) return 2;
    if (count <= 15) return 3;
    return 4;
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

// Day labels and color legend are removed as requested; heatmap spans full card width.
