import 'package:flutter/material.dart';
import 'package:game_of_life/src/board.dart';
import 'package:game_of_life/src/utils/size-config.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameOfLife(),
    );
  }
}

class GameOfLife extends StatelessWidget {
  static final _boardStateKey = GlobalKey<BoardState>();
  final Board _board = Board(key: _boardStateKey, rows: 50, columns: 50);

  _reset() {
    _boardStateKey.currentState.resetCells();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Game of Life"),
      ),
      body: Column(
        children: <Widget>[
          this._board,
          FlatButton(
            child: Text(
              "Reset",
            ),
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: this._reset,
          )
        ],
      ),
    );
  }
}
