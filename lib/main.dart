import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app/constants/strings.dart';
import 'package:movies_app/constants/style.dart';

import 'routing/app_router.gr.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
        scaffoldBackgroundColor: lightColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: primaryColor),
        canvasColor: lightColor,
        dialogBackgroundColor: lightColor,
        floatingActionButtonTheme: ThemeData.light()
            .floatingActionButtonTheme
            .copyWith(backgroundColor: primaryColor),
        cardColor: lightColor,
        iconTheme: ThemeData.light().iconTheme.copyWith(color: primaryColor),
        textTheme: GoogleFonts.cairoTextTheme(
          Theme.of(context).textTheme.copyWith(
                bodyText1: const TextStyle(
                  fontSize: 16,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                bodyText2: const TextStyle(
                  fontSize: 12,
                  color: primaryColor,
                ),
              ),
        ).apply(
          bodyColor: primaryColor,
        ));

    return MaterialApp.router(
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: theme,
    );
  }
}
