import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:movies_app/constants/numbers.dart';
import 'package:movies_app/constants/style.dart';
import 'package:movies_app/models/movie.dart';
import 'package:movies_app/routing/app_router.gr.dart';
import 'package:movies_app/widgets/elevated_button.dart';

//update
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Movie _currentMovie = moviesList[0];
  Movie _newMovie = moviesList[0];
  final _scrollNotifier = ValueNotifier(0.0);

  final _controller = PageController(viewportFraction: .85);

  Offset _imageOffset = const Offset(0, 0);
  double _imageOpacity = 0;
  double _lastScrollValue = 0.0;
  double _screenWidth = 0;

  _scrollListener() {
    final currentPage = _controller.page ?? 0;

    _scrollNotifier.value = currentPage;
    final bool isGoingBack = currentPage - _lastScrollValue <= 0;

    ///adding +1 because if going backward the currentPage.toInt() would return the previous index instead of the current one but going forward is okay
    final currentIndex = currentPage.toInt() + (isGoingBack ? 1 : 0);

    /// get the next item index either going forward or backwards
    /// clamp because at 0 and max adding 1 or removing 1 would result in a value outside the range.
    final nextIndex = (isGoingBack ? currentIndex - 1 : currentIndex + 1)
        .clamp(0, moviesList.length - 1);

    /// to see how close it is to showing
    final difference = (nextIndex - currentPage).abs();
// getting a value of  0 may not happen on swipe finish as currentPage may not exactly be a while number e.g instead of 3 we have 2.999999999
    _imageOpacity = difference <= 0.1 ? 0 : 1;

    final offsetValue = _screenWidth * difference * (isGoingBack ? -1 : 1);

    _imageOffset = Offset(offsetValue, 0);

    ///update active movie only when the front one has completed its animation.
    if (_imageOpacity == 0) _currentMovie = moviesList[nextIndex];
    _newMovie = moviesList[nextIndex];
    setState(() {});

    _lastScrollValue = currentPage;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _screenWidth = MediaQuery.of(context).size.width;
      _controller.addListener(_scrollListener);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  Stack buildBody() {
    final size = MediaQuery.of(context).size;
    return Stack(children: [
      ...backgroundImage,
      Positioned(
          bottom: 0,
          right: 0,
          height: size.height * .65,
          left: 0,
          child: ValueListenableBuilder<double>(
            valueListenable: _scrollNotifier,
            builder: (_, scroll, __) => PageView.builder(
              controller: _controller,
              itemCount: moviesList.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (_, index) {
                final movie = moviesList[index];

                /// calculate how far the widget is from the center. it would be 1
                final offset = (scroll - index).abs();

                /// difference because it gets smaller as it is closer to the center but be need the value to increase as it reaches the center
                final difference = (1 - offset);

                ///  I could have clamped the differnce between 0.8 and 1.0 but it had bad behaviour when the value of the old widget and the one is less than 0.8
                // so using the formular  0.2(value)+ 0.8 we have values between 0.8 and 1 where vaule ranges from 1 to 0.
                final value = (difference * .2) + .8;

                return Transform.scale(
                  scaleY: value,
                  alignment: Alignment.bottomCenter,
                  child: _HomeWidget(movie: movie),
                )
                    .animate()
                    .scale(
                      alignment: Alignment.bottomCenter,
                    )
                    .fade();
              },
            ),
          )),
    ]);
  }

  List<Widget> get backgroundImage => [
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: _currentMovie.bgUrl,
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
        Positioned.fill(
          child: Transform.translate(
            offset: _imageOffset,
            child: Opacity(
              opacity: _imageOpacity,
              child: CachedNetworkImage(
                imageUrl: _newMovie.bgUrl,
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
        )
      ];

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () {},
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
}

class _HomeWidget extends StatelessWidget {
  const _HomeWidget({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1;
    final bodyText2 = textTheme.bodyText2;
    return InkWell(
      onTap: () {
        context.router.push(
          DescriptionRoute(movie: movie),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(
          left: kDefaultMargin / 2,
          right: kDefaultMargin / 2,
        ),
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
            Expanded(
              child: Hero(
                createRectTween: (begin, end) =>
                    RectTween(begin: begin!, end: end!),
                tag: movie.posterUrl,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: movie.posterUrl,
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
            ),
            const SizedBox(
              height: kDefaultMargin / 2,
            ),
            Text(
              movie.title,
              style: bodyText1?.copyWith(
                fontSize: 24,
              ),
            ).animate().fade(),
            const SizedBox(
              height: kDefaultMargin / 2,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: movie.chips
                  .map(
                    (title) => _ChipItem(
                      title: title,
                      uniqueTitle: movie.title,
                    ),
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
              height: kDefaultMargin / 2,
            ),
            CustomElevatedButton(
              onPressed: () {},
              text: "BUY TICKET",
            ),
          ],
        ),
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

  Row buildRating(TextStyle? bodyText2) {
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
    );
  }
}

class _ChipItem extends StatelessWidget {
  final String title;
  final String uniqueTitle;
  const _ChipItem({
    Key? key,
    required this.title,
    required this.uniqueTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText2 = textTheme.bodyText2;
    return Container(
      key: UniqueKey(),
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
    )
        .animate(
          delay: const Duration(milliseconds: 200),
        )
        .fade(
          duration: const Duration(milliseconds: 1000),
        );
  }
}
