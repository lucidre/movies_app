import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/constants/strings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  //fade in transition for logo and app name
  Animation<double>? _opacityAnimation;
  AnimationController? _controller;

  final Duration _duration = const Duration(milliseconds: 2000);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final heading1 = textTheme.headline1!;

    return Scaffold(
      body: buildBody(heading1),
    );
  }

  FadeTransition buildBody(TextStyle heading1) {
    return FadeTransition(
      opacity: _opacityAnimation!,
      child: Center(
        child: Hero(
          tag: 'background',
          child: Image.asset(
            logoLocation,
            width: 500,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    setUpAnimation();
  }

  void setUpAnimation() {
    //initialize controller and animation
    _controller = AnimationController(
      vsync: this,
      duration: _duration,
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.easeIn,
      ),
    );

    // action on animation completion
    _controller?.addListener(() {
      if (_controller!.isCompleted) {
        startTime();
      }
    });

    // 2 seconds delay before animation starts
    var duration = const Duration(seconds: 2);
    Timer(duration, () {
      _controller?.forward();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void route() {
    // context.router.replace(const HomeScreen());
  }

  Future startTime() async {
    const duration = Duration(seconds: 2);
    return Timer(duration, route);
  }
}
