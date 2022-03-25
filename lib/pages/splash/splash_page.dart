import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:montanhas_quiz/pages/home/home_page.dart';
import 'package:montanhas_quiz/pages/login/login_page.dart';
import 'package:montanhas_quiz/server/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  void changePage(BuildContext context) {
    _animationController.forward();
    Future.delayed(
      const Duration(seconds: 3),
      () async {
        final prefs = await SharedPreferences.getInstance();
        _animationController.dispose();
        List<String>? user = prefs.getStringList("user");
        if (user != null) {
          if (await AuthProvider().login(email: user[0], password: user[1])) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          }
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        }
      },
    );
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    Intl.defaultLocale = 'pt_BR';
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInCubic));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    changePage(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Hero(
              tag: "montanhas",
              child: Image.asset(
                "assets/montanhas.png",
              ),
            ),
          ),
        ),
      ),
    );
  }
}
