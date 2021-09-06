import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris/gamer/gamer.dart';
import 'package:tetris/material/briks.dart';
import 'package:tetris/material/material.dart';
import 'package:tetris/panel/game_pad_panel.dart';
import 'package:tetris/util/debouncer.dart';
import 'package:vector_math/vector_math_64.dart' as v;

import 'player_panel.dart';
import 'status_panel.dart';

const Color SCREEN_BACKGROUND = Color(0xFF90CAF9);

/// screen H : W;
class Screen extends StatelessWidget {
  ///the with of screen
  final double width;
  final double height;
  double _startPositionHorizontal = 0.0;
  double _endPositionHorizontal = 0.0;
  double _startPositionVertical = 0.0;
  double _endPositionVertical = 0.0;
  Debouncer _debouncer = Debouncer(delay: Duration(milliseconds: 25));

  Screen({Key key, @required this.width, @required this.height})
      : super(key: key);

  Screen.fromHeight(double height)
      : this(width: ((height - 6) / 2 + 6) / 0.6, height: height);

  @override
  Widget build(BuildContext context) {
    final playerPanelWidth = width * 0.7;
    return Shake(
      shake: GameState.of(context).states == GameStates.drop,
      child: SizedBox(
        // height: (playerPanelWidth - 6) * 2 + 6,
        height: height,
        width: width,
        child:
            GameState.of(context).gameControllerType == GameControllerType.touch
                ? _touchController(playerPanelWidth, context)
                : _gamePadController(context),
      ),
    );
  }

  Widget _gamePadController(BuildContext context) {
    final playerPanelWidth = width * 0.6;
    final statusPanelWidth = width * 0.3;
    return Container(
      color: SCREEN_BACKGROUND,
      child: GameMaterial(
        child: BrikSize(
          size: getBrikSizeForScreenWidth(playerPanelWidth),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: <Widget>[
                  PlayerPanel(
                    width: playerPanelWidth,
                  ),
                  SizedBox(
                    width: width * 0.05,
                  ),
                  SizedBox(
                    width: statusPanelWidth,
                    child: StatusPanel(statusPanelWidth),
                  ),
                ],
              ),
              GamePadPanel(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _touchController(double playerPanelWidth, BuildContext context) {
    return Container(
      color: SCREEN_BACKGROUND,
      child: GameMaterial(
        child: BrikSize(
          size: getBrikSizeForScreenWidth(playerPanelWidth),
          child: Column(
            children: <Widget>[
              SizedBox(
                width: width,
                child: StatusPanel(width),
              ),
              GestureDetector(
                onTap: () {
                  if (GameState.of(context).states == GameStates.none) {
                    Game.of(context).pauseOrResume();
                  } else {
                    Game.of(context).rotate();
                  }
                },
                onVerticalDragStart: (DragStartDetails d) {
                  _startPositionVertical = d.localPosition.dy;
                },
                onVerticalDragUpdate: (_) {
                  _endPositionVertical = _.localPosition.dy;
                  Game.of(context).down(enableSounds: true);
                },
                onVerticalDragEnd: (_) {
                  if (_endPositionVertical > (_startPositionVertical + 100)) {
                    Game.of(context).drop();
                  }
                },
                onHorizontalDragStart: (DragStartDetails dragStartDetails) {
                  _startPositionHorizontal = dragStartDetails.localPosition.dx;
                  // print(
                  //     'start local dx ===== ${dragStartDetails.localPosition.dx}');
                },
                onHorizontalDragUpdate: (DragUpdateDetails dragUpdateDetails) {
                  _endPositionHorizontal = dragUpdateDetails.localPosition.dx;
                  // print('Start ============== $_startPosition');
                  // print('End ============== $_endPosition');
                  _debouncer.debounce(() {
                    if (_endPositionHorizontal > _startPositionHorizontal) {
                      // print('POINTER BERGERAK KE KANAN');
                      Game.of(context).right();
                    } else if (_endPositionHorizontal <
                        _startPositionHorizontal) {
                      // print('POINTER BERGERAK KE KIRI');
                      Game.of(context).left();
                    }
                    // print(
                    //     'update local dx ===== ${dragUpdateDetails.localPosition.dx}');
                  });
                },
                onHorizontalDragEnd: (DragEndDetails dragEndDetails) {},
                child: PlayerPanel(
                  width: playerPanelWidth,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Shake extends StatefulWidget {
  final Widget child;

  ///true to shake screen vertically
  final bool shake;

  const Shake({Key key, @required this.child, @required this.shake})
      : super(key: key);

  @override
  _ShakeState createState() => _ShakeState();
}

///摇晃屏幕
class _ShakeState extends State<Shake> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150))
          ..addListener(() {
            setState(() {});
          });
    super.initState();
  }

  @override
  void didUpdateWidget(Shake oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shake) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  v.Vector3 _getTranslation() {
    double progress = _controller.value;
    double offset = sin(progress * pi) * 1.5;
    return v.Vector3(0, offset, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.translation(_getTranslation()),
      child: widget.child,
    );
  }
}
