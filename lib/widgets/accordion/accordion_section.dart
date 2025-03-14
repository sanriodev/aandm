import 'package:accordion/accordion_section.dart';
import 'package:flutter/material.dart';

class TaskListAccordionSection extends AccordionSection {
  TaskListAccordionSection({
    super.key,
    required super.header,
    required super.content,
    required super.isOpen,
    required Color super.headerBackgroundColor,
    Icon? leftHeaderIcon,
  }) : super(
          contentVerticalPadding: 20,
          leftIcon: leftHeaderIcon,
          rightIcon: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white,
          ),
        );
}
