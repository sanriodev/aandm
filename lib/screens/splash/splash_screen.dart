import 'package:aandm/backend/service/auth_backend_service.dart';
import 'package:aandm/util/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AuthBackend authBackend = AuthBackend();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _topFigureAnimation;
  late Animation<Offset> _bottomFigureAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Fade animation for the center logo
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    // Animation for top figure sliding in from the left
    _topFigureAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    // Animation for bottom figure sliding in from the right
    _bottomFigureAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();

    if (authBackend.loggedInUser != null) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          navigateToRoute(context, 'home');
        }
      });
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          navigateToRoute(context, 'login');
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).primaryColor,
          ),
          Positioned(
            top: 0,
            left: 0,
            child: SlideTransition(
              position: _topFigureAnimation,
              child: Theme.of(context).brightness == Brightness.light
                  ? SvgPicture.asset(
                      'assets/icons/top_figure.svg',
                    )
                  : SvgPicture.asset(
                      'assets/icons/top_figure_dark.svg',
                    ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SlideTransition(
              position: _bottomFigureAnimation,
              child: Theme.of(context).brightness == Brightness.light
                  ? SvgPicture.asset(
                      'assets/icons/bottom_figure.svg',
                    )
                  : SvgPicture.asset(
                      'assets/icons/bottom_figure_dark.svg',
                    ),
            ),
          ),
          // Positioned(
          //   bottom: 50,
          //   left: 45,
          //   child: Theme.of(context).brightness == Brightness.light
          //       ? SvgPicture.asset(
          //           height: 50,
          //           'assets/icons/tirol.svg',
          //         )
          //       : SvgPicture.asset(
          //           height: 50,
          //           'assets/icons/tirol_dark.svg',
          //         ),
          // ),
          // Positioned.fill(
          //   bottom: 60,
          //   child: Align(
          //     alignment: Alignment.bottomCenter,
          //     child: Theme.of(context).brightness == Brightness.light
          //         ? SvgPicture.asset(
          //             height: 30,
          //             'assets/icons/atm.svg',
          //           )
          //         : SvgPicture.asset(
          //             height: 30,
          //             'assets/icons/atm_dark.svg',
          //           ),
          //   ),
          // ),
          // Positioned(
          //   bottom: 50,
          //   right: 45,
          //   child: Theme.of(context).brightness == Brightness.light
          //       ? SvgPicture.asset(
          //           height: 50,
          //           'assets/icons/uws.svg',
          //         )
          //       : SvgPicture.asset(
          //           height: 50,
          //           'assets/icons/uws_dark.svg',
          //         ),
          // ),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/logo.svg',
                    height: 200,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
