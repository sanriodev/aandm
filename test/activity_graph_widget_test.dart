import 'package:aandm/models/activity/activity_model.dart';
import 'package:aandm/ui/theme.dart';
import 'package:aandm/widgets/activity/activity_graph_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActivityGraphWidget', () {
    testWidgets('renders correct number of cells for weeks provided',
        (tester) async {
      final weeks = 4;
      // Create sample activities spread across a couple of days.
      final now = DateTime.now();
      final activities = <EventlogMessage<dynamic>>[];
      for (int i = 0; i < 10; i++) {
        activities.add(EventlogMessage(
          actionType: 'create',
          entityType: 'task',
          entityId: 't$i',
          actionStatus: 'ok',
          date: now.subtract(Duration(days: i)),
        ));
      }

      await tester.pumpWidget(MaterialApp(
        theme: appThemeLight,
        home: Scaffold(
          body: ActivityGraphWidget(
            activities: activities,
            weeks: weeks,
            showLegend: false,
          ),
        ),
      ));

      // Week columns * 7 days each
      final expectedCells = weeks * 7;
      int actualCells = 0;
      // Count cells by key prefix.
      final elementList = tester.elementList(find.byType(Container)).toList();
      for (final e in elementList) {
        final key = e.widget.key;
        if (key is ValueKey &&
            key.value.toString().startsWith('activity-cell-')) {
          actualCells++;
        }
      }
      expect(actualCells, expectedCells);
    });

    testWidgets('default weeks is 16 (renders 112 cells)', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: appThemeLight,
        home: const Scaffold(
          body: ActivityGraphWidget(
            activities: [],
            showLegend: false,
          ),
        ),
      ));

      int actualCells = 0;
      final elementList = tester.elementList(find.byType(Container)).toList();
      for (final e in elementList) {
        final key = e.widget.key;
        if (key is ValueKey &&
            key.value.toString().startsWith('activity-cell-')) {
          actualCells++;
        }
      }
      expect(actualCells, 16 * 7);
    });

    testWidgets('bucket mapping produces higher intensity for larger counts',
        (tester) async {
      final today = DateTime.now();
      final activities = <EventlogMessage<dynamic>>[];
      // Generate skewed counts: 1 activity today, 8 yesterday
      activities.add(EventlogMessage(
        actionType: 'a',
        entityType: 'e',
        entityId: '1',
        actionStatus: 'ok',
        date: today,
      ));
      for (int i = 0; i < 8; i++) {
        activities.add(EventlogMessage(
          actionType: 'a',
          entityType: 'e',
          entityId: 'y$i',
          actionStatus: 'ok',
          date: today.subtract(const Duration(days: 1)),
        ));
      }

      await tester.pumpWidget(MaterialApp(
        theme: appThemeLight,
        home: Scaffold(
          body: ActivityGraphWidget(
            activities: activities,
            weeks: 2,
            showLegend: false,
          ),
        ),
      ));

      // Extract container colors for today and yesterday
      final todayKey =
          'activity-cell-${today.toLocal().toIso8601String().substring(0, 10)}';
      final yesterday = today.subtract(const Duration(days: 1));
      final yesterdayKey =
          'activity-cell-${yesterday.toLocal().toIso8601String().substring(0, 10)}';

      Color? colorFor(String key) {
        final finder = find.byKey(ValueKey(key));
        expect(finder, findsOneWidget);
        final container = tester.widget<Container>(finder);
        return container.decoration is BoxDecoration
            ? (container.decoration! as BoxDecoration).color
            : container.color;
      }

      final todayColor = colorFor(todayKey);
      final yesterdayColor = colorFor(yesterdayKey);
      // Yesterday should have a "higher" intensity (darker/greener). Compare relative luminance.
      double luminance(Color c) => c.computeLuminance();
      expect(luminance(yesterdayColor!), isNot(equals(luminance(todayColor!))));
    });
  });
}
