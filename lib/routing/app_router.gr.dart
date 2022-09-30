// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;

import '../models/movie.dart' as _i6;
import '../presentation/appointment/book_appointment.dart' as _i3;
import '../presentation/description/description_screen.dart' as _i2;
import '../presentation/home/home_screen.dart' as _i1;

class AppRouter extends _i4.RootStackRouter {
  AppRouter([_i5.GlobalKey<_i5.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.HomeScreen(),
      );
    },
    DescriptionRoute.name: (routeData) {
      final args = routeData.argsAs<DescriptionRouteArgs>();
      return _i4.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i2.DescriptionScreen(
          key: args.key,
          movie: args.movie,
        ),
      );
    },
    BookAppointmentRoute.name: (routeData) {
      final args = routeData.argsAs<BookAppointmentRouteArgs>();
      return _i4.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i3.BookAppointmentScreen(
          key: args.key,
          movie: args.movie,
        ),
      );
    },
  };

  @override
  List<_i4.RouteConfig> get routes => [
        _i4.RouteConfig(
          HomeRoute.name,
          path: '/',
        ),
        _i4.RouteConfig(
          DescriptionRoute.name,
          path: '/description-screen',
        ),
        _i4.RouteConfig(
          BookAppointmentRoute.name,
          path: '/book-appointment-screen',
        ),
      ];
}

/// generated route for
/// [_i1.HomeScreen]
class HomeRoute extends _i4.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i2.DescriptionScreen]
class DescriptionRoute extends _i4.PageRouteInfo<DescriptionRouteArgs> {
  DescriptionRoute({
    _i5.Key? key,
    required _i6.Movie movie,
  }) : super(
          DescriptionRoute.name,
          path: '/description-screen',
          args: DescriptionRouteArgs(
            key: key,
            movie: movie,
          ),
        );

  static const String name = 'DescriptionRoute';
}

class DescriptionRouteArgs {
  const DescriptionRouteArgs({
    this.key,
    required this.movie,
  });

  final _i5.Key? key;

  final _i6.Movie movie;

  @override
  String toString() {
    return 'DescriptionRouteArgs{key: $key, movie: $movie}';
  }
}

/// generated route for
/// [_i3.BookAppointmentScreen]
class BookAppointmentRoute extends _i4.PageRouteInfo<BookAppointmentRouteArgs> {
  BookAppointmentRoute({
    _i5.Key? key,
    required _i6.Movie movie,
  }) : super(
          BookAppointmentRoute.name,
          path: '/book-appointment-screen',
          args: BookAppointmentRouteArgs(
            key: key,
            movie: movie,
          ),
        );

  static const String name = 'BookAppointmentRoute';
}

class BookAppointmentRouteArgs {
  const BookAppointmentRouteArgs({
    this.key,
    required this.movie,
  });

  final _i5.Key? key;

  final _i6.Movie movie;

  @override
  String toString() {
    return 'BookAppointmentRouteArgs{key: $key, movie: $movie}';
  }
}
