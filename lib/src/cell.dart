import 'dart:math';

class Cell {
  bool _isAlive;

  Cell.fromRandomLifeStatus() : this._isAlive = new Random().nextInt(5) == 0;

  Cell(this._isAlive);

  bool get isAlive => _isAlive;
  die() => this._isAlive = false;
  revive() => this._isAlive = true;

  bool operator ==(otherCell) =>
      otherCell is Cell && this.isAlive == otherCell.isAlive;

  int get hashCode => this._isAlive.hashCode;
}
