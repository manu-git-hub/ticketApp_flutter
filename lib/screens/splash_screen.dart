import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrcode_scanner/screens/homepage.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<Offset> _underlineAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _animationController, curve: Curves.easeInOutQuint));

    _underlineAnimation =
        Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.7, 1.0),
      ),
    );

    _animationController.forward().then((value) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) =>  const MyHomePage()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Text(
                    'Entry Pass',
                    style: GoogleFonts.mPlus1(
                      fontWeight: FontWeight.w900,
                      fontSize: 38,
                      letterSpacing: 8.0,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: SlideTransition(
                      position: _underlineAnimation,
                      child: Container(
                        width: 1000,
                        height: 4,
                        color: isDarkMode ? Colors.blue : Colors.blue[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
