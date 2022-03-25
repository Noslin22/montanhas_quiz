import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:montanhas_quiz/pages/splash/splash_page.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Montanhas Quiz',
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText1: GoogleFonts.roboto(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          headline1: GoogleFonts.notoSans(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          headline2: GoogleFonts.notoSans(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          headline3: GoogleFonts.notoSans(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          headline4: GoogleFonts.notoSans(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          headline5: GoogleFonts.notoSans(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
          headline6: GoogleFonts.notoSans(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.maxFinite, 50),
            textStyle: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      home: const SplashPage(),
      scrollBehavior: const ScrollBehavior().copyWith(dragDevices: {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      }),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
    ),
  );
}
