import 'package:aandm/main.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).canvasColor),
        child: Column(
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              width: double.infinity,
              height: 205,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 20,
                      left: 15,
                      child: Text(
                        'Deine\nÜbersicht',
                        style: Theme.of(context).primaryTextTheme.displayLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              onTap: () {
                if (MyApp.of(context)!.currentTheme == ThemeMode.dark) {
                  MyApp.of(context)!.currentTheme = ThemeMode.light;
                  setState(() {
                    MyApp.of(context)!.changeTheme(ThemeMode.light);
                  });
                } else {
                  MyApp.of(context)!.currentTheme = ThemeMode.dark;
                  setState(() {
                    MyApp.of(context)!.changeTheme(ThemeMode.dark);
                  });
                }
                setState(() {});
              },
              leading: PhosphorIcon(
                MyApp.of(context)!.currentTheme == ThemeMode.dark
                    ? PhosphorIconsRegular.sun
                    : PhosphorIconsRegular.moon,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              title: Text(
                'Theme ändern',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor:
                      Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () => showAboutDialog(
                  context: context,
                  applicationVersion: 'Version: ${_packageInfo.version}',
                  applicationName: 'Alina\'s App',
                  children: [
                    Text(
                      'Copyright: MATTEO JUEN',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Entwickelt von:',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      '• MATTEO JUEN',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                child: Text(
                  'Version: ${_packageInfo.version}',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 30)),
          ],
        ),
      ),
    );
  }
}
