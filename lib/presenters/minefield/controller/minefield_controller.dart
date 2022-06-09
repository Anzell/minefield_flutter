import 'dart:async';
import 'dart:math';

import 'package:minefield/core/constants/game_dificulties.dart';
import 'package:minefield/domain/entities/custom_dificulty.dart';

class MinefieldController {
  List<List<int?>> _minefield = [];
  List<List<int?>> _playMinefield = [];
  int _remainingEmptyFields = 0;

  final _minefieldStream = StreamController<List<List<int?>>>();
  final _playMinefieldStream = StreamController<List<List<int?>>>();
  final _lostStream = StreamController<bool>();
  final _winStream = StreamController<bool>();

  bool _startedGame = false;
  bool _needReload = false;

  late GameDificulties _dificulty;
  CustomDificulty? _customDificulty;

  Stream<List<List<int?>>> getMinefieldStream() {
    return _playMinefieldStream.stream;
  }

  Stream<bool> getLostStream() {
    return _lostStream.stream;
  }

  Stream<bool> getWinStream() {
    return _winStream.stream;
  }

  void initializeMinefield({required GameDificulties dificulty, CustomDificulty? customDificulty}) {
    _dificulty = dificulty;
    _customDificulty = customDificulty;
    _startedGame = false;
    _needReload = false;
    _playMinefield = _createmptyList();
    _minefield = _createmptyList();
    _remainingEmptyFields = (_getWidthCMinefield() * _getWidthLMinefield()) - _getBombsNumberMinefield();
    _playMinefieldStream.sink.add(_playMinefield);
    _lostStream.sink.add(false);
    _winStream.sink.add(false);
    _minefieldStream.sink.add(_minefield);
  }

  List<List<int?>> _createmptyList() {
    final List<List<int?>> tempField = [];
    int widthL = _getWidthLMinefield();
    int widthC = _getWidthCMinefield();

    for (int x = 0; x < widthL; x++) {
      tempField.add([]);
      for (int y = 0; y < widthC; y++) {
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
    int widthL = _getWidthLMinefield();
    int widthC = _getWidthCMinefield();
    int bombs = _getBombsNumberMinefield();

    while (bombs > 0) {
      final tempX = Random().nextInt(widthL);
      final tempY = Random().nextInt(widthC);
      if (tempField[tempX][tempY] == null) {
        tempField[tempX][tempY] = -1;
        bombs--;
      }
    }
    return tempField;
  }

  int _getWidthLMinefield() {
    switch (_dificulty) {
      case GameDificulties.easy:
        return 3;
      case GameDificulties.normal:
        return 5;
      case GameDificulties.expert:
        return 10;
      case GameDificulties.custom:
        return _customDificulty!.widthL;
      default:
        return 0;
    }
  }

  int _getWidthCMinefield() {
    switch (_dificulty) {
      case GameDificulties.easy:
        return 3;
      case GameDificulties.normal:
        return 5;
      case GameDificulties.expert:
        return 10;
      case GameDificulties.custom:
        return _customDificulty!.widthC;
      default:
        return 0;
    }
  }

  int _getBombsNumberMinefield() {
    switch (_dificulty) {
      case GameDificulties.easy:
        return 3;
      case GameDificulties.normal:
        return 8;
      case GameDificulties.expert:
        return 20;
      case GameDificulties.custom:
        return _customDificulty!.bombsNumber;
      default:
        return 0;
    }
  }

  Future<void> revealField({required int x, required int y}) async {
    if (_playMinefield[x][y] == null) {
      if (_positionIsABomb(l: x, c: y) && _startedGame) {
        _lossGame();
      } else {
        _playMinefield[x][y] = _getNumberOfBombsAroundPosition(l: x, c: y);
        _remainingEmptyFields--;
      }
      if (!_startedGame) {
        _startedGame = true;
        _minefield = _createMinefieldWithBombs();
        _minefieldStream.sink.add(_minefield);
        _playMinefield[x][y] = _getNumberOfBombsAroundPosition(l: x, c: y);
      }
      if (_playMinefield[x][y] == 0) {
        if (!_isBorder(l: x - 1, c: y - 1)) {
          revealField(x: x - 1, y: y - 1);
        }
        if (!_isBorder(l: x - 1, c: y)) {
          revealField(x: x - 1, y: y);
        }
        if (!_isBorder(l: x - 1, c: y + 1)) {
          revealField(x: x - 1, y: y + 1);
        }
        if (!_isBorder(l: x, c: y - 1)) {
          revealField(x: x, y: y - 1);
        }
        if (!_isBorder(l: x, c: y + 1)) {
          revealField(x: x, y: y + 1);
        }
        if (!_isBorder(l: x + 1, c: y - 1)) {
          revealField(x: x + 1, y: y - 1);
        }
        if (!_isBorder(l: x + 1, c: y)) {
          revealField(x: x + 1, y: y);
        }
        if (!_isBorder(l: x + 1, c: y + 1)) {
          revealField(x: x + 1, y: y + 1);
        }
      }
      _playMinefieldStream.sink.add(_playMinefield);
      if (_remainingEmptyFields == 0) {
        _winGame();
      }
    }
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
    if (_isBorder(l: l, c: c)) {
      return false;
    }
    return _minefield[l][c] == -1;
  }

  bool _isBorder({required int l, required int c}) {
    if (l < 0 || c < 0 || l >= _minefield.length || c >= _minefield[l].length) {
      return true;
    }
    return false;
  }

  void _revealAllBombsPosition() {
    for (int x = 0; x < _minefield.length; x++) {
      for (int y = 0; y < _minefield[x].length; y++) {
        if (_minefield[x][y] == -1) {
          _playMinefield[x][y] = -1;
        }
      }
    }
    _playMinefieldStream.sink.add(_playMinefield);
  }

  void _lossGame() {
    _lostStream.sink.add(true);
    _revealAllBombsPosition();
    _needReload = true;
    Future.delayed(Duration(seconds: 5), () {
      if(_needReload){
        _lostStream.sink.add(false);
        initializeMinefield(dificulty: _dificulty, customDificulty: _customDificulty);
      }
    });
  }

  void _winGame() {
    _winStream.sink.add(true);
    _revealAllBombsPosition();
    _needReload = true;
    Future.delayed(Duration(seconds: 5), () {
     if(_needReload){
       _winStream.sink.add(false);
       initializeMinefield(dificulty: _dificulty, customDificulty: _customDificulty);
     }
    });
  }
}
