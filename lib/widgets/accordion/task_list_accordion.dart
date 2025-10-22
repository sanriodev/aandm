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
      headerPadding: EdgeInsets.zero,
      contentBackgroundColor: Theme.of(context).canvasColor,
      contentBorderColor: Colors.transparent,
      contentBorderWidth: 0,
      paddingListBottom: 0,
      paddingBetweenOpenSections: 0,
      paddingListHorizontal: 0,
      openAndCloseAnimation: true,
      scaleWhenAnimating: false,
      paddingBetweenClosedSections: 0,
      headerBorderRadius: 12,
      contentBorderRadius: 12,
      headerBorderWidth: 0,
      paddingListTop: 0,
      sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
      sectionClosingHapticFeedback: SectionHapticFeedback.light,
      children: children,
      disableScrolling: true,
    );
  }
}
