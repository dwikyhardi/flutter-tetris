import 'package:flutter/material.dart';
import 'package:tetris/main.dart';
import 'package:tetris/panel/controller.dart';
import 'package:tetris/panel/screen.dart';

part 'page_land.dart';

class PagePortrait extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenW = size.width;
    final screenH = size.height;

    return SizedBox.expand(
      child: Container(
        color: BACKGROUND_COLOR,
        child: _ScreenDecoration(
          child: Screen(
            width: screenW,
            height: screenH,
          ),
        ),
      ),
    );
  }
}

class _ScreenDecoration extends StatelessWidget {
  final Widget child;

  const _ScreenDecoration({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   border: Border(
      //     top: BorderSide(
      //         color: const Color(0xFF90CAF9), width: SCREEN_BORDER_WIDTH),
      //     left: BorderSide(
      //         color: const Color(0xFF90CAF9), width: SCREEN_BORDER_WIDTH),
      //     right: BorderSide(
      //         color: Colors.blue, width: SCREEN_BORDER_WIDTH),
      //     bottom: BorderSide(
      //         color: Colors.blue, width: SCREEN_BORDER_WIDTH),
      //   ),
      // ),
      child: Container(
        child: Container(
          padding: const EdgeInsets.only(left: 2, right: 2, top: 15),
          color: SCREEN_BACKGROUND,
          child: child,
        ),
      ),
    );
  }
}
