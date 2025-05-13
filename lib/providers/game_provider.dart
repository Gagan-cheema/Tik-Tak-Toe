import 'package:flutter/material.dart';
import 'package:tic_tak_toe/model/board.dart';

class GameProvider with ChangeNotifier {
  final Board _board = Board();
  bool _showWinningAnimation = false;

  Board get board => _board;
  bool get showWinningAnimation => _showWinningAnimation;

  void makeMove(int index) {
    if (_board.makeMove(index)) {
      if (_board.winner != null && _board.winner != 'Draw') {
        _showWinningAnimation = true;
      }
      notifyListeners();
    }
  }

  void resetGame() {
    _board.reset();
    _showWinningAnimation = false;
    notifyListeners();
  }
}
