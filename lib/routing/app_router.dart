import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/presentation/appointment/book_appointment.dart';
import 'package:movies_app/presentation/description/description_screen.dart';
import 'package:movies_app/presentation/home/home_screen.dart';

Route<T> fadePageBuilder<T>(
    BuildContext context, Widget child, CustomPage page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 800),
    reverseTransitionDuration: const Duration(milliseconds: 900),
    settings: page,
    pageBuilder: (_, __, ___) => child,
    transitionsBuilder: (_, anim1, __, child) => FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(anim1),
      child: child,
    ),
  );
}

@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: HomeScreen,
      initial: true,
    ),
    AutoRoute(
      page: DescriptionScreen,
    ),
    AutoRoute(
      page: BookAppointmentScreen,
    ),
  ],
)
class $AppRouter {}
