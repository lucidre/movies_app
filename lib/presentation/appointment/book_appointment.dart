// ignore_for_file: unused_field

import 'dart:math';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:movies_app/constants/numbers.dart';
import 'package:movies_app/constants/style.dart';
import 'package:movies_app/models/movie.dart';
import 'package:movies_app/widgets/elevated_button.dart';

String _getSeatName(_CinemaSeatModel model, [bool includeChild = false]) {
  final List<String> columnNames = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    "J",
    'K',
    'L',
    'M',
    "N"
  ];
  return columnNames[model.columnIndex - 1] +
      (includeChild ? model.childIndex.toString() : '');
}

class BookAppointmentScreen extends StatefulWidget {
  final Movie movie;
  const BookAppointmentScreen({super.key, required this.movie});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final List<_CinemaSeatModel> _selectedSeats = [];
  final List<_CinemaSeatModel> _occupiedSeats = [];
  final rnd = Random();
  DateTime? _selectedDate;
  String _selectedTime = '';
  final List<String> _dateTimes = [
    '08:00',
    '10:00',
    '14:00',
    '16:00',
    '20:00',
  ];
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), generateRandomValue);
  }

  generateRandomValue() async {
    for (var i = 0; i < 15; i++) {
      final columnIndex = rnd.nextInt(10) + 1;
      final childIndex = rnd.nextInt(columnIndex == 0 ? 6 : 8);
      final model = _CinemaSeatModel(columnIndex, childIndex);
      _occupiedSeats.add(model);
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bodyText2 =
        Theme.of(context).textTheme.bodyText2?.copyWith(color: lightColor);
    return Hero(
      tag: "book_appointment",
      createRectTween: (begin, end) => RectTween(begin: begin!, end: end!),
      child: Scaffold(
        backgroundColor: darkColor,
        extendBodyBehindAppBar: true,
        appBar: buildAppBar(context),
        body: Stack(
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: widget.movie.bgUrl,
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
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: darkColor.withOpacity(0.5),
                ),
              ),
            ),
            Positioned.fill(
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.only(
                    left: kDefaultMargin,
                    right: kDefaultMargin,
                    top: kDefaultMargin,
                    bottom: kDefaultMargin,
                  ),
                  child: Column(
                    children: [
                      buildBody(bodyText2),
                      const SizedBox(
                        height: kDefaultMargin,
                      ),
                      CustomElevatedButton(
                        onPressed: () {},
                        color: widget.movie.color.withOpacity(.8),
                        text: 'CHECKOUT',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Path drawPath() {
    final width = MediaQuery.of(context).size.width - (kDefaultPadding * 2);
    const height = 60.0;
    final path = Path();
    final segmentWidth = width / 6;

    path.moveTo(0, height);
    path.cubicTo(0, height, segmentWidth / 2, 5, 3 * segmentWidth, 5);
    path.cubicTo(
        3 * segmentWidth, 5, 5 * segmentWidth, 5, 6 * segmentWidth, height);

    return path;
  }

  Expanded buildBody(TextStyle? bodyText2) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 60),
              painter: PathPainter(
                widget.movie.color,
                path: drawPath(),
              ),
            ),
            const SizedBox(
              height: kDefaultMargin,
            ),
            _CinemaColumn(
              selectedColor: widget.movie.color,
              onItemSelected: onItemSelected,
              isItemSelected: isItemSelected,
              isItemOccupied: isItemOccupied,
            ),
            const SizedBox(
              height: kDefaultMargin,
            ),
            buildDescription(),
            const SizedBox(
              height: kDefaultMargin * 1.5,
            ),
            SizedBox(
              height: 110,
              child: DatePicker(
                DateTime.now(),
                monthTextStyle: bodyText2!,
                dayTextStyle: bodyText2,
                dateTextStyle: bodyText2,
                initialSelectedDate: DateTime.now(),
                selectionColor: widget.movie.color,
                selectedTextColor: lightColor,
                onDateChange: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ).animate(delay: const Duration(milliseconds: 100)).move(
                    duration: const Duration(milliseconds: 1000),
                  ),
            ),
            const SizedBox(
              height: kDefaultMargin * 1.5,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _dateTimes
                    .map((time) => _ChipItem(
                          color: _selectedTime != time
                              ? Colors.grey.withOpacity(.3)
                              : widget.movie.color,
                          title: time,
                          onPressed: () {
                            setState(() {
                              _selectedTime = time;
                            });
                          },
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(
              height: kDefaultMargin,
            ),
          ],
        ),
      ),
    );
  }

  Row buildDescription() {
    final bodyText2 =
        Theme.of(context).textTheme.bodyText2?.copyWith(color: lightColor);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            _CinemaSeat(
              isOccupied: false,
              isSelected: false,
              cancelAnimation: true,
              onPressed: () {},
              selectedColor: widget.movie.color,
            ),
            Text(
              "Availiable",
              style: bodyText2,
            ),
          ],
        )
            .animate(delay: const Duration(milliseconds: 300))
            .fade(duration: const Duration(milliseconds: 500)),
        Row(
          children: [
            _CinemaSeat(
                isOccupied: false,
                isSelected: true,
                cancelAnimation: true,
                onPressed: () {},
                selectedColor: widget.movie.color),
            Text(
              "Selected",
              style: bodyText2,
            ),
          ],
        )
            .animate(delay: const Duration(milliseconds: 300))
            .fade(duration: const Duration(milliseconds: 500)),
        Row(
          children: [
            _CinemaSeat(
              cancelAnimation: true,
              isOccupied: true,
              isSelected: false,
              onPressed: () {},
              selectedColor: widget.movie.color,
            ),
            Text(
              "Booked",
              style: bodyText2,
            ),
          ],
        )
            .animate(delay: const Duration(milliseconds: 300))
            .fade(duration: const Duration(milliseconds: 500)),
      ],
    );
  }

  void onItemSelected(int columnIndex, int childIndex) {
    final model = _CinemaSeatModel(columnIndex, childIndex);

    if (_selectedSeats.contains(model)) {
      _selectedSeats.remove(model);
    } else {
      _selectedSeats.add(model);
    }

    setState(() {});
  }

  bool isItemSelected(int columnIndex, int childIndex) {
    return _selectedSeats.contains(
      _CinemaSeatModel(columnIndex, childIndex),
    );
  }

  bool isItemOccupied(int columnIndex, int childIndex) {
    return _occupiedSeats.contains(
      _CinemaSeatModel(columnIndex, childIndex),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    final bodyText1 =
        Theme.of(context).textTheme.bodyText1?.copyWith(color: lightColor);
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
      title: Text(
        widget.movie.title,
        style: bodyText1,
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

class _CinemaColumn extends StatelessWidget {
  final Function(int, int) onItemSelected;
  final Color selectedColor;
  final bool Function(int, int) isItemSelected;
  final bool Function(int, int) isItemOccupied;
  const _CinemaColumn(
      {Key? key,
      required this.onItemSelected,
      required this.isItemSelected,
      required this.isItemOccupied,
      required this.selectedColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CinemaRow(
          index: 1,
          numberOfSeats: 6,
          selectedColor: selectedColor,
          onItemSelected: (itemIndex) => onItemSelected(1, itemIndex),
          isItemSelected: (itemIndex) => isItemSelected(1, itemIndex),
          isItemOccupied: (itemIndex) => isItemOccupied(1, itemIndex),
        ),
        _CinemaRow(
          index: 2,
          numberOfSeats: 8,
          selectedColor: selectedColor,
          onItemSelected: (itemIndex) => onItemSelected(2, itemIndex),
          isItemSelected: (itemIndex) => isItemSelected(2, itemIndex),
          isItemOccupied: (itemIndex) => isItemOccupied(2, itemIndex),
        ),
        _CinemaRow(
          index: 3,
          numberOfSeats: 8,
          selectedColor: selectedColor,
          onItemSelected: (itemIndex) => onItemSelected(3, itemIndex),
          isItemSelected: (itemIndex) => isItemSelected(3, itemIndex),
          isItemOccupied: (itemIndex) => isItemOccupied(3, itemIndex),
        ),
        _CinemaRow(
          index: 4,
          numberOfSeats: 8,
          selectedColor: selectedColor,
          onItemSelected: (itemIndex) => onItemSelected(4, itemIndex),
          isItemSelected: (itemIndex) => isItemSelected(4, itemIndex),
          isItemOccupied: (itemIndex) => isItemOccupied(4, itemIndex),
        ),
        _CinemaRow(
          index: 5,
          numberOfSeats: 8,
          selectedColor: selectedColor,
          onItemSelected: (itemIndex) => onItemSelected(5, itemIndex),
          isItemSelected: (itemIndex) => isItemSelected(5, itemIndex),
          isItemOccupied: (itemIndex) => isItemOccupied(5, itemIndex),
        ),
        const SizedBox(
          height: kDefaultMargin,
        ),
        _CinemaRow(
          index: 6,
          numberOfSeats: 8,
          selectedColor: selectedColor,
          onItemSelected: (itemIndex) => onItemSelected(6, itemIndex),
          isItemSelected: (itemIndex) => isItemSelected(6, itemIndex),
          isItemOccupied: (itemIndex) => isItemOccupied(6, itemIndex),
        ),
        _CinemaRow(
          index: 7,
          numberOfSeats: 8,
          selectedColor: selectedColor,
          onItemSelected: (itemIndex) => onItemSelected(7, itemIndex),
          isItemSelected: (itemIndex) => isItemSelected(7, itemIndex),
          isItemOccupied: (itemIndex) => isItemOccupied(7, itemIndex),
        ),
        _CinemaRow(
          index: 8,
          numberOfSeats: 8,
          selectedColor: selectedColor,
          onItemSelected: (itemIndex) => onItemSelected(8, itemIndex),
          isItemSelected: (itemIndex) => isItemSelected(8, itemIndex),
          isItemOccupied: (itemIndex) => isItemOccupied(8, itemIndex),
        ),
        _CinemaRow(
          index: 9,
          numberOfSeats: 8,
          selectedColor: selectedColor,
          onItemSelected: (itemIndex) => onItemSelected(9, itemIndex),
          isItemSelected: (itemIndex) => isItemSelected(9, itemIndex),
          isItemOccupied: (itemIndex) => isItemOccupied(9, itemIndex),
        ),
        _CinemaRow(
          index: 10,
          numberOfSeats: 8,
          selectedColor: selectedColor,
          onItemSelected: (itemIndex) => onItemSelected(10, itemIndex),
          isItemSelected: (itemIndex) => isItemSelected(10, itemIndex),
          isItemOccupied: (itemIndex) => isItemOccupied(10, itemIndex),
        ),
      ],
    );
  }
}

class _CinemaSeat extends StatelessWidget {
  final bool isOccupied;
  final Color selectedColor;
  final bool isSelected;
  final VoidCallback onPressed;
  final bool cancelAnimation;

  const _CinemaSeat({
    Key? key,
    required this.isOccupied,
    required this.isSelected,
    required this.onPressed,
    required this.selectedColor,
    this.cancelAnimation = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!isOccupied) {
          onPressed();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(kDefaultMargin / 4),
        child: Icon(
          Icons.event_seat_rounded,
          size: 22,
          color: isOccupied
              ? Colors.red
              : isSelected
                  ? selectedColor
                  : lightColor,
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: cancelAnimation ? 0 : 300))
        .slide(duration: Duration(milliseconds: cancelAnimation ? 0 : 1000))
        .fade(duration: Duration(milliseconds: cancelAnimation ? 0 : 500));
  }
}

class _CinemaRow extends StatelessWidget {
  final int index;
  final Color selectedColor;
  final int numberOfSeats;
  final Function(int) onItemSelected;
  final bool Function(int) isItemSelected;
  final bool Function(int) isItemOccupied;

  const _CinemaRow(
      {Key? key,
      required this.index,
      required this.onItemSelected,
      required this.isItemSelected,
      required this.isItemOccupied,
      required this.numberOfSeats,
      required this.selectedColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bodyText2 =
        Theme.of(context).textTheme.bodyText2?.copyWith(color: lightColor);
    final List<Widget> seats = [];
    for (int i = 0; i < numberOfSeats; i++) {
      seats.add(
        _CinemaSeat(
          selectedColor: selectedColor,
          isOccupied: isItemOccupied(i),
          isSelected: isItemSelected(i),
          onPressed: () => onItemSelected(i),
        ),
      );
    }
    seats.insert(
      seats.length ~/ 2,
      const SizedBox(
        width: kDefaultMargin,
      ),
    );

    return Row(
      children: [
        Text(
          _getSeatName(_CinemaSeatModel(index, 0)),
          style: bodyText2,
        )
            .animate(delay: const Duration(milliseconds: 300))
            .fade(duration: const Duration(milliseconds: 100)),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: seats,
          ),
        ),
        Text(
          _getSeatName(_CinemaSeatModel(index, 0)),
          style: bodyText2,
        )
            .animate(delay: const Duration(milliseconds: 300))
            .fade(duration: const Duration(milliseconds: 100)),
      ],
    );
  }
}

class _CinemaSeatModel {
  final int columnIndex;
  final int childIndex;

  _CinemaSeatModel(this.columnIndex, this.childIndex);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! _CinemaSeatModel) return false;
    return columnIndex == other.columnIndex && childIndex == other.childIndex;
  }

  @override
  int get hashCode => childIndex.hashCode ^ columnIndex.hashCode;
}

class _ChipItem extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onPressed;
  const _ChipItem({
    Key? key,
    required this.color,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText2 = textTheme.bodyText2?.copyWith(color: lightColor);
    return InkWell(
      splashColor: Colors.transparent,
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        key: UniqueKey(),
        margin: const EdgeInsets.symmetric(horizontal: kDefaultMargin / 4),
        padding: const EdgeInsets.only(
          left: kDefaultPadding,
          right: kDefaultPadding,
          top: kDefaultPadding / 4,
          bottom: kDefaultPadding / 4,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(
            kDefaultMargin / 4,
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
          ),
    );
  }
}

class PathPainter extends CustomPainter {
  final Color color;
  Path path;
  PathPainter(this.color, {required this.path});
  @override
  void paint(Canvas canvas, Size size) {
    // paint the line
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    canvas.drawPath(path, paint);

    canvas.drawShadow(path, color.withOpacity(.3), 3.0, true);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
