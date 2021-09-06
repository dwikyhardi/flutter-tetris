import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tetris/gamer/block.dart';
import 'package:tetris/gamer/gamer.dart';
import 'package:tetris/generated/i18n.dart';
import 'package:tetris/material/briks.dart';
import 'package:tetris/material/images.dart';
import 'package:tetris/util/cupertino_radio_choice.dart';

class StatusPanel extends StatelessWidget {
  final double width;

  StatusPanel(this.width);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child:
          GameState.of(context).gameControllerType == GameControllerType.touch
              ? _statusTouchController(context)
              : _statusGamePadController(context),
    );
  }

  Widget _statusGamePadController(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Text(S.of(context).points,
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Number(number: GameState.of(context).points),
          ],
        ),
        SizedBox(height: 10),
        Column(
          children: [
            Text(S.of(context).cleans,
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Number(number: GameState.of(context).cleared),
          ],
        ),
        SizedBox(height: 10),
        Column(
          children: [
            Text(S.of(context).level,
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Number(number: GameState.of(context).level),
          ],
        ),
        SizedBox(height: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.of(context).next,
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            _NextBlock(),
          ],
        ),
        _GameStatus(),
      ],
    );
  }

  Widget _statusTouchController(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(S.of(context).points,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Number(number: GameState.of(context).points),
              ],
            ),
            Column(
              children: [
                Text(S.of(context).cleans,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Number(number: GameState.of(context).cleared),
              ],
            ),
            Column(
              children: [
                Text(S.of(context).level,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Number(number: GameState.of(context).level),
              ],
            ),
            Column(
              children: [
                Text(S.of(context).next,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                _NextBlock(),
              ],
            ),
          ],
        ),
        _GameStatus(),
      ],
    );
  }
}

class _NextBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<List<int>> data = [List.filled(4, 0), List.filled(4, 0)];
    final next = BLOCK_SHAPES[GameState.of(context).next.type];
    for (int i = 0; i < next.length; i++) {
      for (int j = 0; j < next[i].length; j++) {
        data[i][j] = next[i][j];
      }
    }
    return Column(
      children: data.map((list) {
        return Row(
          children: list.map((b) {
            return b == 1 ? const Brik.normal() : const Brik.empty();
          }).toList(),
        );
      }).toList(),
    );
  }
}

class _GameStatus extends StatefulWidget {
  @override
  _GameStatusState createState() {
    return new _GameStatusState();
  }
}

class _GameStatusState extends State<_GameStatus> {
  Timer _timer;

  bool _colonEnable = true;

  int _minute;

  int _hour;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      setState(() {
        _colonEnable = !_colonEnable;
        _minute = now.minute;
        _hour = now.hour;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GameState.of(context).gameControllerType == GameControllerType.touch
        ? _gameStateTouch(context)
        : _gameStateGamePad(context);
  }

  Widget _gameStateGamePad(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Game.of(context).pause();
              },
              child: Icon(
                GameState.of(context).states == GameStates.paused
                    ? Icons.play_arrow
                    : Icons.pause,
                size: 36,
              ),
            ),
            GestureDetector(
              onTap: () {
                Game.of(context).soundSwitch();
              },
              child: Icon(
                GameState.of(context).muted
                    ? Icons.volume_up_rounded
                    : Icons.volume_off_rounded,
                size: 36,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Number(number: _hour, length: 2, padWithZero: true),
            IconColon(enable: _colonEnable),
            Number(number: _minute, length: 2, padWithZero: true),
          ],
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Game.of(context).reset();
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            fixedSize: Size(100, 25),
            minimumSize: Size(100, 25),
            padding: EdgeInsets.zero,
          ),
          child: Text('Reset'),
        ),
        ElevatedButton(
          onPressed: () {
            showSettings();
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            fixedSize: Size(100, 25),
            minimumSize: Size(100, 25),
            padding: EdgeInsets.zero,
          ),
          child: Text('Settings'),
        ),
      ],
    );
  }

  Widget _gameStateTouch(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Game.of(context).pause();
          },
          child: Icon(
            GameState.of(context).states == GameStates.paused
                ? Icons.play_arrow
                : Icons.pause,
            size: 36,
          ),
        ),
        GestureDetector(
          onTap: () {
            Game.of(context).soundSwitch();
          },
          child: Icon(
            GameState.of(context).muted
                ? Icons.volume_up_rounded
                : Icons.volume_off_rounded,
            size: 36,
          ),
        ),
        Spacer(),
        ElevatedButton(
          onPressed: () {
            Game.of(context).reset();
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            fixedSize: Size(100, 25),
            minimumSize: Size(100, 25),
            padding: EdgeInsets.zero,
          ),
          child: Text('Reset'),
        ),
        Spacer(),
        ElevatedButton(
          onPressed: () {
            showSettings();
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            fixedSize: Size(100, 25),
            minimumSize: Size(100, 25),
            padding: EdgeInsets.zero,
          ),
          child: Text('Settings'),
        ),
        Spacer(),
        Number(number: _hour, length: 2, padWithZero: true),
        IconColon(enable: _colonEnable),
        Number(number: _minute, length: 2, padWithZero: true),
      ],
    );
  }

  void showSettings() {
    showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext buildContext) {
          return CupertinoAlertDialog(
            title: Text('Setting'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Controller',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                CupertinoRadioChoice(
                  choices: {
                    GameControllerType.touch: 'Touch',
                    GameControllerType.gamePad: 'Game Pad'
                  },
                  onChange: (value) {
                    if (value != null) {
                      Game.of(context).setGameControllerType(value);
                    }
                  },
                  initialKeyValue: GameState.of(context).gameControllerType,
                ),
              ],
            ),
          );
        });
  }
}
