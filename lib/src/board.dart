import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_of_life/src/cell.dart';
import 'package:game_of_life/src/utils/map-to-list-extension.dart';
import 'package:game_of_life/src/utils/size-config.dart';

class Board extends StatefulWidget {
  final int _columns;
  final int _rows;
  final List<List<Cell>> _initialCells;

  Board({key, @required int rows, @required int columns})
      : _columns = columns,
        _rows = rows,
        _initialCells = null,
        super(key: key);

  Board.fromPredefinedCells({key, List<List<Cell>> cells})
      : assert(cells.length > 0 && cells.every((row) => row.length > 0)),
        _columns = cells.length,
        _rows = cells[0].length,
        _initialCells = cells,
        super(key: key);

  @override
  BoardState createState() => BoardState();
}

class BoardState extends State<Board> {
  List<List<Cell>> _cells;
  Timer _timer;

  List<List<Cell>> get cells => this._cells;

  @override
  void initState() {
    this.resetCells();
    this._timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      this.updateCells();
    });
    super.initState();
  }

  @override
  void dispose() {
    this._timer?.cancel();
    super.dispose();
  }

  resetCells() {
    this._cells = widget._initialCells ??
        List.generate(
            this.widget._columns,
            (col) => List.generate(
                this.widget._rows, (row) => Cell.fromRandomLifeStatus()));
  }

  updateCells() {
    // Clonamos las celdas (por valor, en vez de por referencia)
    List<List<Cell>> updatedCells = List<List<Cell>>.of(
        this._cells.map((e) => e.mapToList<Cell>((e) => Cell(e.isAlive))));

    for (int col = 0; col < this.widget._columns; col++) {
      for (int row = 0; row < this.widget._rows; row++) {
        int aliveNeighbours = this._getAliveNeighbours(col, row);
        bool isCurrentCellAlive = this._cells[col][row].isAlive;

        if (!isCurrentCellAlive && aliveNeighbours == 3) {
          updatedCells[col][row].revive();
        } else if (isCurrentCellAlive &&
            aliveNeighbours != 2 &&
            aliveNeighbours != 3) {
          updatedCells[col][row].die();
        }
      }
    }

    setState(() {
      this._cells = updatedCells;
    });
  }

  int _getAliveNeighbours(int col, int row) {
    int aliveNeighbours = 0;
    for (int rowSummand = -1; rowSummand <= 1; rowSummand++) {
      for (int colSummand = -1; colSummand <= 1; colSummand++) {
        final neighbourCellRow = row + rowSummand;
        final neighbourCellColumn = col + colSummand;
        bool isOutOfRange = (neighbourCellRow) < 0 ||
            (neighbourCellRow) > (this.widget._rows - 1) ||
            (neighbourCellColumn) < 0 ||
            (neighbourCellColumn) > (this.widget._columns - 1);
        bool isNeighbourCell = rowSummand != 0 || colSummand != 0;

        if (!isOutOfRange &&
            isNeighbourCell &&
            this._cells[neighbourCellColumn][neighbourCellRow].isAlive) {
          aliveNeighbours++;
        }
      }
    }

    return aliveNeighbours;
  }

  @override
  bool operator ==(other) =>
      other is Board &&
      this.widget._columns == other._columns &&
      this.widget._rows == other._rows;

  int get hashCode =>
      this.cells.hashCode *
      this.widget._columns.hashCode *
      this.widget._rows.hashCode;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: List.generate(
            widget._columns,
            (col) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget._rows,
                      (row) => this._buildCell(context, this._cells[col][row])),
                )));
  }

  Widget _buildCell(BuildContext context, Cell cell) {
    double squareWidth = SizeConfig.blockSizeHorizontal * 1.5;
    return Container(
      width: squareWidth,
      height: squareWidth,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.5),
        color: cell.isAlive ? Colors.blue : Colors.white,
      ),
    );
  }
}
