import 'package:aandm/backend/service/cat_backend_service.dart';
import 'package:aandm/models/cat/cat_facts_api_model.dart';
import 'package:aandm/models/cat/cat_picture_api_model.dart';
import 'package:aandm/screens/home/main_app_screen.dart';
import 'package:aandm/util/helpers.dart';
import 'package:aandm/widgets/app_drawer_widget.dart';
import 'package:aandm/widgets/cat_facts_widget.dart';
import 'package:aandm/widgets/navigation/bottom_menu.dart';
import 'package:aandm/widgets/notes_preview_widget.dart';
import 'package:aandm/widgets/timer_preview_widget.dart';
import 'package:aandm/widgets/to_do_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CatFactsApiModel> catFacts = [];
  List<CatPictureApiModel> catPictures = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getCatData();
    super.initState();
  }

  Future<void> getCatData() async {
    final backend = Provider.of<CatBackend>(context, listen: false);
    try {
      final pictures = await backend.getCatPictures();
      setState(() {
        catPictures = pictures;
      });
    } catch (e) {
      print(e);
    }
    try {
      final facts = await backend.getCatFacts();
      setState(() {
        catFacts = facts;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: const BottomMenu(),
        appBar: AppBar(
          title: Text("Home - I love Alina",
              style: Theme.of(context).primaryTextTheme.titleMedium),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.favorite),
                color: Theme.of(context).primaryIconTheme.color,
                onPressed: () {
                  Fluttertoast.showToast(msg: "I miss you too darling!");
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                color: Theme.of(context).primaryIconTheme.color,
                icon: const PhosphorIcon(
                  PhosphorIconsRegular.gear,
                  semanticLabel: 'Einstellungen',
                ),
                onPressed: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
              ),
            )
          ],
        ),
        endDrawer: AppDrawer(),
        body: RefreshIndicator(
            color: Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            onRefresh: () {
              return getCatData();
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TimerPreviewWidget(
                    themeMode: MainAppScreen.of(context)!.currentTheme!,
                    onPressed: () {
                      navigateToRoute(context, 'timer');
                    },
                  ),
                  TodoPreviewWidget(
                    themeMode: MainAppScreen.of(context)!.currentTheme!,
                    onPressed: () {
                      navigateToRoute(context, 'task-lists');
                    },
                  ),
                  NotesPreviewWidget(
                      themeMode: MainAppScreen.of(context)!.currentTheme!,
                      onPressed: () {
                        navigateToRoute(context, 'notes');
                      }),
                  CatPreviewWidget(
                      catFacts: catFacts, catPictures: catPictures),
                  SizedBox(
                    height: 25,
                  )
                ],
              ),
            )));
  }
}
