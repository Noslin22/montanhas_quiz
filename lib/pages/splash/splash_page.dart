import 'package:flutter/material.dart';
import 'package:montanhas_quiz/pages/login/login_page.dart';

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
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      ),
    );
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2700),
    )..addListener(() {
        setState(() {});
      });

    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInCubic));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    changePage(context);
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        double scale =
            (constraints.biggest.width / constraints.biggest.height) * 1.5;
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  "assets/quiz_logo.png",
                  scale: scale,
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/interrogacao.png",
                        scale: scale,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Center(
                        child: Image.asset(
                          "assets/montanhas.png",
                          scale: scale,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                height: 10,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (_, __) => LinearProgressIndicator(
                      backgroundColor: const Color(0xffD6D6D6),
                      value: _animation.value,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
