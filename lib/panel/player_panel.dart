import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tetris/material/briks.dart';
import 'package:tetris/material/images.dart';
import 'package:tetris/gamer/gamer.dart';

const _PLAYER_PANEL_PADDING = 6;

Size getBrikSizeForScreenWidth(double width) {
  return Size.square((width - _PLAYER_PANEL_PADDING) / GAME_PAD_MATRIX_W);
}

///the matrix of player content
class PlayerPanel extends StatelessWidget {
  //the size of player panel
  final Size size;

  PlayerPanel({Key key, @required double width})
      : assert(width != null && width != 0),
        size = Size(width, width * 2),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // debugPrint("size : $size");
    return SizedBox.fromSize(
      size: size,
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Stack(
          children: <Widget>[
            _PlayerPad(),
            _GameUninitialized(),
          ],
        ),
      ),
    );
  }
}

class _PlayerPad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: GameState.of(context).data.map((list) {
        return Row(
          children: list.map((b) {
            return b == 1
                ? const Brik.normal()
                : b == 2 ? const Brik.highlight() : const Brik.empty();
          }).toList(),
        );
      }).toList(),
    );
  }
}

class _GameUninitialized extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (GameState.of(context).states == GameStates.none) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconDragon(animate: true),
            SizedBox(height: 16),
            Text(
              "tetrita",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      );
    } else if(GameState.of(context).states == GameStates.paused){
      return Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.blue[100].withOpacity(0.6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconDragon(animate: true),
            SizedBox(height: 16),
            Text(
              "Paused",
              style: TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Game.of(context).pauseOrResume();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),
                    fixedSize: Size(100, 25),
                    minimumSize: Size(100, 25),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text('Play'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Game.of(context).reset();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),
                    fixedSize: Size(100, 25),
                    minimumSize: Size(100, 25),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      );
    } else if(GameState.of(context).states == GameStates.isStarting){
      return Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.blue[100].withOpacity(0.6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Starting in ...",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              GameState.of(context).countDown.toString(),
              style: TextStyle(fontSize: 76),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
