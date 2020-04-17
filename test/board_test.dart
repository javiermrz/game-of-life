import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_of_life/src/board.dart';
import 'package:game_of_life/src/cell.dart';
import 'package:game_of_life/src/utils/make-testable-widget.dart';

void main() {
  group('Board', () {
    testWidgets('should return updated cells', (WidgetTester tester) async {
      final setupObj = await setup(tester, [
        [Cell(true), Cell(false), Cell(true)],
        [Cell(false), Cell(false), Cell(true)],
        [Cell(true), Cell(true), Cell(true)],
      ]);
      BoardState boardState = setupObj.state;

      boardState.updateCells();

      expect(boardState.cells, [
        [Cell(false), Cell(true), Cell(false)],
        [Cell(true), Cell(false), Cell(true)],
        [Cell(false), Cell(false), Cell(true)],
      ]);
    });

    testWidgets('should return updated cells 2', (WidgetTester tester) async {
      final setupObj = await setup(tester, [
        [Cell(true), Cell(false), Cell(true)],
        [Cell(false), Cell(true), Cell(false)],
        [Cell(true), Cell(true), Cell(true)],
      ]);
      BoardState boardState = setupObj.state;

      boardState.updateCells();

      expect(boardState.cells, [
        [Cell(false), Cell(true), Cell(false)],
        [Cell(false), Cell(false), Cell(false)],
        [Cell(true), Cell(true), Cell(true)],
      ]);
    });

    testWidgets('should return updated cells 3', (WidgetTester tester) async {
      final setupObj = await setup(tester, [
        [Cell(true), Cell(false), Cell(false)],
        [Cell(true), Cell(false), Cell(false)],
        [Cell(true), Cell(false), Cell(true)],
      ]);
      BoardState boardState = setupObj.state;

      boardState.updateCells();

      expect(boardState.cells, [
        [Cell(false), Cell(false), Cell(false)],
        [Cell(true), Cell(false), Cell(false)],
        [Cell(false), Cell(true), Cell(false)],
      ]);
    });
  });
}

class SetupObj<T extends StatefulWidget> {
  T widget;
  State<T> state;

  SetupObj(this.widget, this.state);
}

Future<SetupObj> setup<T>(WidgetTester tester, List<List<Cell>> cells) async {
  await tester.pumpWidget(
      makeTestableWidget(child: Board.fromPredefinedCells(cells: cells)));
  BoardState state = tester.state(find.byType(Board));
  Board board = tester.widget<Board>(find.byType(Board));
  return SetupObj<Board>(board, state);
}
