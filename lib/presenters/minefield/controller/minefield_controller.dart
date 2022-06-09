import 'dart:async';
import 'dart:math';

import 'package:minefield/core/constants/game_dificulties.dart';

class MinefieldController {
  List<List<int?>> _minefield = [];
  List<List<int?>> _playMinefield = [];

  final _minefieldStream = StreamController<List<List<int?>>>();
  final _playMinefieldStream = StreamController<List<List<int?>>>();
  final _lostStream = StreamController<bool>();

  bool _startedGame = false;

  late GameDificulties _dificulty;

  Stream<List<List<int?>>> getMinefieldStream() {
    return _playMinefieldStream.stream;
  }

  Stream<bool> getLostStream() {
    return _lostStream.stream;
  }

  void initializeMinefield({required GameDificulties dificulty}) {
    _dificulty = dificulty;
    _playMinefield = _createmptyList();
    _minefield = _createmptyList();
    _playMinefieldStream.sink.add(_playMinefield);
    _minefieldStream.sink.add(_minefield);
  }

  List<List<int?>> _createmptyList() {
    final List<List<int?>> tempField = [];
    int width = _getWidthMinefield();

    for (int x = 0; x < width; x++) {
      tempField.add([]);
      for (int y = 0; y < width; y++) {
        tempField[x].add(null);
      }
    }
    return tempField;
  }

  List<List<int?>> _createMinefieldWithBombs() {
    List<List<int?>> tempField = _createmptyList();
    for (int l = 0; l < tempField.length; l++) {
      for (int c = 0; c < tempField[l].length; c++) {
        tempField[l][c] = _playMinefield[l][c];
      }
    }
    int width = _getWidthMinefield();
    int bombs = _getBombsNumberMinefield();

    while (bombs > 0) {
      final tempX = Random().nextInt(width);
      final tempY = Random().nextInt(width);
      if (tempField[tempX][tempY] == null) {
        tempField[tempX][tempY] = -1;
        bombs--;
      }
    }
    return tempField;
  }

  int _getWidthMinefield() {
    switch (_dificulty) {
      case GameDificulties.easy:
        return 3;
      case GameDificulties.normal:
        return 5;
      case GameDificulties.expert:
        return 10;
      default:
        return 0;
    }
  }

  int _getBombsNumberMinefield() {
    switch (_dificulty) {
      case GameDificulties.easy:
        return 3;
      case GameDificulties.normal:
        return 6;
      case GameDificulties.expert:
        return 20;
      default:
        return 0;
    }
  }

  Future<void> revealField({required int x, required int y}) async {
    if (_positionIsABomb(l: x, c: y) && _startedGame) {
      _lostStream.sink.add(true);
      _playMinefield[x][y] = -1;
    } else {
      _playMinefield[x][y] = _getNumberOfBombsAroundPosition(l: x, c: y);
    }
    if (!_startedGame) {
      _startedGame = true;
      _minefield = _createMinefieldWithBombs();
      _minefieldStream.sink.add(_minefield);
      _playMinefield[x][y] = _getNumberOfBombsAroundPosition(l: x, c: y);
    }
    _playMinefieldStream.sink.add(_playMinefield);
  }

  int _getNumberOfBombsAroundPosition({required int l, required int c}) {
    int countBombs = 0;
    if (_positionIsABomb(l: l - 1, c: c - 1)) {
      countBombs++;
    }
    if (_positionIsABomb(l: l - 1, c: c)) {
      countBombs++;
    }
    if (_positionIsABomb(l: l - 1, c: c + 1)) {
      countBombs++;
    }
    if (_positionIsABomb(l: l, c: c - 1)) {
      countBombs++;
    }
    if (_positionIsABomb(l: l, c: c + 1)) {
      countBombs++;
    }
    if (_positionIsABomb(l: l + 1, c: c - 1)) {
      countBombs++;
    }
    if (_positionIsABomb(l: l + 1, c: c)) {
      countBombs++;
    }
    if (_positionIsABomb(l: l + 1, c: c + 1)) {
      countBombs++;
    }
    return countBombs;
  }

  bool _positionIsABomb({required int l, required int c}) {
    if (l < 0 || c < 0 || l >= _minefield.length || c >= _minefield[l].length) {
      return false;
    }
    return _minefield[l][c] == -1;
  }
}

/* playMinefield
null, null, null
null, null, null
null, null, null
 */

/* minefield
null, -1, null
-1, null, -1
null, null, null
 */