import 'package:aandm/backend/service/auth_backend_service.dart';
import 'package:aandm/models/user/user_model.dart';
import 'package:aandm/screens/home/main_app_screen.dart';
import 'package:aandm/util/helpers.dart';
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

  User? _ownUser;

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    _getOwnUser();
  }

  Future<void> _getOwnUser() async {
    final res = await AuthBackend().getOwnUser();
    setState(() {
      _ownUser = res;
    });
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
                        'Alina\'s App\nI love Alina',
                        style: Theme.of(context).primaryTextTheme.displayLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              onTap: () {
                if (MainAppScreen.of(context)!.currentTheme == ThemeMode.dark) {
                  MainAppScreen.of(context)!.currentTheme = ThemeMode.light;
                  setState(() {
                    MainAppScreen.of(context)!.changeTheme(ThemeMode.light);
                  });
                } else {
                  MainAppScreen.of(context)!.currentTheme = ThemeMode.dark;
                  setState(() {
                    MainAppScreen.of(context)!.changeTheme(ThemeMode.dark);
                  });
                }
                setState(() {});
              },
              leading: PhosphorIcon(
                MainAppScreen.of(context)!.currentTheme == ThemeMode.dark
                    ? PhosphorIconsRegular.sun
                    : PhosphorIconsRegular.moon,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              title: Text(
                'Theme ändern',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            ListTile(
              onTap: () {},
              leading: PhosphorIcon(
                PhosphorIcons.pulse(),
                color: Theme.of(context).primaryIconTheme.color,
              ),
              title: Text(
                'Aktivität - ${_ownUser != null && _ownUser!.publicActivity ? 'Öffentlich' : 'Privat'}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const Spacer(),
            ListTile(
              onTap: () {
                deleteBoxAndNavigateToLogin(context);
              },
              leading: PhosphorIcon(
                PhosphorIconsRegular.signOut,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              title: Text(
                'Abmelden',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      launchUrlInBrowser(
                        Uri.parse(
                          "https://blvckleg.dev/app-legal",
                        ),
                      );
                    },
                    child: Text(
                      'Datenschutz',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  ),
                  Container(
                    height: 12,
                    width: 1,
                  ),
                  TextButton(
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
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 30)),
          ],
        ),
      ),
    );
  }
}
