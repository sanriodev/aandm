import 'package:aandm/util/helpers.dart';
import 'package:aandm/widgets/navigation/bottom_menu_navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BottomMenu extends StatelessWidget {
  const BottomMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final int current = getCurrentIndex(context);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).secondaryHeaderColor),
        ),
        color: Theme.of(context).appBarTheme.foregroundColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomNavigationBar(
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).appBarTheme.foregroundColor,
            enableFeedback: true,
            iconSize: 26,
            elevation: 8,
            useLegacyColorScheme: false,
            selectedFontSize: 11,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedFontSize: 10,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor:
                Theme.of(context).appBarTheme.titleTextStyle!.color,
            currentIndex: current,
            onTap: (int index) {
              navigateToRoute(
                context,
                _pages[index].materialRoute,
              );
            },
            items: _pages,
          ),
        ],
      ),
    );
  }

  int getCurrentIndex(BuildContext context) {
    final String route = ModalRoute.of(context)!.settings.name!;
    for (int i = 0; i < _pages.length; i++) {
      if (_pages[i].materialRoute == route) {
        return i;
      }
    }
    return 0;
  }
}

const List<BottomMenuNavigationItem> _pages = [
  BottomMenuNavigationItem(
    icon: PhosphorIcon(PhosphorIconsRegular.house),
    label: 'Home',
    materialRoute: 'home',
  ),
  BottomMenuNavigationItem(
    icon: PhosphorIcon(PhosphorIconsRegular.list),
    label: 'Listen',
    materialRoute: 'task-lists',
  ),
  BottomMenuNavigationItem(
    icon: PhosphorIcon(PhosphorIconsRegular.note),
    label: 'Notizen',
    materialRoute: 'notes',
  ),
  BottomMenuNavigationItem(
    icon: PhosphorIcon(PhosphorIconsRegular.clock),
    label: 'Timer',
    materialRoute: 'timer',
  ),
];
