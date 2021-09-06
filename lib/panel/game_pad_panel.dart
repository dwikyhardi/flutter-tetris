import 'package:flutter/material.dart';
import 'package:tetris/gamer/gamer.dart';

class GamePadPanel extends StatelessWidget {
  const GamePadPanel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          Transform.translate(
            offset: Offset(10, MediaQuery.of(context).size.height * 0.05),
            child: Column(
              children: [
                InkWell(
                  onTap: () => Game.of(context).rotate(),
                  borderRadius: BorderRadius.circular(100),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    elevation: 2,
                    color: Colors.blue[50],
                    child: Icon(
                      Icons.rotate_left,
                      size: 50,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Game.of(context).drop();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    minimumSize: Size(100, 50),
                  ),
                  child: Text('Drop'),
                ),
              ],
            ),
          ),
          Spacer(),
          Row(
            children: [
              InkWell(
                onTap: () => Game.of(context).left(),
                borderRadius: BorderRadius.circular(100),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  elevation: 2,
                  color: Colors.blue[50],
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    size: 50,
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, 65),
                child: InkWell(
                  onTap: () => Game.of(context).down(enableSounds: true),
                  borderRadius: BorderRadius.circular(100),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    elevation: 2,
                    color: Colors.blue[50],
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 50,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => Game.of(context).right(),
                borderRadius: BorderRadius.circular(100),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  elevation: 2,
                  color: Colors.blue[50],
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    size: 50,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
