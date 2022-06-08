import 'dart:async';
import 'dart:math';

import 'package:minefield/core/constants/game_dificulties.dart';

class MinefieldController {
  List<List<int?>> _minefield = [];
  List<List<int?>> _playMinefield = [];

  final _minefieldStream = StreamController<List<List<int?>>>();
  final _playMinefieldStream = StreamController<List<List<int?>>>();
  final _lostStream = StreamController<bool>();

  Stream<List<List<int?>>> getMinefieldStream() {
    return _playMinefieldStream.stream;
  }

  Stream<bool> getLostStream() {
    return _lostStream.stream;
  }

  void initializeMinefield({required GameDificulties dificulty}) {
    _playMinefield = _createmptyList(dificulty: dificulty);
    _minefield = _createMinefieldWithBombs(dificulty: dificulty);
    _playMinefieldStream.sink.add(_playMinefield);
    _minefieldStream.sink.add(_minefield);
  }

  List<List<int?>> _createmptyList({required GameDificulties dificulty}) {
    final List<List<int?>> tempField = [];
    int width = _getWidthMinefield(dificulty: dificulty);

    for (int x = 0; x < width; x++) {
      tempField.add([]);
      for (int y = 0; y < width; y++) {
        tempField[x].add(null);
      }
    }
    return tempField;
  }

  List<List<int?>> _createMinefieldWithBombs({required GameDificulties dificulty}) {
    final tempField = _createmptyList(dificulty: dificulty);
    int width = _getWidthMinefield(dificulty: dificulty);
    int bombs = _getBombsNumberMinefield(dificulty: dificulty);

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

  int _getWidthMinefield({required GameDificulties dificulty}) {
    switch (dificulty) {
      case GameDificulties.easy:
        return 3;
      default:
        return 0;
    }
  }

  int _getBombsNumberMinefield({required GameDificulties dificulty}) {
    switch (dificulty) {
      case GameDificulties.easy:
        return 3;
      default:
        return 0;
    }
  }

  Future<void> revealField({required int x, required int y}) async {
    _playMinefield[x][y] = _minefield[x][y];
    if (_minefield[x][y] == -1) {
      _lostStream.sink.add(true);
    } else {
      _playMinefieldStream.sink.add(_playMinefield);
      _playMinefield[x][y] = 0;
    }
  }
}
