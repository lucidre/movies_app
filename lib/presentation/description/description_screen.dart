import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:movies_app/constants/numbers.dart';
import 'package:movies_app/constants/strings.dart';
import 'package:movies_app/constants/style.dart';
import 'package:movies_app/models/movie.dart';
import 'package:movies_app/routing/app_router.gr.dart';
import 'package:movies_app/widgets/elevated_button.dart';
import 'package:separated_row/separated_row.dart';

class DescriptionScreen extends StatefulWidget {
  final Movie movie;
  const DescriptionScreen({
    super.key,
    required this.movie,
  });

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  bool heroAnimationCompleted = false;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1;
    final bodyText2 = textTheme.bodyText2;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: darkColor,
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(context),
      body: buildBody(height, bodyText1, bodyText2),
    );
  }

  Stack buildBody(double height, TextStyle? bodyText1, TextStyle? bodyText2) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: height * .4,
          child: Hero(
            tag: widget.movie.posterUrl,
            createRectTween: (begin, end) =>
                RectTween(begin: begin!, end: end!),
            child: CachedNetworkImage(
              imageUrl: widget.movie.posterUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => Container(
                color: darkColor,
              ),
              errorWidget: (context, url, error) => Container(
                color: darkColor,
              ),
            ),
          ),
        ),
        Positioned(
          height: height * .8,
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(kDefaultPadding),
            decoration: const BoxDecoration(
              color: lightColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                buildMainBody(bodyText1, bodyText2),
                const SizedBox(
                  height: kDefaultMargin / 4,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Hero(
                    tag: "book_appointment",
                    createRectTween: (begin, end) =>
                        RectTween(begin: begin!, end: end!),
                    flightShuttleBuilder: (flightContext, animation,
                        flightDirection, fromHeroContext, toHeroContext) {
                      animation.addStatusListener((status) {
                        if (status == AnimationStatus.completed) {
                          setState(() => heroAnimationCompleted = true);
                        }
                        if (status == AnimationStatus.dismissed) {
                          setState(() => heroAnimationCompleted = false);
                        }
                      });

                      return CircularReveal.buildTransitions(
                          animation, toHeroContext.widget);
                      /*        return RotationTransition(
                        turns: animation.drive(
                          Tween<double>(
                                  begin: (heroAnimationCompleted) ? 1.0 : -0.8,
                                  end: (heroAnimationCompleted) ? 0.8 : -1.0)
                              .chain(CurveTween(
                                  curve: (heroAnimationCompleted)
                                      ? const Cubic(0.4, 0.90, 1.0, 1.250)
                                          .flipped
                                      : const Cubic(0.4, 0.90, 1.0, 1.250))),
                        ),
                        child: toHeroContext.widget,
                      ); */
                    },
                    child: CustomElevatedButton(
                      onPressed: () {
                        context.router
                            .push(BookAppointmentRoute(movie: widget.movie));
                      },
                      text: "BUY TICKET",
                    ),
                  ),
                ),
                const SizedBox(
                  height: kDefaultMargin / 4,
                ),
              ],
            ),
          ).animate().fade(
                duration: const Duration(milliseconds: 600),
              ),
        )
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(
          Icons.close_rounded,
          color: lightColor,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.flip_camera_android_rounded,
            color: lightColor,
          ),
        ),
      ],
    );
  }

  Expanded buildMainBody(TextStyle? bodyText1, TextStyle? bodyText2) {
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          Text(
            widget.movie.title,
            style: bodyText1?.copyWith(
              fontSize: 34,
            ),
          ).animate().slide(
              delay: const Duration(
                milliseconds: 150,
              ),
              duration: const Duration(
                milliseconds: 400,
              )),
          const SizedBox(
            height: kDefaultMargin / 2,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: widget.movie.chips
                .map(
                  (title) => _ChipItem(title: title),
                )
                .toList(),
          ),
          const SizedBox(
            height: kDefaultMargin / 2,
          ),
          buildRating(bodyText2),
          const SizedBox(
            height: kDefaultMargin / 2,
          ),
          buildDots(),
          const SizedBox(
            height: kDefaultMargin,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Actors',
              style: bodyText1?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: kDefaultMargin / 4,
          ),
          buildActors(bodyText2),
          const SizedBox(
            height: kDefaultMargin,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Introduction',
              style: bodyText1?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: kDefaultMargin / 4,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "${widget.movie.introduction} $loremIspidiumLong\n\n$loremIspidiumLong $loremIspidiumLong",
              style: bodyText2,
            ),
          ),
          //
          const SizedBox(
            height: kDefaultMargin * 4,
          ),
        ]),
      ),
    );
  }

  SingleChildScrollView buildActors(TextStyle? bodyText2) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      child: SeparatedRow(
        separatorBuilder: (_, __) => const SizedBox(
          width: kDefaultMargin / 2,
        ),
        children: widget.movie.actors
            .map(
              (actor) => Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      color: lightColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: 

                        CachedNetworkImage(
                imageUrl:        actor.image,
                fit: BoxFit.cover,
                       width: double.infinity,
              height: double.infinity,
                placeholder: (context, url) => Container(
                  color: darkColor,
                ),
                errorWidget: (context, url, error) => Container(
                  color: darkColor,
                ),
              ),
                  ),
                  Text(
                    actor.name,
                    style: bodyText2,
                  ),
                ],
              ).animate().fade(
                  delay: const Duration(
                    milliseconds: 150,
                  ),
                  duration: const Duration(
                    milliseconds: 400,
                  )),
            )
            .toList(),
      ),
    );
  }

  Row buildDots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            color: darkColor,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(
          width: kDefaultMargin / 5,
        ),
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            color: darkColor,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(
          width: kDefaultMargin / 5,
        ),
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            color: darkColor,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    );
  }

  Animate buildRating(TextStyle? bodyText2) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '9.0',
          style: bodyText2?.copyWith(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          width: kDefaultMargin / 5,
        ),
        Icon(
          Icons.star,
          color: Colors.amber[600],
          size: 16,
        ),
        Icon(
          Icons.star,
          color: Colors.amber[600],
          size: 16,
        ),
        Icon(
          Icons.star,
          color: Colors.amber[600],
          size: 16,
        ),
        Icon(
          Icons.star,
          color: Colors.amber[600],
          size: 16,
        ),
        const Icon(
          Icons.star_border_outlined,
          size: 16,
        ),
      ],
    ).animate().slide(
        delay: const Duration(
          milliseconds: 150,
        ),
        duration: const Duration(
          milliseconds: 400,
        ));
  }
}

