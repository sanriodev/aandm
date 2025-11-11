// ignore_for_file: use_build_context_synchronously

import 'package:aandm/backend/service/backend_service.dart';
import 'package:aandm/models/activity/activity_model.dart';
import 'package:aandm/models/exception/session_expired.dart';
import 'package:aandm/util/helpers.dart';
import 'package:aandm/widgets/activity/activity_graph_widget.dart';
import 'package:aandm/widgets/activity/activity_history_widget.dart';
import 'package:aandm/widgets/app_drawer_widget.dart';
import 'package:aandm/widgets/navigation/bottom_menu.dart';
import 'package:aandm/widgets/skeleton/skeleton_card.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  bool isLoading = true;
  String selectedFilterMode = 'own';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<EventlogMessage<dynamic>> activities = [];

  @override
  void initState() {
    super.initState();
    getActivity();
  }

  Future<void> getActivity() async {
    setState(() {
      isLoading = true;
    });
    try {
      final backend = Backend();
      final res = await backend.getActivity(selectedFilterMode);
      setState(() {
        activities = res;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e is SessionExpiredException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bitte melde dich erneut an.')),
        );

        await deleteBoxAndNavigateToLogin(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: const BottomMenu(),
      appBar: AppBar(
        title: Text("Aktivitäten",
            style: Theme.of(context).primaryTextTheme.titleMedium),
        actions: [
          IconButton(
            color: Theme.of(context).primaryIconTheme.color,
            icon: const PhosphorIcon(
              PhosphorIconsRegular.gear,
              semanticLabel: 'Einstellungen',
            ),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: AppDrawer(),
      body: RefreshIndicator(
        color: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        onRefresh: () async {
          setState(() {
            isLoading = true;
          });
          return await getActivity();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLoading)
              Skeletonizer(
                  effect: ShimmerEffect(
                    baseColor: Theme.of(context).canvasColor,
                    duration: const Duration(seconds: 3),
                  ),
                  enabled: isLoading,
                  child: const SkeletonCard()),
            Expanded(
              child: !isLoading
                  ? SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              "Deine Aktivitäten",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleMedium,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ActivityGraphWidget(activities: activities),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              "Letzte Aktivitäten",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleMedium,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ActivityHistoryWidget(
                              activities: activities,
                              maxItems: 20,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
