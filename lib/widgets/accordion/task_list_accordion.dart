import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';

class TaskListAccordion extends StatelessWidget {
  final List<AccordionSection> children;

  const TaskListAccordion({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Accordion(
      headerBorderColor: Colors.blueGrey,
      headerBorderColorOpened: Colors.transparent,
      headerPadding: const EdgeInsets.symmetric(horizontal: 10),
      contentBackgroundColor: Theme.of(context).canvasColor,
      contentBorderColor: Colors.transparent,
      contentBorderWidth: 0,
      openAndCloseAnimation: true,
      scaleWhenAnimating: false,
      paddingBetweenClosedSections: 10,
      paddingListTop: 10,
      sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
      sectionClosingHapticFeedback: SectionHapticFeedback.light,
      children: children,
    );
  }
}