class _ChipItem extends StatelessWidget {
  final String title;
  const _ChipItem({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText2 = textTheme.bodyText2;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultMargin / 4),
      padding: const EdgeInsets.only(
        left: kDefaultPadding / 2,
        right: kDefaultPadding / 2,
        top: kDefaultPadding / 4,
        bottom: kDefaultPadding / 4,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: darkColor.withOpacity(.5),
          width: .5,
        ),
        borderRadius: BorderRadius.circular(
          kDefaultMargin,
        ),
      ),
      child: Text(
        title,
        style: bodyText2,
      ),
    ).animate().slide(
        delay: const Duration(
          milliseconds: 150,
        ),
        duration: const Duration(
          milliseconds: 400,
        ));
  }
}

class CircularReveal {
  static Widget buildTransitions(Animation<double> animation, Widget child) {
    return CurveTransition(
      scale: animation,
      child: child,
    );
  }
}

class CurveTransition extends AnimatedWidget {
  const CurveTransition({
    Key? key,
    required Animation<double> scale,
    this.alignment = Alignment.center,
    this.child,
  }) : super(key: key, listenable: scale);

  Animation<double> get scale => listenable as Animation<double>;

  final Alignment alignment;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      clipper: CircularRevealClipper(
        revealPercent: scale.value,
      ),
      child: child,
    );
  }
}

class CircularRevealClipper extends CustomClipper<Rect> {
  final double revealPercent;

  CircularRevealClipper({required this.revealPercent});

  @override
  Rect getClip(Size size) {
    // center of rectangle
    final center = Offset(size.width / 2, size.height * 0.9);

    // Calculate distance from center to the top left corner to make sure we fill the screen via simple trigonometry.
    double theta = atan(center.dy / center.dx);
    final distanceToCorner = center.dy / sin(theta);

    final radius = distanceToCorner * revealPercent;
    final diameter = 2 * radius;

    return Rect.fromLTWH(
        center.dx - radius, center.dy - radius, diameter, diameter);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
